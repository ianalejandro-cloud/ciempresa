
#import <Foundation/Foundation.h>

@interface FmcMass : NSObject

@property (readonly) NSString* dnsName;
@property (readonly) NSString* cert;
@property (readonly) NSString* secondCert;

-(id)initWithDnsName:(NSString *)pDnsName andCert:(NSString *)pCert andSecondCert:(NSString *)pSecondCert;

@end
