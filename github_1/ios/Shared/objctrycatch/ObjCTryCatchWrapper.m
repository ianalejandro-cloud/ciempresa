#import "ObjCTryCatchWrapper.h"

@implementation ObjCTryCatchWrapper

+ (nullable id)tryBlockSimple:(id (^)(void))tryBlock {
    @try {
        return tryBlock();
    }
    @catch (NSException *exception) {
        return [NSError errorWithDomain:@"ObjCException"
                                   code:1
                               userInfo:@{NSLocalizedDescriptionKey: exception.reason ?: @"Unknown exception"}];
    }
}

@end
