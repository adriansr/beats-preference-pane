//
//  BeatMoc.h
//  beats-preference-pane
//
//  Created by Adrian Serrano on 19/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Beats.h"

@interface BeatsMock : NSObject <Beats>
- (NSArray*) listBeats;
- (id <Beat>)getBeat:(NSString*)name;
@end