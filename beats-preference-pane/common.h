//
//  common.h
//  beats-preference-pane
//
//  Created by Adrian Serrano on 21/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <Foundation/Foundation.h>

void alert(NSString *fmt, ...);
int launchTask(NSString *path, NSArray *args, BOOL (^callback)(NSString*));
