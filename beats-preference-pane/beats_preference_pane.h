//
//  beats_preference_pane.h
//  beats-preference-pane
//
//  Created by Adrian Serrano on 08/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>
#import "BeatManager.h"

@interface BeatTabHandler : NSObject {
    id <BeatManager> mgr;
}
- (id) initWithManager:(id <BeatManager>)_;
- (void) updateTabs:(NSTabView*)_;

- (void) tabViewDidChangeNumberOfTabViewItems:(NSTabView*)_;
- (BOOL) tabView:(NSTabView*)_ shouldSelectTabViewItem:(NSTabViewItem*)_;
- (void) tabView:(NSTabView*)_ willSelectTabViewItem:(NSTabViewItem*)_;
- (void) tabView:(NSTabView*)_ didSelectTabViewItem:(NSTabViewItem*)_;
@end

@interface beats_preference_pane : NSPreferencePane {
    IBOutlet NSTabView *beatsTab;
    IBOutlet BeatTabHandler *tabHandler;
}

- (id)initWithBundle:(NSBundle *)bundle;
- (void)mainViewDidLoad;
- (void)didSelect;
- (void)willSelect;
- (void)didUnselect;

@end
