//
//  FmTextFieldComponent.h
//  Mobile Token
//
//  Created by Petar Cvetkovic on 11/13/14.
//  Copyright (c) 2014 Verisec Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FmcTextFieldComponent : UIView

@property(readonly) UITextField *textField;

@property UIButton *backSpaceButton;

/**
 * create FmTextFiledComponent which contains FmTextFiled (this is own secure text field)
 * @param placeholderResourceTextKey placeholder key in resource file
 * @param isSecureTextField
 */
-(instancetype) initWithFmTextField4Id:(NSString*)elementId placeholderText:(NSString*)placeholderResourceTextKey isSecureTextField:(BOOL) isSecureTextField backgroundImageName:(NSString*)bgroundImageName backSpaceImageName:(NSString*)backSpaceImageName;

/**
 * return text field content. If text field is SECURE, method returns byte array as NSMutableData. In case that text field is UNSECURE, method returns NSString
 */
-(id) getContent;
-(id) getAsciiContent;
-(NSInteger) getLength;

-(void)setTextAllignment:(NSTextAlignment)allignment;
-(void) clearTextFieldContent;

@end
