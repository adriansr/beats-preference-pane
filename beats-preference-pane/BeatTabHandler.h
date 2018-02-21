//
//  BeatTabHandler.h
//  beats-preference-pane
//
//  Created by Adrian Serrano on 21/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "BeatControl.h"

@interface BeatTabHandler : NSObject <NSTabViewDelegate> {
    id <BeatControl> mgr;
    NSBundle *bundle;
}
- (id) initWithManager:(id <BeatControl>)_ andBundle:(NSBundle*)_;
- (void) updateTabs:(NSTabView*)_;

// NSTabViewDelegate
- (void) tabViewDidChangeNumberOfTabViewItems:(NSTabView*)_;
- (BOOL) tabView:(NSTabView*)_ shouldSelectTabViewItem:(NSTabViewItem*)_;
- (void) tabView:(NSTabView*)_ willSelectTabViewItem:(NSTabViewItem*)_;
- (void) tabView:(NSTabView*)_ didSelectTabViewItem:(NSTabViewItem*)_;
@end
