//
//  FmcThema.h
//  FrejaMobileCore
//
//  Created by Petar Cvetkovic on 5/17/16.
//  Copyright © 2016 Verisec Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FmcThema : NSObject

+(void) setKeyboardHeaderBackgroundColor:(UIColor*)pKeyboardHeaderBackgroundColor;
+(UIColor*) getKeybaordHeaderBackgroundColor;

+(void) setKeyboardHeaderSelectedItemColor:(UIColor*)pKeyboardHeaderSelectedItemColor;
+(UIColor*) getKeyboardHeaderSelectedItemColor;

+(void) setKeyboardHeaderUnselectedItemColor:(UIColor*)pKeyboardHeaderUnselectedItemColor;
+(UIColor*) getKeyboardHeaderUnselectedItemColor;

+(void) setKeyboardFooterItemColor:(UIColor*)pKeyboardfooterItemColor;
+(UIColor*) getKeyboardFooterItemColor;

+(void) setKeyboardBackgroundColor:(UIColor*)pKeyboardBackgroundColor;
+(UIColor*) getKeyboardBackgroundColor;


@end
