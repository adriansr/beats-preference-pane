//
//  BeatTabController.h
//  beats-preference-pane
//
//  Created by Adrian Serrano on 21/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "beats/Beats.h"
#import "Authorization.h"

@interface BeatTabController : NSViewController
{
    IBOutlet NSTextField *statusLabel;
    IBOutlet NSTextField *bootLabel;
    IBOutlet NSTextField *configField;
    IBOutlet NSTextField *logsField;
    IBOutlet NSButton *startStopButton;
    IBOutlet NSButton *bootButton;
    IBOutlet NSButton *editButton;
    
    id<Beat> beat;
    id<AuthorizationProvider> auth;
}

- (id)initWithBeat:(id<Beat>)_ auth:(id<AuthorizationProvider>)_ bundle:(NSBundle*)_;
- (IBAction)startStopTapped:(id)sender;
- (IBAction)startAtBootTapped:(id)sender;
- (IBAction)editConfigTapped:(id)sender;
- (void)update;

@end
