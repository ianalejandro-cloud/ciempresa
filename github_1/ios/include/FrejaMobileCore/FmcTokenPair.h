
#import <Foundation/Foundation.h>

#import "FmcEnum.h"
#import "FmcToken.h"


@interface FmcTokenPair : NSObject

@property NSString* alias;
@property TokenUsage defaultToken;
@property FmcToken* onlineToken;
@property FmcToken* offlineToken;
@property NSMutableArray* provisioningMassList;
@property NSMutableArray* transactionMassList;


-(id) initWithOfflineToken:(FmcToken*)offlineToken andOnlineToken:(FmcToken*)onlineToken andDefaultTokenUsage:(TokenUsage)usage andAlias:(NSString*)alias
 andProvisioningMassList:(NSMutableArray*) provisioningMassList andTransactionMassList:(NSMutableArray*) transactionMassList;

-(NSString*) commonTokenSerialNumber;

-(FmcTokenPair*) clone;

@end
