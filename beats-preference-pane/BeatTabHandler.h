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
