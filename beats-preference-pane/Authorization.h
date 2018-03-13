//
//  Authorization.h
//  beats-preference-pane
//
//  Created by Adrian Serrano on 12/03/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

@protocol AuthorizationProvider
- (BOOL) isUnlocked;
- (int) runAsRoot:(NSString*) program args:(NSArray*)args;
@end
