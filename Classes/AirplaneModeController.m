//
//  AirplaneMode.m
//  smcFanControl
//
//  Created by Dominik Pich on 9/13/12.
//
//

#import "AirplaneModeController.h"

@implementation AirplaneModeController

- (id)initWithMin:(double)min max:(double)max selected:(double)selected {
    self = [super initWithWindowNibName:@"AirplaneModeController"];
    if(self) {
        [self loadWindow];
        airplaneThrustLeverRPMSlider.minValue = min;
        airplaneActualRPMSlider.minValue = min;
        airplaneThrustLeverRPMSlider.maxValue = max;
        airplaneActualRPMSlider.maxValue = max;
        airplaneThrustLeverRPMSlider.doubleValue = selected;
        airplaneActualRPMSlider.doubleValue = selected;

        airplaneThrustLeverRPM.doubleValue = selected;
        airplaneActualRPM.doubleValue = selected;
    }
    return self;
}

@synthesize temperature=_temperature;
- (void)setTemperature:(NSInteger)temperature {
    _temperature = temperature;
    airplaneTemp.integerValue = _temperature;
}

@synthesize fanSpeed=_fanSpeed;
- (void)setFanSpeed:(double)fanSpeed {
    _fanSpeed = fanSpeed;
    airplaneActualRPM.doubleValue = fanSpeed;
    [airplaneActualRPMSlider.animator setDoubleValue:fanSpeed];

    //--- NOTIFICATION CENTER
    //[self speakNotificationIfNeeded:fanSpeed];
}

@synthesize changeHandler = _changeHandler;

- (IBAction)moveAirplaneThrustLevel:(id)sender {
    airplaneThrustLeverRPM.doubleValue = airplaneThrustLeverRPMSlider.doubleValue;
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(applyAirplaneRPM)
                                               object:nil];
    [self performSelector:@selector(applyAirplaneRPM)
               withObject:nil
               afterDelay:0.5f];
}

- (void)applyAirplaneRPM {
    if(self.changeHandler)
        self.changeHandler(airplaneThrustLeverRPMSlider.doubleValue);
}

@end
