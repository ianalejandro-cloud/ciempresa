
#import <Foundation/Foundation.h>
#import "FmcPinPolicy.h"
#import "FmcAvailableFunctionalities.h"


@protocol FmcIWSHandler <NSObject>


//=================GENERAL ==========================================
-(FmcAvailableFunctionalities*)checkAvailableFunctionalities;


-(void)setNotificationId:(NSString*)notificationId withPinNumber:(NSMutableData*)pinNumber;


//=================PROVISIONING ==========================================


/**
 * Sends a https request to mass and returns an activation code received from the server
 */
-(NSString*) getActivationCode4ClientCode:(NSString*) clientCode;
/**
 * Sends a https request to mass and returns activation either PinPolicy or Polling response if action is not compelted on the BOA side. In case of polling you should resend this method after the polling time received from the server.
 */
-(id) getProvisioningPinPolicy;

/**
 * Sends a https request to mass. If the provisioning is successful this method shouldn't be called againg.
 */
-(void) verifyProvisioning4PinNumber:(NSMutableData*) pinNumber;

/**
    @return tokenPair serial number
 */
-(NSString*) verifyProvisioning4PinNumber:(NSMutableData*) pinNumber andAlias:(NSString*) tokenAlias;

//================= REPROVISIONING ==========================================
-(BOOL) startReprovisioning:(NSMutableData *) pinNumber : (BOOL) shouldDeleteOldToken;
-(NSString*) generateOtpQr:(NSMutableData *) pinNumber;
-(BOOL) isReprovisioningComplete;
-(BOOL) verifyOtpQr:(NSString *)clientCode : (NSDictionary *)qrData1 : (NSDictionary *)qrData2;
-(void) verifyReprovisioning:(NSMutableData *) pinNumber;

-(BOOL) startReprovisioning4Token:(FmcToken*)token andPinNumber:(NSMutableData *)pinNumber andShouldDeleteToken:(BOOL) shouldDeleteOldToken;
-(NSString*) generateOtpQrToken:(FmcToken*)token andPinNumber:(NSMutableData *) pinNumber;
-(BOOL) isReprovisioningComplete4Token:(FmcToken*)token;
-(NSString*) verifyReprovisioning:(NSMutableData *) pinNumber andTokenAlias:(NSString*) tokenAlias;

//================= SETTINGS ==========================================

/**
 * Sends a https request to mass in order to initiate the change PIN request - to get the pin policy and server time to be used for online token OCRA calculation
 */
-(FmcPinPolicy*) getChangePinPinPolicy __deprecated_msg("Use getChangePinPinPolicy4Token instead.");
-(FmcPinPolicy*) getChangePinPinPolicy4TokenPair:(FmcTokenPair*) tokenPair;

/**
 * Sends a https request to mass with new PIN detils and OCRA calculated responses for authentication
 */
-(void) changePin4OldPinNumber:(NSMutableData*)oldPinNumber andNewPinNumber:(NSMutableData*)newPinNumber  __deprecated_msg("Use changePin4Token:andOldPinNumber:andNewPinNumber instead.");
-(void) changePin4TokenPair:(FmcTokenPair*)tokenPair andOldPinNumber:(NSMutableData*)oldPinNumber andNewPinNumber:(NSMutableData*)newPinNumber;

//-------------------------------RESET PIN -----------------------------------

/**
 * Sends a https request to mass in order to initiate the reset PIN request - to get the pin policy and server time to be used for online token OCRA calculation
 */
-(FmcPinPolicy*) getResetPinPinPolicy __deprecated_msg("Use getResetPinPinPolicy4Token instead.");
-(FmcPinPolicy*) getResetPinPinPolicy4TokenPair:(FmcTokenPair*)tokenPair;

/**
 * Sends a https request to mass with new PIN details and OCRA calculated responses for authentication - uses ResetPinCode (RPC) for reset PIN operation
 */
-(void) resetPin4RpcCode:(NSMutableData*)rpcCode andNewPinNumber:(NSMutableData*)newPinNumber __deprecated_msg("Use resetPin4Token:andRpcCode:andNewPinNumber instead.");
-(void) resetPin4TokenPair:(FmcTokenPair*)tokenPair andRpcCode:(NSMutableData*)rpcCode andNewPinNumber:(NSMutableData*)newPinNumber;


//=================TRANSACTION ==========================================

/**
 * Sends a https request to mass to get the pending transaction if any. If there is no transaction pollingResponse object is returned. This method should be called again after the polling timeout has expired.
 */
-(id) getTransaction __deprecated_msg("Use getTransactionList instead.");
/**
 * Sends a https request to mass to get the multiple pending transactions if any. If there is no transactions pollingResponse object is returned. This method should be called again after the polling timeout has expired.
 */
-(id) getTransactionList __deprecated_msg("Use getTransactionListForToken instead.");
-(id) getTransactionListForToken:(FmcToken*) token;

/**
 * Sends a https request to mass in order to approve the transaction with given reference id. This request requires the user of the token to enter his secret PIN.
 */
-(void) approveTransaction4PinNumber:(NSMutableData*)pinNumber andTransactionReference:(NSString*)transactionReference __deprecated_msg("Use approveTransaction4Token:andPinNumber:andTransactionReference instead.");
/**
 * Sends a https request to mass in order to approve the transaction. This request requires the user of the token to enter his secret PIN.
 */
-(void) approveTransaction4PinNumber:(NSMutableData*)pinNumber __deprecated_msg("Use approveTransaction4Token:andPinNumber:andTransactionReference instead.");
-(void) approveTransaction4Token:(FmcToken*)token andPinNumber:(NSMutableData *)pinNumber andTransactionReference:(NSString *)transactionReference;

/**
 * Sends a https request to mass in order to cancel the transaction. In this case the user secret PIN is not obligatory.
 */
-(void) cancelTransaction __deprecated_msg("Use cancelTransactionByReference instead.");
/**
 * Sends a https request to mass in order to cancel the transaction with given reference. In this case the user secret PIN is not obligatory.
 */
-(void) cancelTransactionByReference:(NSString*)transactionReference;


/**
 * Sends a https request to mass in order to read secure message or transaction. This request requires the user of the token to enter his secret PIN.
 */
-(id) readTransaction4PinNumber:(NSMutableData*)pinNumber andTransactionReference:(NSString*)transactionReference __deprecated_msg("Use readTransaction4Token:andPinNumber:andTransactionReference instead.");
-(id)readTransaction4Token:(FmcToken*)token andPinNumber:(NSMutableData *)pinNumber andTransactionReference:(NSString *)transactionReference;
@end
