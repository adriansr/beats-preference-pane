//
//  main.m
//  launchctl-helper
//
//  Created by Adrian Serrano on 13/03/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <stdio.h>
#import <string.h>
#import <unistd.h>
#include <Foundation/Foundation.h>

BOOL setRunAtBoot(NSString*,BOOL);

/* This helper tool is used to launch actions with elevated privileges.
 # helper run <program> <arguments...>
 # helper setboot <path_to_launchdaemon_plist> [true|false]
 */
int main(int argc, const char * argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <run|setboot> [arguments...]\n", argv[0]);
        return 1;
    }
    /* This is required for launchctl to connect to the right launchd
       when executed via AuthorizationExecuteWithPrivileges */
    if (setuid(0) != 0) {
        perror("setuid");
        return 2;
    }
    if (!strcmp(argv[1], "run")) {
        if (argc < 3) {
            fprintf(stderr, "Usage: %s run <program> [arguments...]\n", argv[0]);
            return 1;
        }
        fprintf(stderr, "Running `%s`", argv[2]);
        for (int i=3; i<argc; i++) {
            fprintf(stderr, " `%s`", argv[i]);
        }
        execvp(argv[2], (char* const*)&argv[2]);
        perror("execvp");
        return 3;
    }
    else if (!strcmp(argv[1], "setboot")) {
        if (argc != 4) {
            fprintf(stderr, "Usage: %s setboot <path_to_launchdaemon_plist> <true|false>\n", argv[0]);
            return 1;
        }
        BOOL value;
        if (!strcmp(argv[3], "yes")) {
            value = YES;
        } else if (!strcmp(argv[3], "no")) {
            value = NO;
        } else {
            fprintf(stderr, "Unknown boot value: `%s`. Use `yes` or `no`\n", argv[3]);
            return 1;
        }
        return YES!=setRunAtBoot([NSString stringWithUTF8String:argv[2]], value);
    } else {
        fprintf(stderr, "Unknown action: %s\n", argv[1]);
        return 1;
    }
}
