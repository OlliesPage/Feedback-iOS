//
//  TextFieldDelegate.m
//  Feedback
//
//  Created by Oliver Hayman on 26/07/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "TextFieldDelegate.h"

@implementation TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
