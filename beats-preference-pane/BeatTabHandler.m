//
//  BeatTabHandler.m
//  beats-preference-pane
//
//  Created by Adrian Serrano on 21/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "BeatTabHandler.h"
#import "BeatTabController.h"
#import "common.h"

@implementation BeatTabHandler
- (id) initWithManager:(id <Beats>) mgr
                bundle:(NSBundle*)bundle
                  auth:(id<AuthorizationProvider>) auth
{
    if (self = [super init]) {
        self->beatsMgr = mgr;
        self->bundle = bundle;
        self->auth = auth;
    }
    return self;
}

- (void) update
{
    [(BeatTabController*)selectedTab update:beatsMgr];
}

- (BOOL) updateTabs:(NSTabView*)tabView
{
    uint i;
    NSArray *items;
    for (i=0, items = tabView.tabViewItems; items != nil && i < items.count; i++) {
        [tabView removeTabViewItem:[items objectAtIndex:i]];
    }
    NSArray *beats = [beatsMgr listBeats];
    for (uint i=0; i < beats.count; i++) {
        NSString *beatName = [beats objectAtIndex:i];
        NSTabViewItem *item = [[NSTabViewItem alloc] initWithIdentifier:beatName];
        [item setLabel:beatName];
        BeatTabController *tc = [[BeatTabController alloc]
                                 initWithBeat:[beatsMgr getBeat:beatName]
                                       bundle:bundle
                                         auth:auth];
        [item setViewController:tc];
        [tabView addTabViewItem:item];
    }
    return beats.count > 0;
}

- (void) tabViewDidChangeNumberOfTabViewItems:(NSTabView*) tabView
{
    // ignore
}

- (BOOL) tabView:(NSTabView*)tabView shouldSelectTabViewItem:(NSTabViewItem*)item
{
    return YES;
}

- (void) tabView:(NSTabView*)tabView willSelectTabViewItem:(NSTabViewItem*)item
{
    [(BeatTabController*)[item viewController] update:beatsMgr];
}

- (void) tabView:(NSTabView*)tabView didSelectTabViewItem:(NSTabViewItem*)item
{
    selectedTab = [item viewController];
}

@end
