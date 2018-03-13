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
        [bootLabel setStringValue:@"Beat will start at boot"];
        [bootButton setTitle:@"Disable"];
    } else {
        [bootLabel setStringValue:@"Beat will not start at boot"];
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

- (void) update:(id<Beats>)beats {
    uint64_t elapsed = getTimeMicroseconds();
    beat = [beats getBeat:[beat name]];
    [self updateUI];
    elapsed = getTimeMicroseconds() - elapsed;
    NSLog(@"Update tab took %lld us", elapsed);
}
/*
- (void)toggleRunAtLoad {
    NSPropertyListMutabilityOptions opts = NSPropertyListMutableContainersAndLeaves;
    NSPropertyListFormat format = 0;
    NSError *err = nil;
    NSInputStream *input = [[NSInputStream alloc] initWithFileAtPath:plistPath];
    if (input == nil) {
        [self fail:@"Unable to open input stream"];
        return;
    }
    [input open];
    err = [input streamError];
    if (err != nil) {
        [self fail:[NSString stringWithFormat:@"error %u : %@", (unsigned int)[err code], [err localizedDescription]]];
        return;
    }

    NSMutableDictionary *dict = [NSPropertyListSerialization
        propertyListWithStream:input
            options:opts
            format:&format
            error:&err];
    if (err != nil) {
        [self fail:[NSString stringWithFormat:@"error %u : %@", (unsigned int)[err code], [err localizedDescription]]];
        return;
    }
    [input close];
    NSNumber *before = dict[@"RunAtLoad"],
              *after = [NSNumber numberWithBool:![before boolValue]];

    [dict setValue:after forKey:@"RunAtLoad"];
    after = dict[@"RunAtLoad"];
    NSOutputStream *output = [NSOutputStream outputStreamToMemory];
    [output open];
    err = [output streamError];
    if (err != nil) {
        [self fail:[NSString stringWithFormat:@"error w %u : %@", (unsigned int)[err code], [err localizedDescription]]];
        return;
    }

    NSInteger nbytes = [NSPropertyListSerialization
     writePropertyList:dict toStream:output format:format options:0 error:&err];
    if (err == nil) {
        err = [output streamError];
    }
    if (err != nil) {
        [self fail:[NSString stringWithFormat:@"error wp %u : %@", (unsigned int)[err code], [err localizedDescription]]];
        return;
    }
    [output close];

    NSData *data = [output propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    BOOL success = [data writeToFile:plistPath atomically:YES];
    struct timeval tv;
    gettimeofday(&tv, NULL);
    [self fail:[NSString stringWithFormat:@"format %x %@->%@ %db %@ (%@@%ld)", (unsigned int)format,
                before, after, (unsigned int)nbytes, success? @"YES":@"NO", [beat name], tv.tv_sec]];

}*/

@end
