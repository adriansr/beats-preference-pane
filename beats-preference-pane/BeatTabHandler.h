//
//  BeatTabHandler.h
//  beats-preference-pane
//
//  Created by Adrian Serrano on 21/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "beats/Beats.h"
#import "Authorization.h"

@interface BeatTabHandler : NSObject <NSTabViewDelegate> {
    id <Beats> beatsMgr;
    NSBundle *bundle;
    id auth;
    id selectedTab;
}
- (id) initWithManager:(id <Beats>)_ bundle:(NSBundle*)_ auth:(id<AuthorizationProvider>)_;
- (void) update;
// TODO: get rid of
- (BOOL) updateTabs:(NSTabView*)_;
//- (void) updateSelectedTab:(BOOL) isUnlocked;

// NSTabViewDelegate
- (void) tabViewDidChangeNumberOfTabViewItems:(NSTabView*)_;
- (BOOL) tabView:(NSTabView*)_ shouldSelectTabViewItem:(NSTabViewItem*)_;
- (void) tabView:(NSTabView*)_ willSelectTabViewItem:(NSTabViewItem*)_;
- (void) tabView:(NSTabView*)_ didSelectTabViewItem:(NSTabViewItem*)_;
@end
