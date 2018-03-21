//
// Copyright (c) 2012–2018 Elastic <http://www.elastic.co>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "BeatTabHandler.h"
#import "BeatTabController.h"
#import "common/common.h"
#import "globals.h"

@implementation BeatTabHandler
- (id) initWithTabView:(NSTabView *)tabView
                bundle:(NSBundle*)bundle
{
    if (self = [super init]) {
        self->selectedTab = nil;
        self->tabView = tabView;
        self->bundle = bundle;
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
                                 initWithBeat:[beatsInterface getBeat:beatName] auth:auth bundle:bundle];
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
