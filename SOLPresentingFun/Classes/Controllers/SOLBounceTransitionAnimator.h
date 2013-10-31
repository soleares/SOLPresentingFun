//
//  SOLBounceTransitionAnimator.h
//  PresentingFun
//
//  Created by Jesse Wolff on 10/31/13.
//  Copyright (c) 2013 Soleares, Inc. All rights reserved.
//

@import Foundation;
#import "SOLSlideTransitionAnimator.h"

@interface SOLBounceTransitionAnimator : SOLSlideTransitionAnimator

@property (nonatomic, assign) CGFloat dampingRatio;
@property (nonatomic, assign) CGFloat velocity;

@end
