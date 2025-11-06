
#import <Foundation/Foundation.h>
#import "FmcServerTime.h"

@interface FmcTransactionResponse : NSObject

@property NSString* transactionReference;
@property NSString* transactionText;
//From version 1.6
@property NSString* transactionTitle;
@property TransactionType transactionType;
@property TransactionStatus transactionStatus;

-(instancetype)initWithTrText:(NSString*)pTrText trReference:(NSString*)pTrReference serverTime:(FmcServerTime*)pServerTime trStartTime:(long long)pTrStartTime trValidityPeriod:(long long)pTrValidityPeriod trTitle:(NSString*)pTrTitle trType:(TransactionType)pTrType andTrStatus:(TransactionStatus)pTrStatus;

-(long long)getTransactionStartTime;
-(long long)getTransactionRemainingTime;
-(long long)getTransactionEndTime;

@end
