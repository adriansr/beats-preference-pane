//
//  BeatManager.h
//  beats-preference-pane
//
//  Created by Adrian Serrano on 19/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Beat
- (bool) isRunning;
- (bool) isBoot;
- (int) pid;
- (NSString*) name;
- (NSString*) configFile;
- (NSString*) logsPath;
- (void) start;
- (void) stop;
- (void) uninstall;

@end

@protocol Beats
- (NSArray*) listBeats;
- (id <Beat>)getBeat:(NSString*)name;
@end
