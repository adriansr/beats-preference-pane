//
//  BeatMoc.m
//  beats-preference-pane
//
//  Created by Adrian Serrano on 19/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "BeatsMock.h"

@interface FakeBeat : NSObject {
    NSString *name;
    bool isRunning;
}

- (id) init;
- (id) initWithName:(NSString*)_ andRunning:(bool)_;
+ (id) beatWithName:(NSString*)_ andRunning:(bool)_;
@end

@implementation BeatsMock

- (NSArray*) listBeats {
    return [NSArray arrayWithObjects:
            @"packetbeat",
            @"filebeat",
            @"metricbeat",
            nil];
}

- (id <Beat>) getBeat:(NSString *)name {
    return [FakeBeat beatWithName:name andRunning:false];
}

@end

@implementation FakeBeat

+ (id) beatWithName:(NSString*)name andRunning:(bool)running
{
    return [[FakeBeat alloc] initWithName:name andRunning:running];
}

- (id) init
{
    if (self = [super init]) {
        self->name = nil;
        self->isRunning = false;
    }
    return self;
}

- (id) initWithName:(NSString*) name andRunning:(bool) running
{
    if (self = [self init]) {
        self->name = name;
        self->isRunning = running;
    }
    return self;
}

- (bool)isRunning {
    return isRunning;
}

- (NSString*)name {
    return name;
}

- (NSString*) configFile {
    return [NSString stringWithFormat:@"/etc/%@/%@.yml", name, name];
}

- (void) start {
}

- (void) stop {
}

- (void) uninstall {
}

@end
