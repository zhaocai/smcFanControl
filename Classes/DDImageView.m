//
//  DDImageView.m
//  smcFanControl
//
//  Created by Dominik Pich on 9/15/12.
//
//

#import "DDImageView.h"

@implementation DDImageView

- (void)setImage:(NSImage *)newImage {
    NSRect rImage = NSZeroRect;
    rImage.size = newImage.size;
    
    NSRect rFrame = self.frame;
    
    NSRect rImageNew = [self fillRect:rImage inRect:rFrame];
    newImage.size = rImageNew.size;
    
    [super setImage:newImage];
}

#pragma mark -

- (NSRect)fillRect:(NSRect)rect inRect:(NSRect)inRect
{
	NSRect result = NSZeroRect;
	
	CGFloat xRatio = rect.size.width / inRect.size.width;
	CGFloat yRatio = rect.size.height / inRect.size.height;
	
	CGFloat aspectRatio = rect.size.width / rect.size.height;
	
	//fit sizes
	if (xRatio <= yRatio) {
		result.size.width = inRect.size.width;
		result.size.height = result.size.width / aspectRatio;
	}
	else {
		result.size.height = inRect.size.height;
		result.size.width = result.size.height * aspectRatio;
	}
	
	//center rect
	result = [self centerRect:result inRect:inRect];
	
	return result;
}

- (NSRect)centerRect:(NSRect)rect inRect:(NSRect)inRect
{
	NSRect result = rect;
	result.origin.x = inRect.origin.x + (inRect.size.width - result.size.width)*0.5f;
	result.origin.y = inRect.origin.y + (inRect.size.height - result.size.height)*0.5f;
	return result;
}

@end
