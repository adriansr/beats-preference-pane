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
    NSTabView *tabView;
    NSBundle *bundle;
    id selectedTab;
}
- (id) initWithTabView:(NSTabView*)_ bundle:(NSBundle*)_;
- (void) update;
// TODO: get rid of
- (BOOL) updateTabs:(NSArray*)_ withAuth:(id<AuthorizationProvider>)_;
//- (void) updateSelectedTab:(BOOL) isUnlocked;

// NSTabViewDelegate
- (void) tabViewDidChangeNumberOfTabViewItems:(NSTabView*)_;
- (BOOL) tabView:(NSTabView*)_ shouldSelectTabViewItem:(NSTabViewItem*)_;
- (void) tabView:(NSTabView*)_ willSelectTabViewItem:(NSTabViewItem*)_;
- (void) tabView:(NSTabView*)_ didSelectTabViewItem:(NSTabViewItem*)_;
@end
