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
    id<Beat> beat;
    IBOutlet NSTextField *textField;
}

- (id)initWithBeat:(id<Beat>)_ andBundle:(NSBundle*)_;
- (void)toggleRunAtLoad;
- (IBAction)buttonTapped:(id)sender;

@end
