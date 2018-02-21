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
- (id) initWithManager:(id <BeatControl>) mgr andBundle:(NSBundle*)bundle
{
    if (self = [super init]) {
        self->mgr = mgr;
        self->bundle = bundle;
    }
    return self;
}

- (void) updateTabs:(NSTabView*)tabView
{
    uint i;
    NSArray *items;
    for (i=0, items = tabView.tabViewItems; items != nil && i < items.count; i++) {
        [tabView removeTabViewItem:[items objectAtIndex:i]];
    }
    NSArray *beats = [mgr listBeats];
    for (uint i=0; i < beats.count; i++) {
        id <Beat> beat = [beats objectAtIndex:i];
        NSString *name = [beat name];
        NSTabViewItem *item = [[NSTabViewItem alloc] initWithIdentifier:name];
        [item setLabel:name];
        BeatTabController *tc = [[BeatTabController alloc]
                                 initWithBeat:beat andBundle:bundle];
        NSView *view = [tc view];
        [item setView:view];
        [tabView addTabViewItem:item];
    }
    // TODO: Zero items
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
    //[item setView:[self view]];
    //alert(@"here?");
}

- (void) tabView:(NSTabView*)tabView didSelectTabViewItem:(NSTabViewItem*)item
{
    // TODO
}

@end
