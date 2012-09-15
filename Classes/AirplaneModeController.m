//
//  AirplaneMode.m
//  smcFanControl
//
//  Created by Dominik Pich on 9/13/12.
//
//

#import "AirplaneModeController.h"
#import "NSAnimationForSlider.h"

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
    if(!self.window.isVisible) {
        [airplaneThrustLeverRPMSlider.animator setDoubleValue:fanSpeed];
        airplaneThrustLeverRPM.doubleValue = fanSpeed;
    }
    
    NSAnimationForSlider *sliderAnimation = [[NSAnimationForSlider alloc] initWithDuration:2.0 animationCurve:NSAnimationEaseIn];
    [sliderAnimation setAnimationBlockingMode:NSAnimationNonblocking];
    [sliderAnimation setDelegateSlider:airplaneActualRPMSlider];
    [sliderAnimation setAnimateToValue:fanSpeed];
    [sliderAnimation startAnimation];

    //--- NOTIFICATION CENTER
    [self speakNotificationAndUpdateUI:fanSpeed];
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

- (void)speakNotificationAndUpdateUI:(double)rpm {
    static double _lastRPM = NSNotFound;
    static BOOL _flying = NO;
    id substring = nil;
    id image_name = nil;
    
    if(rpm > airplaneActualRPMSlider.maxValue - 2400 &&
       (_lastRPM == NSNotFound || _lastRPM <= airplaneActualRPMSlider.maxValue - 2400)) {
        if(!_flying) {
            _flying = YES;
            image_name = @"airplane_takeoff";
            substring = @"is cleared for take off. Have a good flight!";
        }
        else if(rpm > airplaneActualRPMSlider.maxValue - 800) {
            _lastRPM = rpm;
            image_name = @"airplane_flying";
            substring = @"is in the air.";
        }
    }
    else if(rpm <= airplaneActualRPMSlider.minValue + 1200 &&
       (_lastRPM == NSNotFound || _lastRPM > airplaneActualRPMSlider.minValue + 1200)) {
        if(_flying) {
            _flying = NO;
            image_name = @"airplane_landing";
            substring = @"is cleared for landing. Welcome!";
        }
        else if(rpm < airplaneActualRPMSlider.minValue + 600){
            _lastRPM = rpm;
            image_name = @"airplane_stopped";
            substring = @"has landed.";
        }
    }
    
    if(substring) {
        static dispatch_queue_t _speakQueue = nil;
        if(!_speakQueue)
            _speakQueue = dispatch_queue_create("_speakQueue", NULL);
            
        dispatch_async(_speakQueue, ^{
            //wait for everybody to shut up
            while([NSSpeechSynthesizer isAnyApplicationSpeaking])
                [NSThread sleepForTimeInterval:0.2];

            //set image
            airplaneActualRPMImageView.image = [NSImage imageNamed:image_name];
            
            //speak
            id hostName = [[NSHost currentHost] localizedName];
            NSSpeechSynthesizer *synth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
            [synth startSpeakingString:[NSString stringWithFormat:@"%@ at %.0f rpm %@", hostName, rpm, substring]];
        });
    }
}

@end
