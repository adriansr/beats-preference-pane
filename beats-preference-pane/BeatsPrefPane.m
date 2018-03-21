//
//  beats_preference_pane.m
//  beats-preference-pane
//
//  Created by Adrian Serrano on 08/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "BeatsPrefPane.h"
#import "beats/BeatsService.h"
#import "globals.h"

static NSString *beatsPrefix = @"co.elastic.beats";
static const double UPDATE_INTERVAL_SECS = 2.0;

@implementation BeatsPrefPane
- (id)initWithBundle:(NSBundle *)bundle
{
    if ( ( self = [super initWithBundle:bundle] ) != nil ) {
        beatsInterface = [[BeatsService alloc] initWithPrefix:beatsPrefix];
        self->updateTimer = nil;
        self->knownBeats = [beatsInterface listBeats];
        self->bundle = bundle;
        self->helperPath = [bundle pathForAuxiliaryExecutable:@"helper"];
        NSLog(@"Using helper: `%@`", helperPath);
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
    tabHandler = [[BeatTabHandler alloc] initWithTabView:beatsTab bundle:bundle];
}

- (void)willSelect
{
    NSLog(@"updateUI (willSelect)");
    [self updateUI];
}

- (void)didSelect
{
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_INTERVAL_SECS target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

BOOL beatArrayEquals(NSArray *a, NSArray *b)
{
    size_t n = a.count;
    if (b.count != n) return NO;
    for (size_t i = 0; i < n; i++) {
        if (![(NSString*)a[i] isEqualToString:b[i]])
            return NO;
    }
    return YES;
}

- (void)onTimer
{
    [authView updateStatus:nil];
    NSArray *beats = [beatsInterface listBeats];
    if (!beatArrayEquals(beats, knownBeats)) {
        NSLog(@"updateUI (onTimer) %@ != %@", beats, knownBeats);
        knownBeats = beats;
        [self updateUI];
    } else {
        [tabHandler update];
    }
}
- (void)didUnselect
{
    [updateTimer invalidate];
    updateTimer = nil;
}

- (void)updateUI {
    [messageLabel setHidden:[tabHandler updateTabs:knownBeats withAuth:self]];
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

- (int)runHelperAsRootWithArgs:(NSArray *)args {
    return [self runAsRoot:helperPath args:args];
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

