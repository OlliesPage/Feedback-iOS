//
//  UILimitBlock.m
//  Feedback
//
//  Created by Oliver Hayman on 29/07/2012.
//  Updated by Oliver Hayman on 29/07/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

#import "UILimitBlock.h"

@interface UILimitBlock () <UITextFieldDelegate>

@property (strong) UILabel *negLabel;
@property (strong) UILabel *posLabel;
@property (strong) UITextField *valueText;

@end

@implementation UILimitBlock
@synthesize limiting = _limiting;
@synthesize value = _value;

- (void)setValue:(double)value {
    self.negLabel.text = [NSString stringWithFormat:@"%.1f",-1*value];
    self.posLabel.text = [NSString stringWithFormat:@"%.1f",value];
    _value = value; // update the value I hold
    if (self.delegate) {
        [self.delegate limitChange:self];
    }
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.opaque = YES; // ensure it's known that I'm opaque
        self.backgroundColor = [UIColor whiteColor];
        [self setupLabels];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.opaque = YES; // ensure it's known that I'm opaque
        [self setupLabels];
    }
    return self;
}

- (void)setupLabels {
    self.autoresizesSubviews = YES;
    self.limiting = NO;
    self.negLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height*0.5-10.5, self.bounds.size.width*0.45, 21)];
    self.negLabel.adjustsFontSizeToFitWidth = YES;
    self.negLabel.text = @"-100";
    [self addSubview:self.negLabel];
    
    self.posLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-self.bounds.size.width*0.45, self.bounds.size.height*0.5-10.5, self.bounds.size.width*0.45, 21)];
    self.posLabel.adjustsFontSizeToFitWidth = YES;
    self.posLabel.textAlignment = NSTextAlignmentRight;
    self.posLabel.text = @"100";
    [self addSubview:self.posLabel];
    
    self.valueText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.valueText.hidden = YES;
    self.valueText.returnKeyType = UIReturnKeyDone;
    self.valueText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.valueText.enablesReturnKeyAutomatically = true;
    self.valueText.textAlignment = NSTextAlignmentCenter;
    self.valueText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.valueText.backgroundColor = [UIColor whiteColor];
    self.valueText.delegate = self;
    [self addSubview:self.valueText];
    
    
//    newTextField.borderStyle = UITextBorderStyle.RoundedRect
//    newTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
//    newTextField.tag = tag
//    newTextField.text = text
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // change the view to a TextView
    NSLog(@"A touch event occured");
    self.valueText.hidden = NO;
    [self.valueText becomeFirstResponder];
    //self.hidden = YES;
}

- (void)hideSelf
{
    self.hidden = YES;
}

// add on touch event to show textbox allowing update of the limit value?

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowOpacity = 0.8;
    if(self.limiting)
        [[UIColor redColor] setStroke];
    else
        [[UIColor blackColor] setStroke];
    CGContextMoveToPoint(context, 0, self.bounds.size.height*0.75);
    CGContextAddLineToPoint(context, self.bounds.size.width*0.45, self.bounds.size.height*0.75);
    CGContextAddLineToPoint(context, self.bounds.size.width*0.55, self.bounds.size.height*0.25);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height*0.25);
    CGContextStrokePath(context);
}

#pragma mark - UITextViewDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.value = [textField.text doubleValue];
    textField.hidden = YES;
    return YES;
}

@end
