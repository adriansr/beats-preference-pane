//
//  beats_preference_pane.m
//  beats-preference-pane
//
//  Created by Adrian Serrano on 08/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "BeatsPrefPane.h"
#import "beats/BeatsMock.h"
#import "beats/BeatsService.h"

static NSString *beatsPrefix = @"co.elastic.beats";
static const double UPDATE_INTERVAL = 1.0;

@implementation BeatsPrefPane
- (id)initWithBundle:(NSBundle *)bundle
{
    if ( ( self = [super initWithBundle:bundle] ) != nil ) {
        tabHandler = [[BeatTabHandler alloc]
            //initWithManager:[[BeatsMock alloc] init]
            initWithManager:[[BeatsService alloc] initWithPrefix:beatsPrefix]
            andBundle:[self bundle]];
        updateTimer = nil;
    }

    return self;
}

- (void)mainViewDidLoad
{
    // Setup security.
    AuthorizationItem items = {kAuthorizationRightExecute, 0, NULL, 0};
    AuthorizationRights rights = {1, &items};
    [authView setAuthorizationRights:&rights];
    authView.delegate = self;
    [authView updateStatus:nil];
    beatsTab.delegate = tabHandler;
}

- (void)willSelect
{
    [self updateUI];
}

- (void)didSelect
{
    [self updateUI];
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_INTERVAL repeats:YES block:^(NSTimer*_) {
        [tabHandler updateSelectedTab];
    }];
}

- (void)didUnselect
{
    [updateTimer invalidate];
    updateTimer = nil;
}

- (void)updateUI {
    [messageLabel setHidden:[tabHandler updateTabs:beatsTab]];
}

//- (BOOL)isUnlocked {
//    return [authView authorizationState] == SFAuthorizationViewUnlockedState;
//}

//
// SFAuthorization delegates
//

- (void)authorizationViewDidAuthorize:(SFAuthorizationView *)view {
    //alert(@"Unlocked!");
}

- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)view {
    //alert(@"Locked!");
}

@end

