//
//  BeatTabHandler.m
//  beats-preference-pane
//
//  Created by Adrian Serrano on 21/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "BeatTabHandler.h"
#import "BeatTabController.h"
#import "common/common.h"
#import "globals.h"

@implementation BeatTabHandler
- (id) initWithTabView:(NSTabView *)tabView;
{
    if (self = [super init]) {
        self->selectedTab = nil;
        self->tabView = tabView;
        tabView.delegate = self;
    }
    return self;
}

- (void) update
{
    [(BeatTabController*)selectedTab update];
}

- (BOOL) updateTabs:(NSArray*)beats withAuth:(id<AuthorizationProvider>)auth
{
    NSViewController *selectedTab = self->selectedTab;
    uint i;
    NSArray *items;
    NSString *selectedName = nil;
    for (i=0, items = tabView.tabViewItems; items != nil && i < items.count; i++) {
        NSTabViewItem *item = [items objectAtIndex:i];
        if (selectedTab != nil && item.viewController == selectedTab) {
            selectedName = item.identifier;
        }
        [tabView removeTabViewItem:item];
    }
    for (uint i=0; i < beats.count; i++) {
        NSString *beatName = [beats objectAtIndex:i];
        NSTabViewItem *item = [[NSTabViewItem alloc] initWithIdentifier:beatName];
        [item setLabel:beatName];
        BeatTabController *tc = [[BeatTabController alloc]
                                 initWithBeat:[beatsInterface getBeat:beatName] auth:auth];
        [item setViewController:tc];
        [tabView addTabViewItem:item];
        if ([beatName isEqualToString:selectedName]) {
            selectedTab = tc;
            [tabView selectTabViewItem:item];
        }
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
    [(BeatTabController*)[item viewController] update];
}

- (void) tabView:(NSTabView*)tabView didSelectTabViewItem:(NSTabViewItem*)item
{
    selectedTab = [item viewController];
}

@end
