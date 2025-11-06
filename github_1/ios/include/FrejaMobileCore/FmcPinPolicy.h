
#import <Foundation/Foundation.h>

@interface FmcPinPolicy : NSObject

@property (nonatomic, readonly) int min;
@property (nonatomic, readonly) int max;

-(id) initWithMinValue:(int) minValue andMaxValue:(int) maxValue;

@end
