
#import <Foundation/Foundation.h>

#import "FmcToken.h"
#import "FmcEnum.h"
#import "FmcTokenPair.h"


@interface FmcConfiguration : NSObject
{
    NSString* applicationVersion;
    FmcToken* onlineToken __deprecated_msg("onlineToken is deprecated. Please use tokenList instead.");
    FmcToken* offlineToken __deprecated_msg("offlineToken is deprecated. Please use tokenList instead.");
    FmcToken* defaultToken __deprecated_msg("defaultToken is deprecated. In multi-token philosophy there are no default token at all.");
    NSMutableArray* tokenPairList;  // List<FmcTokenPair>
    
}
@property KeyboardType keyboardType;
@property long connectionTimeout;

- (instancetype)initWithApplicationVersion:(NSString*)pApplicationVersion andConnectionTimeout:(long) pConnectionTimeout
             defaultKeyboardType:(KeyboardType)pKeyboardType
                 andDefaultToken:(FmcToken*) pDefaultToken andOnlineToken:(FmcToken*) pOnlineToken andOfflineToken:(FmcToken*) pOfflineToken
                    andTokenList:(NSMutableArray*) pTokenList;

-(NSString*) getApplicationVersion;

-(bool) existsDefaultToken __deprecated_msg("existsDefaultToken is deprecated. In multi-token philosophy there are no default token at all.");
-(bool) existsOnlineToken __deprecated_msg("existsOnlineToken is deprecated. Please use tokenList instead.");
-(bool) existsOfflineToken __deprecated_msg("existsOfflineToken is deprecated. Please use tokenList instead.");

-(FmcToken*) getOfflineToken __deprecated_msg("getOfflineToken is deprecated. Please use tokenList instead.");
-(FmcToken*) getOnlineToken __deprecated_msg("getOnlineToken is deprecated. Please use tokenList instead.");
-(FmcToken*) getDefaultToken __deprecated_msg("getDefaultToken is deprecated. In multi-token philosophy there are no default token at all.");
-(void) setDefaultToken4TokenUsage:(TokenUsage) tokenUsage __deprecated_msg("defaultToken is deprecated. In multi-token philosophy there are no default token at all.");
-(NSMutableArray*) getTokenPairList;

-(void)print;

@end
