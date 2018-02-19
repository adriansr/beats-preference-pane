//
//  beats_preference_pane.m
//  beats-preference-pane
//
//  Created by Adrian Serrano on 08/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "beats_preference_pane.h"
#import "BeatMock.h"

@implementation beats_preference_pane
- (id)initWithBundle:(NSBundle *)bundle
{
    if ( ( self = [super initWithBundle:bundle] ) != nil ) {
        //appID = CFSTR(“com.mycompany.example.prefPaneSample”);
        //self->mgr = [BeatManagerMock alloc];
        self->tabHandler = [[BeatTabHandler alloc] initWithManager:[BeatManagerMock alloc]];
    }

    return self;
}

- (void)mainViewDidLoad
{
    //[self updateUI];
}

- (void)willSelect
{
    //[self updateUI];
}

- (void)didSelect
{
    [self updateUI];
}


- (void)didUnselect
{
    // TODO
}

- (void)updateUI {
    [tabHandler updateTabs:beatsTab];
}

void alert(NSString *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    NSString *msg = [NSString stringWithFormat:fmt, args];
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:msg];
    [alert runModal];
    va_end(args);
}

@end

@implementation BeatTabHandler
- (id) initWithManager:(id <BeatManager>) mgr
{
    if (self = [super init]) {
        self->mgr = mgr;
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
        NSString *beatName = [beats objectAtIndex:i];
        NSTabViewItem *item = [[NSTabViewItem alloc] initWithIdentifier:beatName];
        [item setLabel:beatName];
        [tabView addTabViewItem:item];
    }
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
    // TODO
}

- (void) tabView:(NSTabView*)tabView didSelectTabViewItem:(NSTabViewItem*)item
{
    // TODO
}

@end
