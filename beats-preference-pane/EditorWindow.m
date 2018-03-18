//
//  EditorWindow.m
//  Beats
//
//  Created by Adrian Serrano on 18/03/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "EditorWindow.h"

@interface EditorWindow ()

@end

@implementation EditorWindow

- (id) initWithBeat:(NSString*)name config:(NSString*)path {
    if (self = [super initWithWindowNibName:@"EditorWindow"]) {
        self->beatName = name;
        self->filePath = path;
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    verticalStackView.translatesAutoresizingMaskIntoConstraints = YES;
    [[self window] setTitle:[NSString stringWithFormat:@"%@ configuration", beatName]];
    NSError *err = nil;
    NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    if (contents == nil || err != nil) {
        contents = [err localizedDescription];
    }
    NSTextView *textView = [textEditor documentView];
    [[[textView textStorage] mutableString] setString:contents];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)saveAndCloseTapped:(id)sender
{
    [NSApp stopModalWithCode:NSModalResponseOK];
    [self close];
}

- (IBAction)closeTapped:(id)sender
{
    [NSApp stopModalWithCode:NSModalResponseStop];
    [self close];
}

@end
