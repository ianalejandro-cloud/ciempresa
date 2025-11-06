
#import <Foundation/Foundation.h>

#import "FmcEnum.h"


@interface FmcToken : NSObject

@property (readonly) NSString* serialNumber;
@property (readonly) TokenUsage usage;
@property (readonly) NSString* ocraSuite;
@property (readonly) NSString* icv;


-(id) initWithSerialNumber:(NSString*)pSerialNumber andUsage:(TokenUsage)pUsage andOcraSuite:(NSString*)pOcraSuite andIcv:(NSString*)pIcv;

-(int)getTimeIncrement;

-(int) printTest;

-(FmcToken*) clone;

-(NSString*) commonTokenSerialNumber;

@end
