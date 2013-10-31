//
//  SOLDropViewController.m
//  PresentingFun
//
//  Created by Jesse Wolff on 10/31/13.
//  Copyright (c) 2013 Soleares, Inc. All rights reserved.
//

#import "SOLDropViewController.h"

@implementation SOLDropViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Background gradient
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(id)[UIColor blackColor].CGColor,
                             (id)[UIColor colorWithRed:0.561 green:0.839 blue:0.922 alpha:1].CGColor];
    gradientLayer.cornerRadius = 4;
    gradientLayer.masksToBounds = YES;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

@end
