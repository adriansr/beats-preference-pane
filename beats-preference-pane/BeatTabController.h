//
//  BeatTabController.h
//  beats-preference-pane
//
//  Created by Adrian Serrano on 21/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "beats/Beats.h"

@interface BeatTabController : NSViewController
{
    IBOutlet NSTextField *statusLabel;
    IBOutlet NSTextField *bootLabel;
    IBOutlet NSTextField *configField;
    IBOutlet NSTextField *logsField;
    IBOutlet NSButton *startStopButton;
    IBOutlet NSButton *bootButton;
}
@property (atomic) id<Beat> beat;

- (id)initWithBeat:(id<Beat>)_ andBundle:(NSBundle*)_;
//- (void)toggleRunAtLoad;
- (IBAction)buttonTapped:(id)sender;
- (void)updateUI;

@end
