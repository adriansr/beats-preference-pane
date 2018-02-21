//
//  BeatTabController.m
//  beats-preference-pane
//
//  Created by Adrian Serrano on 21/02/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "BeatTabController.h"

@interface BeatTabController ()

@end

@implementation BeatTabController

- (id) initWithBeat:(id<Beat>)beat
          andBundle:(NSBundle*)bundle
{
    if (self = [self initWithNibName:nil bundle:bundle]) {
        self->beat = beat;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [textField setStringValue:
     [NSString stringWithFormat:@"%@ is %@", [beat name],
      [beat isRunning]? @"running" : @"stopped"]];
}

@end
