//
//  FmcKeychainManager.h
//
//  Created by Ivan Micanovic on 8/28/16.
//  Copyright © 2016 Verisec Labs. All rights reserved.
//


#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    TOUCH_ID_ENABLED,
    TOUCH_ID_DISABLED,
    TOUCH_ID_LOCKED
} FmcTouchIdStatus;

@interface FmcTouchIdManager : NSObject

-(FmcTouchIdStatus)getTouchIdPhoneStatus;
-(BOOL)isTouchIdEnabledOnPhone;

-(void) setPin:(NSMutableData*)pin;

-(void) getPin:(void(^)(NSMutableData *pin))onSuccessCallback
        onErrorCallback:(void(^)(NSException *exception))onErrorCallback
        onCancelCallback:(void(^)(void))onCancelCallback
        on3TimesAuthenticationFailedCallback:(void(^)(void))on3TimesAuthenticationFailedCallback;

-(void)deletePin;
-(void)deleteAllData;

-(void)setUserNotificationMessage:(NSString*)notificationMessage;
@end
