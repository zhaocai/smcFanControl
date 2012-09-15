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
    static int factor = 0;
    if(!factor) {
        //HACK TO GET IT TO REVERSE
        id path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/.GlobalPreferences.plist"];
        id dict = [NSDictionary dictionaryWithContentsOfFile:path];
        id value = [dict objectForKey:@"com.apple.swipescrolldirection"];
        if(value)
            factor = ![value boolValue] ? -1 : 1;
        else
            factor = 1;
    }
    
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
