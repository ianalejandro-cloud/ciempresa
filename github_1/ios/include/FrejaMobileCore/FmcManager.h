
#import <Foundation/Foundation.h>
#import "FmcSession.h"
#import "FmcConfiguration.h"
#import "FmcTouchIdManager.h"
#import "FmcMass.h"

@protocol FmcIWSHandler;
@class FmcInternalConfiguration;
@class FmcInternalSession;

@interface FmcManager  : NSObject {
    FmcInternalSession *internalSession;
}

@property FmcSession *fmcSession;

+ (FmcManager*) getFmcManager;
- (FmcConfiguration*) getFmcConfiguration;
- (void) updateFmcConfiguration:(FmcConfiguration*) configuration;
- (id<FmcIWSHandler>) getFmcWSHandler;
- (NSString*) generateOTPValue4Token:(FmcToken*)token andPinNumber:(NSMutableData*)pinNumber;
- (NSString*) generateOTPValue:(NSMutableData*)pinNumber __deprecated_msg("Use generateOTPValue4Token:pinNumber instead.");
- (NSString*) generateOnlineOTPValue:(NSMutableData*)pinNumber __deprecated_msg("Use generateOTPValue4Token:pinNumber instead.");
- (NSString*) generateOTPQrValue4Token:(FmcToken*) token andPinNumber:(NSMutableData*)pinNumber;
- (NSString*) generateOnlineOTPQrValue:(NSMutableData*)pinNumber __deprecated_msg("Use generateOTPQrValue4Token:andPinNumber instead.");
-(NSString*) approveOfflineTransaction:(NSMutableData*)pinNumber andTransactionText:(NSString*)transactionText  __deprecated_msg("Use approveOfflineTransaction4Token:andPinNumber:andTransactionText instead.");
-(NSString*) approveOfflineTransaction4Token:(FmcToken*)token andPinNumber:(NSMutableData*)pinNumber andTransactionText:(NSString*)transactionText;

-(void) updateTokenPair:(FmcTokenPair*) tokenPair;

-(void)clearAppData;
-(FmcTouchIdManager*) getFmcTouchIdManager;

-(void) resetManagerDataAndClearSession;

+(void) setCertificatePinningEnabled:(BOOL) certificatePinningEnable;
+(BOOL) isCertificatePinningEnabled;

/**
   NOTE: The method is dedicated to clients who use hardcoded mass in the configuration.
 
    The  method will override masses in configuration. As consequence of that, client doesn't need to set provisioning and transaction list directly in the fmcConfiguration file at all. They just need to call this method once a new app version is launched.  
 
  @param provisioningMassList the list must have at least one mass instance.
  @param transactionMassList the list must have at least one mass instance
 */
-(void) overrideMassListsWithProvisioningMassList:(NSMutableArray*) provisioningMassList andTransactionMassList:(NSMutableArray*) transactionMassList;

@end
