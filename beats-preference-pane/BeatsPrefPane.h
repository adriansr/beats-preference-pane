//
//  beats_preference_pane.h
//  beats-preference-pane
//
//  Created by Adrian Serrano on 08/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>
#import <SecurityInterface/SFAuthorizationView.h>

#import "BeatTabHandler.h"
#import "Authorization.h"

@interface BeatsPrefPane : NSPreferencePane <AuthorizationProvider> {
    IBOutlet NSTabView *beatsTab;
    IBOutlet BeatTabHandler *tabHandler;
    IBOutlet SFAuthorizationView *authView;
    IBOutlet NSTextField *messageLabel;
    NSTimer *updateTimer;
    NSArray *knownBeats;
}

- (id)initWithBundle:(NSBundle *)bundle;
- (void)mainViewDidLoad;
- (void)didSelect;
- (void)willSelect;
- (void)didUnselect;
- (BOOL)isUnlocked;
@end
