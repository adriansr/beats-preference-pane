//
//  BeatTabController.m
//  beats-preference-pane
//
//  Created by Adrian Serrano on 21/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "BeatTabController.h"
#import "EditorWindow.h"
#import "common/common.h"
#import "globals.h"

@interface BeatTabController ()

@end

//NSString *plistPath = @"/Library/LaunchDaemons/co.elastic.beats.packetbeat.plist";
NSString *plistPath = @"/tmp/plist";

@implementation BeatTabController

- (id) initWithBeat:(id<Beat>)beat
               auth:(id<AuthorizationProvider>)auth
             bundle:(NSBundle*)bundle
{
    if (self = [self initWithNibName:nil bundle:bundle]) {
        self->beat = beat;
        self->auth = auth;
    }
    return self;
}

- (void)fail:(NSString*)msg {
    [statusLabel setStringValue:msg];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

NSString *strOrNil(NSString *str) {
    return str != nil? str : @"(nil)";
}

- (void)updateUI {
    id<Beat> beat = self->beat;
    
    if ([beat isRunning]) {
        [statusLabel setStringValue:[NSString stringWithFormat:@"%@ is running with PID %d", [beat name], [beat pid]]];
        [startStopButton setTitle:@"Stop"];
    } else {
        [statusLabel setStringValue:[NSString stringWithFormat:@"%@ is stopped", [beat name]]];
        [startStopButton setTitle:@"Start"];
    }
    
    if ([beat isBoot]) {
        [bootLabel setStringValue:@"Automatic start at boot is enabled"];
        [bootButton setTitle:@"Disable"];
    } else {
        [bootLabel setStringValue:@"Automatic start at boot is disabled"];
        [bootButton setTitle:@"Enable"];
    }
    [configField setStringValue:strOrNil([beat configFile])];
    [logsField setStringValue:strOrNil([beat logsPath])];
    
    BOOL unlocked = [auth isUnlocked];
    [startStopButton setEnabled:unlocked];
    [bootButton setEnabled:unlocked];
    [editButton setEnabled:unlocked];
}

- (IBAction)startStopTapped:(id)sender {
    if (![auth isUnlocked]) {
        return;
    }
    uint64_t took = getTimeMicroseconds();
    id<Beat> beat = self->beat;
    
    if ([beat isRunning]) {
        [beat stopWithAuth:auth];
    } else {
        [beat startWithAuth:auth];
    }
    took = getTimeMicroseconds() - took;
    NSLog(@"start/stop took %lld us", took);
    [self update];
}

- (IBAction)startAtBootTapped:(id)sender {
    if (![auth isUnlocked]) {
        return;
    }
    [beat toggleRunAtBootWithAuth:auth];
    [self update];
}

- (IBAction)editConfigTapped:(id)sender {
    if (![auth isUnlocked]) {
        return;
    }
    id<Beat> beat = self->beat;
    NSString *conf = [beat configFile];
    NSString *tmpFile = [NSString stringWithFormat:@"%@/beatconf-%@.yml",NSTemporaryDirectory(), [[NSUUID UUID] UUIDString]];
    [@"" writeToFile:tmpFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
    [auth runAsRoot:@"/bin/sh" args:@[@"-c", [NSString stringWithFormat:@"cat '%@' > '%@'", conf, tmpFile]]];
    NSLog(@"Copied `%@` to `%@`", conf, tmpFile);
    EditorWindow *editor = [[EditorWindow alloc] initWithBeat:[beat name] config:tmpFile];
    NSWindow *window = [editor window];
    [window setFrameOrigin:[[[self view] window] frame].origin];
    NSModalResponse resp = [NSApp runModalForWindow: window];
    if (resp == NSModalResponseOK) {
        while ([auth runAsRoot:@"/bin/sh" args:@[@"-c", [NSString stringWithFormat:@"cat '%@' > '%@'", tmpFile, conf]]] != errAuthorizationSuccess) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"Retry"];
            [alert addButtonWithTitle:@"Cancel"];
            [alert setMessageText:@"Retry authentication?"];
            [alert setInformativeText:@"Authentication expired. Configuration changes will be lost unless valid credentials are provided."];
            [alert setAlertStyle:NSAlertStyleWarning];
            if ([alert runModal] != NSAlertFirstButtonReturn) {
                break;
            }
            [auth forceUnlock];
        }
    }
    [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:nil];
}

- (void) update {
    uint64_t elapsed = getTimeMicroseconds();
    beat = [beatsInterface getBeat:[beat name]];
    [self updateUI];
    elapsed = getTimeMicroseconds() - elapsed;
    NSLog(@"Update tab took %lld us", elapsed);
}

@end
