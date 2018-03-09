//
//  BeatsService.h
//  beats-preference-pane
//
//  Created by Adrian Serrano on 08/03/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Beats.h"

@interface BeatsService : NSObject <Beats> {
    NSString *prefix;
}
- (id)initWithPrefix:(NSString*)prefix;
- (NSArray*) listBeats;
- (id <Beat>)getBeat:(NSString*)name;
@end
