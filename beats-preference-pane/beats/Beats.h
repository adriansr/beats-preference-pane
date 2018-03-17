//
//  BeatManager.h
//  beats-preference-pane
//
//  Created by Adrian Serrano on 19/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Authorization.h"

@protocol Beat
- (bool) isRunning;
- (bool) isBoot;
- (int) pid;
- (NSString*) name;
- (NSString*) plistPath;
- (NSString*) configFile;
- (NSString*) logsPath;
- (BOOL) startWithAuth:(id<AuthorizationProvider>)auth;
- (BOOL) stopWithAuth:(id<AuthorizationProvider>)auth;
- (BOOL) toggleRunAtBootWithAuth:(id<AuthorizationProvider>)auth;
- (BOOL) uninstall;
@end

@protocol Beats
- (NSArray*) listBeats;
- (id <Beat>)getBeat:(NSString*)name;
@end
