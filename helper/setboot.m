//
//  setboot.m
//  helper
//
//  Created by Adrian Serrano on 17/03/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <Foundation/Foundation.h>

static void fail(NSString *msg) {
    fprintf(stderr, "%s\n", [msg cStringUsingEncoding:NSUTF8StringEncoding]);
}

BOOL setRunAtBoot(NSString* plistPath, BOOL runAtBoot) {
    // Mutable property list so it can be changed in-place
    NSPropertyListMutabilityOptions opts = NSPropertyListMutableContainersAndLeaves;
    NSPropertyListFormat format = 0;
    NSError *err = nil;
    NSInputStream *input = [[NSInputStream alloc] initWithFileAtPath:plistPath];
    if (input == nil) {
        fail(@"Unable to open input file");
        return NO;
    }
    [input open];
    err = [input streamError];
    if (err != nil) {
        fail([NSString stringWithFormat:@"Unable to open input stream. Code=%u `%@`", (unsigned int)[err code], [err localizedDescription]]);
        return NO;
    }
    
    NSMutableDictionary *dict = [NSPropertyListSerialization
                                 propertyListWithStream:input
                                 options:opts
                                 format:&format
                                 error:&err];
    if (err != nil) {
        fail([NSString stringWithFormat:@"Error reading property list. Code=%u `%@`", (unsigned int)[err code], [err localizedDescription]]);
        return NO;
    }
    [input close];
    NSNumber *curValue = dict[@"RunAtLoad"];
    if (curValue != nil && [curValue boolValue] == runAtBoot) {
        fail(@"RunAtLoad setting already has required value");
        return YES;
    }
    NSNumber *newValue = [NSNumber numberWithBool:runAtBoot];
    [dict setValue:newValue forKey:@"RunAtLoad"];

    NSOutputStream *output = [NSOutputStream outputStreamToMemory];
    [output open];
    err = [output streamError];
    if (err != nil) {
        fail([NSString stringWithFormat:@"Error creating stream. Code=%u `%@`", (unsigned int)[err code], [err localizedDescription]]);
        return NO;
    }
    
    [NSPropertyListSerialization writePropertyList:dict
                                          toStream:output
                                            format:format
                                           options:0
                                             error:&err];
    if (err == nil) {
        err = [output streamError];
    }
    if (err != nil) {
        fail([NSString stringWithFormat:@"Error writting property-list. Code=%u `%@`", (unsigned int)[err code], [err localizedDescription]]);
        return NO;
    }
    [output close];
    
    NSData *data = [output propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    BOOL success = [data writeToFile:plistPath atomically:YES];
    if (!success) {
        fail(@"Error overwritting plist file");
        return NO;
    }
    return YES;
}
