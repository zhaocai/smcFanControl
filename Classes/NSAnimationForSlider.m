//
//  NSAnimationForSlider.m
//  smcFanControl
//
//  Created by Dominik Pich on 9/15/12.
//
//

#import "NSAnimationForSlider.h"

@implementation NSAnimationForSlider

@synthesize delegateSlider;
@synthesize animateToValue;

-(void)dealloc
{
    [delegateSlider release], delegateSlider = nil;
    [super dealloc];
}

-(void)startAnimation
{
    //Setup initial values for every animation
    initValue = [delegateSlider floatValue];
    if (animateToValue >= initValue) {
        min = initValue;
        max = animateToValue;
    } else  {
        min = animateToValue;
        max = initValue;
    }
    
    [super startAnimation];
}


- (void)setCurrentProgress:(NSAnimationProgress)progress
{
    [super setCurrentProgress:progress];
    
    double newValue;
    if (animateToValue >= initValue) {
        newValue = min + (max - min) * progress;
    } else  {
        newValue = max - (max - min) * progress;
    }
    
    [delegateSlider setDoubleValue:newValue];
}

@end
