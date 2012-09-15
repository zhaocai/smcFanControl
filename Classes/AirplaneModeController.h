//
//  AirplaneMode.h
//  smcFanControl
//
//  Created by Dominik Pich on 9/13/12.
//
//

#import <Cocoa/Cocoa.h>

typedef void (^AirplaneBlock)(double requestedRM);

@interface AirplaneModeController : NSWindowController {
    // ;)
    NSInteger _temperature;
    double _fanSpeed;
    AirplaneBlock _changeHandler;

    IBOutlet NSTextField *airplaneTemp;
    IBOutlet NSTextField *airplaneThrustLeverRPM;
    IBOutlet NSSlider *airplaneThrustLeverRPMSlider;
    IBOutlet NSTextField *airplaneActualRPM;
    IBOutlet NSSlider *airplaneActualRPMSlider;
    IBOutlet NSImageView *airplaneActualRPMImageView;
}

- (id)initWithMin:(double)min max:(double)max selected:(double)selected;

@property(nonatomic) NSInteger temperature;
@property(nonatomic) double fanSpeed;
@property(copy) AirplaneBlock changeHandler;

- (IBAction)moveAirplaneThrustLevel:(id)sender;

@end
