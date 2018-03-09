//
//  BeatsService.m
//  beats-preference-pane
//
//  Created by Adrian Serrano on 08/03/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "BeatsService.h"
#import "common.h"

static NSString *launchDaemonsPath = @"/Library/LaunchDaemons";
static NSString *plistExtension = @"plist";
static NSString *launchCtl = @"/bin/launchctl";
static NSString *empty = @"";

@interface ConcreteBeat : NSObject <Beat> {
    @public NSString *config;
    @public NSString *name;
    @public bool running;
    @public pid_t pid;
}
- (id) initWithName:(NSString *)name;
@end

@implementation ConcreteBeat

- (id) initWithName:(NSString *)name {
    if (self = [self init]) {
        self->name = name;
        self->config = nil;
        self->running = false;
        self->pid = 0;
    }
    return self;
}

- (NSString *)configFile {
    return self->config;
}

- (bool)isRunning {
    return self->running;
}

- (NSString *)name {
    return self->name;
}

- (int)pid {
    return self->pid;
}

- (void)start {
    // TODO
}

- (void)stop {
    // TODO
}

- (void)uninstall {
    // TODO
}

@end
@implementation BeatsService

- (id)initWithPrefix:(NSString*)prefix {
    if (self = [self init]) {
        self->prefix = prefix;
    }
    return self;
}

- (NSArray *)listBeats {
    uint64_t elapsed = getTimeMicroseconds();
    NSArray *result = [self doListBeats];
    if (result != nil) {
        elapsed = getTimeMicroseconds() - elapsed;
        NSLog(@"ListBeats took %llu us", elapsed);
    }
    return result;
}

- (NSArray *)doListBeats {
    NSError *error = nil;
    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:launchDaemonsPath
                                                                            error:&error];
    if (error != nil) {
        NSLog(@"Error: Unable to list installed beats: %@", [error localizedDescription]);
        return nil;
    }
    NSMutableArray *beats = [[NSMutableArray alloc] init];
    NSUInteger prefixLength = [prefix length];
    NSUInteger extensionLength = [plistExtension length];
    
    [contents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        //NSLog(@"Got daemon '%@'", filename);
        NSUInteger nameLength =[filename length];
        if ([filename hasPrefix:self->prefix]
             && nameLength > prefixLength + extensionLength + 2
             && [filename characterAtIndex:prefixLength] == '.'
             && [[[filename pathExtension] lowercaseString] isEqualToString:plistExtension]) {
            NSString *beatName = [filename substringWithRange:NSMakeRange(prefixLength+1, nameLength - prefixLength - extensionLength - 2)];
            //NSLog(@"Found beat '%@'", beatName);
            [beats addObject:beatName];
        }
    }];
    return beats;
}

NSString *parseLine(NSString *line, NSString **data) {
    NSRange range = [line rangeOfString:@" = "];
    if (range.location != NSNotFound) {
        unsigned int i = 0;
        for(char c; i < range.location && ((c = [line characterAtIndex:i])==' ' || c == '\t'); i++)
            ;
        *data = [line substringFromIndex:range.location + range.length];
        return [line substringWithRange:NSMakeRange(i, range.location - i)];
    }
    return nil;
}

NSDictionary* parseLaunchctlPrint(NSString *label, NSSet *keys) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[keys count]];
    launchTask(launchCtl, @[@"print", label], ^(NSString *line) {
        NSString *value;
        NSString *key = parseLine(line, &value);
        if (key != nil && [keys containsObject:key]) {
            dict[key] = value;
        }
        return YES;
    });
    return dict;
}

- (id<Beat>)getBeat:(NSString *)name {
    uint64_t elapsed = getTimeMicroseconds();
    id result = [self doGetBeat:name];
    if (result != nil) {
        elapsed = getTimeMicroseconds() - elapsed;
        NSLog(@"GetBeat took %llu us", elapsed);
    }
    return result;
}

- (id<Beat>)doGetBeat:(NSString *)name {
    // Get launch daemon runtime info (only if running)
    NSString *label = [NSString stringWithFormat:@"system/%@.%@", self->prefix, name];
    NSSet *wantedKeys = [NSSet setWithObjects:@"pid", @"state", @"path", nil];
    NSDictionary * dict = parseLaunchctlPrint(label, wantedKeys);
    
    if (!dict[@"path"]) {
        NSLog(@"Error: launch daemon %@ not installed", name);
        return nil;
    }
    ConcreteBeat *beat = [[ConcreteBeat alloc] initWithName:name];
    if (dict[@"pid"]) {
        beat->pid = [ (NSString*)dict[@"pid"] intValue];
    }
    // pid may be present after stopped
    if (beat->pid > 0 && [@"running" isEqualToString:dict[@"state"]]) {
        beat->running = true;
    }
    
    // Get configuration paths
    NSError *err;
    NSInputStream *plistFile = [[NSInputStream alloc] initWithFileAtPath:dict[@"path"]];
    if (plistFile == nil) {
        NSLog(@"Error: unable to open plist at path '%@'", dict[@"path"]);
        return nil;
    }
    [plistFile open];
    if ( (err = [plistFile streamError]) != nil) {
        NSLog(@"Error: unable to read plist at path '%@': %@", dict[@"path"], [err localizedDescription]);
        return nil;
    }
    
    NSDictionary *plist = [NSPropertyListSerialization propertyListWithStream:plistFile
                                                                      options:NSPropertyListImmutable
                                                                       format:nil
                                                                        error:&err];
    if (plist == nil) {
        NSLog(@"Error: unable to parse plist at path '%@'", dict[@"path"]);
        return nil;
    }
    if (err != nil) {
        NSLog(@"Error: failed parsing plist at path '%@': %@", dict[@"path"], [err localizedDescription]);
        return nil;
    }
    [plistFile close];
    
    // TODO: RunAtLoad
    NSArray *args = plist[@"ProgramArguments"];
    NSMutableDictionary *argsDict = [NSMutableDictionary new];
    NSString *key = nil;
    for (unsigned long i = 0, count = [args count]; i < count; i++) {
        NSString *arg = [args objectAtIndex:i];
        if (key != nil) {
            //NSLog(@"Found argument '%@' = '%@'", key, arg);
            argsDict[key] = arg;
            key = nil;
        } else if ([arg characterAtIndex:0] == '-') {
                key = arg;
        }
    }
    
    beat->config = argsDict[@"-c"];
    return beat;
}

@end
