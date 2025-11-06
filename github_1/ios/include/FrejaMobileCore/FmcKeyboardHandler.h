//
//  FmcKeyboardHandler.h
//  VerisecKeyboard
//
//  Created by Andrija Jakovljevic on 1/4/16.
//  Copyright © 2016 Verisec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FmcKeyboardHandler : NSObject  <UITextFieldDelegate>

-(instancetype)initWithScrollView:(UIScrollView*)pScrollView;
-(instancetype)initWithScrollView:(UIScrollView*)pScrollView andKeyboardType:(KeyboardType) keyboardType;

-(void)setFmcKeyboard4TextField:(UITextField*)textField WithLeftButtonTitle:(NSString*)pButtonLeftTitle leftButtonAction:(void(^)())pButtonLeftAction rightButtonTitle:(NSString*)pButtonRightTitle rightButtonAction:(void(^)())pButtonRightAction;

-(void)dismissKeyboard;

-(void) shuffleNumericButtons;

-(void) enableOnClickEffect;

@end
