//
//  SinGraphGLKViewController.m
//  OpenGLSinGraph
//
//  Generates a sine graph that can be manipulated using a UIPinchGesture
//  Currently does not draw any form of axis.
//
//  Created by Oliver Hayman on 16/07/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

#import "SinGraphGLKViewController.h"
#pragma mark private stuff
enum
{
    UNIFORM_SCALE_X,
    NUM_UNIFORMS
};

@interface SinGraphGLKViewController () {
    // shader program and attribute buffer
    GLuint _program;
    GLuint _vertexBuffer;
    GLKVector2 *graph;
    GLushort graphCount;
    size_t graphSize;
    
    // uniform scale factor
    GLfloat _uniform_scale_x;
    GLint uniforms[NUM_UNIFORMS];
    
    CGFloat lastPinchScale;
}

@property (strong, nonatomic) EAGLContext *context;

@end

#pragma mark -

@implementation SinGraphGLKViewController

#pragma mark GLKView initalization methods and memory management
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if(!self.context)
    {
        NSLog(@"Failed to set context!");
        abort(); // not graceful, but correect
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    UIPinchGestureRecognizer *pinchy = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchOccured:)];
    [view addGestureRecognizer:pinchy];
    lastPinchScale = 1.f;
    _uniform_scale_x = 1.f;
    
    [self setupGL]; // pass off to my GL setup class
}

- (void)dealloc
{
    // destroy the OpenGL stuff before removing the context
    self.guestureDelegate = NULL;
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        self.guestureDelegate = NULL;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    
    // Dispose of any resources that can be recreated.
}

- (void)setGraphData:(GLKVector2[])data withSize:(size_t)size {
    graphSize = size;
    graphCount = size/sizeof(GLKVector2);
    //graph = malloc(size);
    //memcpy(graph, data, size);
    graph = data;
}

#pragma mark UIPinchGestureRecogniser Selector Method

- (void)pinchOccured:(UIPinchGestureRecognizer *)gesture {
    
    if ([gesture numberOfTouches] > 1) {
        
        UIView *theView = [gesture view];
        CGPoint locationOne = [gesture locationOfTouch:0 inView:theView];
        CGPoint locationTwo = [gesture locationOfTouch:1 inView:theView];
        
        double gradient;
        if (locationOne.x == locationTwo.x) {
            // perfect vertical line
            // not likely, but to avoid dividing by 0 in the slope equation
            gradient = 1000.0;
        } else {
            gradient = ABS((locationTwo.y - locationOne.y)/(locationTwo.x - locationOne.x));
        }
        
        if (gradient > 1.7) {
            // Vertical pinch - scale in the Y
            if(self.guestureDelegate)
                [self.guestureDelegate setYScale:[gesture scale]];
        } else {
            // if we're not scaling just y, scale x
            _uniform_scale_x += [gesture scale] - lastPinchScale;
            if(_uniform_scale_x < 0.1)
                _uniform_scale_x = 0.1f;
            if(_uniform_scale_x > 2.0)
                _uniform_scale_x = 2.f;
            lastPinchScale = [gesture scale];
            
            if(self.twin != nil) {
                [self.twin scaleX:_uniform_scale_x];
            }
        }
    }  // if numberOfTouches
    
    if(gesture.state == UIGestureRecognizerStateEnded) {
        lastPinchScale = 1.f;
        if(self.guestureDelegate)
            [self.guestureDelegate gestureDidFinish];
    }
}

- (void)scaleX:(GLfloat)scale {
    _uniform_scale_x = scale;
}

#pragma mark - OpenGL ES Methods

#pragma mark GLKView delegate method

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // set a color for the background - then call glClear to set the background to that "clearColor"
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);// | GL_DEPTH_BUFFER_BIT); - I've not set the depth buffer
    
    glUseProgram(_program);
    
    glUniform1f(uniforms[UNIFORM_SCALE_X], _uniform_scale_x);
    
    // here we're enabling the Vertex Attribute for Position
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    // next pass along the array that contains the points to draw
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, graph);
    // and draw all of them
    glDrawArrays(GL_LINE_STRIP, 0, graphCount); // we did not use arrays but rather indexes
}

#pragma mark OpenGL ES 2 setup and tear-down functions

- (void)setupGL {
    [EAGLContext setCurrentContext:self.context];
    
    [self loadShaders]; // load the shaders and compile the glProgram
}

- (void)tearDownGL {
    [EAGLContext setCurrentContext:self.context];
    
    // delete the buffers as they will no longer be needed
    glDeleteBuffers(1, &_vertexBuffer);
    
    // this prevents the OpenGL ES program causing memory leaks
    if(_program)
    {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram(); // again, like our GLProgram, create a new program
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    } // again try to fetch the shader vertex file from the main bundle like in our GLProgram
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    } // and the same for the fragment shader (pixel shader? - bad name, but shades pixels)
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader); // note here we're not linking, this is because you need at add attributes first
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    
    // Link program - now we have all the attributes set, we can link the program
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    uniforms[UNIFORM_SCALE_X] = glGetUniformLocation(_program, "scale_x");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
