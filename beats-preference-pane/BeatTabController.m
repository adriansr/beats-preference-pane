//
//  BeatTabController.m
//  beats-preference-pane
//
//  Created by Adrian Serrano on 21/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "BeatTabController.h"
#include <sys/time.h>

@interface BeatTabController ()

@end

//NSString *plistPath = @"/Library/LaunchDaemons/co.elastic.beats.packetbeat.plist";
NSString *plistPath = @"/tmp/plist";
NSString *outPath = @"/tmp/plist.out";

@implementation BeatTabController

- (id) initWithBeat:(id<Beat>)beat
          andBundle:(NSBundle*)bundle
{
    if (self = [self initWithNibName:nil bundle:bundle]) {
        self->beat = beat;
    }
    return self;
}

- (void)fail:(NSString*)msg {
    [textField setStringValue:msg];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [textField setStringValue:
     [NSString stringWithFormat:@"%@ is %@", [beat name],
      [beat isRunning]? @"running" : @"stopped"]];

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
    BOOL success = [data writeToFile:outPath atomically:YES];
    struct timeval tv;
    gettimeofday(&tv, NULL);
    [self fail:[NSString stringWithFormat:@"format %x %@->%@ %db %@ (%@@%ld)", (unsigned int)format,
                before, after, (unsigned int)nbytes, success? @"YES":@"NO", [beat name], tv.tv_sec]];

}

@end
