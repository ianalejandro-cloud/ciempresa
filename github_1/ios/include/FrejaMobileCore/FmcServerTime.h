
#import <Foundation/Foundation.h>

@interface FmcServerTime : NSObject


-(id) initWithServerTime:(long long)pServerTimeInMillsec;

-(long long) getCurrentServerTimeInMillsec;


@end
