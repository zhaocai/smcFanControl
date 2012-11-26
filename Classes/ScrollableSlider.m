//
//  ScrollableSlider.m
//  smcFanControl
//
//  Created by Dominik Pich on 9/15/12.
//
//

#import "ScrollableSlider.h"

@implementation ScrollableSlider

- (void)scrollWheel:(NSEvent*) event
{
    int factor = 0;
    //GET IT TO REVERSE
    BOOL value = [event isDirectionInvertedFromDevice];
    factor = value ? -1 : 1;
    
    float range = [self maxValue] - [self minValue];
    float increment = (range * [event deltaY]) / 100;
    float val = [self floatValue] + increment * factor;
    
    BOOL wrapValue = ([[self cell] sliderType] == NSCircularSlider);
    
    if( wrapValue )
    {
        if ( val < [self minValue])
            val = [self maxValue] - fabs(increment) * factor;
        
        if( val > [self maxValue])
            val = [self minValue] + fabs(increment) * factor;
    }
    
    [self setFloatValue:val];
    [self sendAction:[self action] to:[self target]];
}

@end
