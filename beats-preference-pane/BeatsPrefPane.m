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
#import "globals.h"

static NSString *beatsPrefix = @"co.elastic.beats";
static const double UPDATE_INTERVAL_SECS = 2.0;

@implementation BeatsPrefPane
- (id)initWithBundle:(NSBundle *)bundle
{
    if ( ( self = [super initWithBundle:bundle] ) != nil ) {
        tabHandler = [[BeatTabHandler alloc]
            initWithManager:[[BeatsService alloc] initWithPrefix:beatsPrefix]
            bundle:[self bundle]
              auth:self];
        updateTimer = nil;
        prefPaneBundle = bundle;
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
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_INTERVAL_SECS repeats:YES block:^(NSTimer*_) {
        [authView updateStatus:nil];
        [tabHandler update];
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

- (BOOL)isUnlocked {
    return [authView authorizationState] == SFAuthorizationViewUnlockedState;
}

- (int)runAsRoot:(NSString*)program args:(NSArray*)args {
    size_t numArgs = args.count;
    char **cArgs = alloca(sizeof(char*) * (1 + numArgs));
    for (int i=0; i<args.count; i++) {
        cArgs[i] = (char*)[(NSString*)[args objectAtIndex:i] cStringUsingEncoding:NSUTF8StringEncoding];
    }
    cArgs[numArgs] = NULL;

    NSLog(@"Running AuthorizationExecuteWithPrivileges(`%@ %@`) ...", program, [args componentsJoinedByString:@" "]);
    
    FILE *pipe = NULL;
    int res = AuthorizationExecuteWithPrivileges([[authView authorization] authorizationRef],
                                       [program cStringUsingEncoding:NSUTF8StringEncoding],
                                       kAuthorizationFlagDefaults,
                                       cArgs,
                                       &pipe);
    if (res != errAuthorizationSuccess) {
        NSString *errMsg = (__bridge NSString*)SecCopyErrorMessageString(res, NULL);
        NSLog(@"Error: AuthorizationExecuteWithPrivileges(`%@ %@`) failed with error code %d: %@",
              program, [args componentsJoinedByString:@" "], res, errMsg);
        return res;
    }
    if (pipe != NULL) {
        const size_t bufLen = 1024;
        char buf[bufLen];
        while (fgets(buf, bufLen, pipe)) {
            NSLog(@"%@ output: %s", program, buf);
        }
        fclose(pipe);
    }
    return 0;
}

- (BOOL)forceUnlock {
    return [authView authorize:nil];
}

//
// SFAuthorization delegates
//

- (void)authorizationViewDidAuthorize:(SFAuthorizationView *)view {
    [tabHandler update];
}

- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)view {
    [tabHandler update];
}

@end

