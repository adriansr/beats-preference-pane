//
//  beats_preference_pane.m
//  beats-preference-pane
//
//  Created by Adrian Serrano on 08/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "BeatsPrefPane.h"
#import "BeatControlMock.h"

@implementation BeatsPrefPane
- (id)initWithBundle:(NSBundle *)bundle
{
    if ( ( self = [super initWithBundle:bundle] ) != nil ) {
        tabHandler = [[BeatTabHandler alloc]
            initWithManager:[BeatControlMock alloc]
            andBundle:[self bundle]];
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
}


- (void)didUnselect
{
    // TODO
}

- (void)updateUI {
    [tabHandler updateTabs:beatsTab];
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

