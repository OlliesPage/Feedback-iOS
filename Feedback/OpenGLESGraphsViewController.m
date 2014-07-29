//
//  OpenGLESGraphsViewController.m
//  Feedback
//
//  Created by Oliver Hayman on 17/07/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

#import "OpenGLESGraphsViewController.h"
#import <GLKit/GLKit.h>

#define NO_DATA_POINTS 4000

@interface OpenGLESGraphsViewController () {
    GLKVector2 inputData[NO_DATA_POINTS];
    GLKVector2 outputData[NO_DATA_POINTS];
    float scale_y; // must be kept between zero and 1
    float _last_scale;
}

@property (weak) SinGraphGLKViewController *leftGraph;
@property (weak) SinGraphGLKViewController *rightGraph;
@end

@implementation OpenGLESGraphsViewController
@synthesize systemModel = _systemModel;

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self) {
        scale_y = 0.5f;
        _last_scale = 1.f;
#ifdef VERBOSE
#warning Verbose logging will cause the OpenGL ES drawing to lag due to logging in the calculateOutputForInput function call
#endif
    }
    return self;
}

- (void)setSystemModel:(feedbackModel *)model {
    _systemModel = model;
    for(int i = 0; i < NO_DATA_POINTS; i++) {
        float x = (i-NO_DATA_POINTS/2) / 100.0; // (i - 1000.0) / 100.0; gives range -10 to 10
        inputData[i].x = outputData[i].x = x; // the x is the same for both
        inputData[i].y = scale_y*sin(x*(19.0/6.0)-M_PI);// * 10.0) / (1.0 + x * x);
        outputData[i].y = [_systemModel calculateOutputForInput:inputData[i].y withDistrubance:0.f]; // no disturbance yet
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        // stop holding pointers to these
        self.leftGraph = nil;
        self.rightGraph = nil;
    }
}

- (void)setYScale:(GLfloat)scale {
    /*
     * This function is called when a horizontal zoom is required, it scales the amplitude of the sine wave
     * Note: each time it calls calculateOutputForInput, if verbose logging is on this function will LAG
     */
    scale_y += scale - _last_scale;
    if(scale_y > 1) scale_y = 1;
    if(scale_y < -1) scale_y = -1;
    _last_scale = scale;
    for(int i = 0; i < NO_DATA_POINTS; i++) {
        float x = (i-NO_DATA_POINTS/2) / 100.0; // (i - 1000.0) / 100.0; gives range -10 to 10
        inputData[i].x = outputData[i].x = x; // the x is the same for both
        inputData[i].y = scale_y*sin(x*(19.0/6.0)-M_PI);// * 10.0) / (1.0 + x * x);
        outputData[i].y = [_systemModel calculateOutputForInput:inputData[i].y withDistrubance:0.f]; // no disturbance yet
    }
    [self.leftGraph setGraphData:inputData withSize:sizeof(inputData)];
    [self.rightGraph setGraphData:outputData withSize:sizeof(outputData)];
}

- (void)gestureDidFinish {
    _last_scale = 1.f;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"leftGraphSegue"]) {
        // we have the SinGraphGLKViewController
        self.leftGraph = (SinGraphGLKViewController *)[segue destinationViewController];
        self.leftGraph.guestureDelegate = self;
        [self.leftGraph setGraphData:inputData withSize:sizeof(inputData)]; // send the data
    }
    
    if([segue.identifier isEqualToString:@"rightGraphSegue"])
    {
        self.rightGraph  = (SinGraphGLKViewController *)[segue destinationViewController];
        self.rightGraph.guestureDelegate = self;
        self.leftGraph.twin = self.rightGraph;
        self.rightGraph.twin = self.leftGraph;
        [self.rightGraph setGraphData:outputData withSize:sizeof(outputData)]; // send the data
    }
}


- (IBAction)returnToModel
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:NO]; // remove myself from the navigation controller
}

- (void)dealloc
{
    self.leftGraph = nil;
    self.rightGraph = nil;
}

@end
