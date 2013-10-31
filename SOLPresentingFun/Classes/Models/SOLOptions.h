//
//  SOLOptions.h
//  PresentingFun
//
//  Created by Jesse Wolff on 10/31/13.
//  Copyright (c) 2013 Soleares, Inc. All rights reserved.
//

@import Foundation;
#import "SOLSlideTransitionAnimator.h"

@interface SOLOptions : NSObject

// General
@property (nonatomic, assign) BOOL pushTransitions;
@property (nonatomic, assign) NSTimeInterval duration;

// Slide
@property (nonatomic, assign) SOLEdge edge;

// Spring
@property (nonatomic, assign) CGFloat dampingRatio;
@property (nonatomic, assign) CGFloat velocity;
@property (nonatomic, assign) NSTimeInterval springDuration;

+ (instancetype)sharedOptions;

@end
