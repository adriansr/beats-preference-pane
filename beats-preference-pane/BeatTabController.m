//
//  BeatTabController.m
//  beats-preference-pane
//
//  Created by Adrian Serrano on 21/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "BeatTabController.h"
#include "common.h"

@interface BeatTabController ()

@end

//NSString *plistPath = @"/Library/LaunchDaemons/co.elastic.beats.packetbeat.plist";
NSString *plistPath = @"/tmp/plist";

@implementation BeatTabController

- (id) initWithBeat:(id<Beat>)beat
             bundle:(NSBundle*)bundle
               auth:(id<AuthorizationProvider>)auth
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
}

- (IBAction)startStopTapped:(id)sender {
    uint64_t took = getTimeMicroseconds();
    id<Beat> beat = self->beat;
    
    if ([beat isRunning]) {
        [beat stopWithAuth:auth];
    } else {
        [beat startWithAuth:auth];
    }
    took = getTimeMicroseconds() - took;
    NSLog(@"start/stop took %lld us", took);
}

- (IBAction)startAtBootTapped:(id)sender {
    [beat toggleRunAtBootWithAuth:auth];
}

- (void) update:(id<Beats>)beats {
    uint64_t elapsed = getTimeMicroseconds();
    beat = [beats getBeat:[beat name]];
    [self updateUI];
    elapsed = getTimeMicroseconds() - elapsed;
    NSLog(@"Update tab took %lld us", elapsed);
}


@end
