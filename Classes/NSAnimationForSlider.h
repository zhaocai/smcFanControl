//
//  NSAnimationForSlider.h
//  smcFanControl
//
//  Created by Dominik Pich on 9/15/12.
//
//

#import <Cocoa/Cocoa.h>

@interface NSAnimationForSlider : NSAnimation
{
    NSSlider *delegateSlider;
    float animateToValue;
    double max;
    double min;
    float initValue;
}
@property (nonatomic, retain) NSSlider *delegateSlider;
@property (nonatomic, assign) float animateToValue;

@end
