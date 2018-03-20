//
//  EditorWindow.h
//  Beats
//
//  Created by Adrian Serrano on 18/03/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EditorWindow : NSWindowController {
    NSString *filePath,
             *beatName;
    IBOutlet NSView *verticalStackView;
    IBOutlet NSScrollView *textEditor;
    NSString *sourceText;
}

- (id) initWithBeat:(NSString*) name config:(NSString*) path;
- (IBAction)saveAndCloseTapped:(id)sender;
- (IBAction)closeTapped:(id)sender;
- (BOOL)windowShouldClose:(id)sender;
@end
