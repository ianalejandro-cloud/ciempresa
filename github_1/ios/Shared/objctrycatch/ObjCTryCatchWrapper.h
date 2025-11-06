//
//  ObjCTryCatchWrapper.h
//  Runner
//
//  Created by Gerado Cruz on 25/07/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjCTryCatchWrapper : NSObject

+ (nullable id)tryBlockSimple:(id (^)(void))tryBlock;

@end

NS_ASSUME_NONNULL_END

