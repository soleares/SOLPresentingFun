//
//  SOLOptionsViewController.m
//  PresentingFun
//
//  Created by Jesse Wolff on 10/31/13.
//  Copyright (c) 2013 Soleares, Inc. All rights reserved.
//

#import "SOLFromEdgeViewController.h"
#import "SOLOptions.h"
#import "SOLOptionsViewController.h"
#import "SOLSlideTransitionAnimator.h"

typedef NS_ENUM(NSInteger, Tag) {
    TagDurationField        = 10,
    TagDampingRatioField    = 20,
    TagSpringVelocityField  = 30,
    TagSpringDurationField  = 40
};

@interface SOLOptionsViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UISwitch *transitionsSwitch;
@property (nonatomic, weak) IBOutlet UITextField *durationField;
@property (nonatomic, weak) IBOutlet UILabel *fromEdgeLabel;
@property (nonatomic, weak) IBOutlet UITextField *dampingRatioField;
@property (nonatomic, weak) IBOutlet UITextField *springVelocityField;
@property (nonatomic, weak) IBOutlet UITextField *springDurationField;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@end

@implementation SOLOptionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Format #.##
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMinimumFractionDigits:2];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setAlwaysShowsDecimalSeparator:YES];
    self.numberFormatter = numberFormatter;
    
    SOLOptions *options = [SOLOptions sharedOptions];
    self.transitionsSwitch.on = options.pushTransitions;
    self.durationField.text = [numberFormatter stringFromNumber:@(options.duration)];
    self.dampingRatioField.text = [numberFormatter stringFromNumber:@(options.dampingRatio)];
    self.springVelocityField.text = [numberFormatter stringFromNumber:@(options.velocity)];
    self.springDurationField.text = [numberFormatter stringFromNumber:@(options.springDuration)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SOLOptions *options = [SOLOptions sharedOptions];
    self.fromEdgeLabel.text = [SOLSlideTransitionAnimator edgeDisplayNames][@(options.edge)];
}

- (IBAction)switchToggled:(id)sender
{
    SOLOptions *options = [SOLOptions sharedOptions];
    options.pushTransitions = self.transitionsSwitch.on;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Format the text to #.##. Set it to zero if the user entered something non-numeric.
    NSNumber *value = [self.numberFormatter numberFromString:textField.text];
    value = value ?: @0;
    textField.text = [self.numberFormatter stringFromNumber:value];
    
    SOLOptions *options = [SOLOptions sharedOptions];
    
    switch (textField.tag) {
        case TagDurationField: {
            options.duration = [value doubleValue];
            break;
        }
        case TagDampingRatioField: {
            options.dampingRatio = [value doubleValue];
            break;
        }
        case TagSpringVelocityField: {
            options.velocity = [value doubleValue];
            break;
        }
        case TagSpringDurationField: {
            options.springDuration = [value doubleValue];
            break;
        }
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
