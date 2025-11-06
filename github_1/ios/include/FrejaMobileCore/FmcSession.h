//
//  FmcSession.h
//  FrejaMobileCore
//
//  Created by Petar Cvetkovic on 6/25/14.
//  Copyright (c) 2014 Verisec Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FmcSession : NSObject

- (void)putObject:(NSObject*) object forKey:(NSString*) key;
- (NSObject*)getObjectForKey:(NSString*) key;
- (void) removeObjectForKey:(NSString*) key;

-(void) destroySession;

@end
