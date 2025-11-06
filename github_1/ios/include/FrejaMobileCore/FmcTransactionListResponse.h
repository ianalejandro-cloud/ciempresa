//
//  FmcTransactionListResponse.h
//  FrejaMobileCore
//
//  Created by Andrija Jakovljevic on 8/3/16.
//  Copyright © 2016 Verisec Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FmcServerTime.h"


@interface FmcTransactionListResponse : NSObject

@property NSMutableArray* transactions;

-(instancetype)initWithTransactionList:(NSMutableArray*)pTransactions;




@end
