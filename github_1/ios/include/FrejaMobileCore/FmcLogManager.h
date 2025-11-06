//
//  FmcLogManager.h
//

#import <Foundation/Foundation.h>

@interface FmcLogManager : NSObject

+(void) enableLoggingAll:(BOOL) enable;

+(void) enableLogging:(BOOL) enable;
+(BOOL) isEnableddLogging;

// error
+(void) enableLoggingError:(BOOL) enable;
+(BOOL) isEnabledLoggingError;

// info
+(void) enableLoggingInfo:(BOOL) enable;
+(BOOL) isEnabledLoggingInfo;

// debug
+(void) enableLoggingDebug:(BOOL) enable;
+(BOOL) isEnabledLoggingDebug;

// trace
+(void) enableLoggingTrace:(BOOL) enable;
+(BOOL) isEnabledLoggingTrace;

@end
