//
//  common.m
//  beats-preference-pane
//
//  Created by Adrian Serrano on 21/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "common.h"
#import <Cocoa/Cocoa.h>

void alert(NSString *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    NSString *msg = [[NSString alloc] initWithFormat:fmt arguments:args];
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:msg];
    [alert runModal];
    va_end(args);
}
