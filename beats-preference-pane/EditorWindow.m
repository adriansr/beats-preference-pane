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
    sourceText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    if (sourceText == nil) {
        sourceText = [err localizedDescription];
    }
    NSTextStorage *storage = [(NSTextView*)[textEditor documentView] textStorage];
    [storage setFont:[NSFont userFixedPitchFontOfSize:-1]];
    [[storage mutableString] setString:sourceText];
}

- (IBAction)saveAndCloseTapped:(id)sender
{
    NSError *err = nil;
    NSTextStorage *storage = [(NSTextView*)[textEditor documentView] textStorage];
    if (![[storage string] writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSAlert *alert = [NSAlert alertWithError:err];
        [alert runModal];
        return;
    }
    [NSApp stopModalWithCode:NSModalResponseOK];
    [self close];
}

- (IBAction)closeTapped:(id)sender
{
    NSTextStorage *storage = [(NSTextView*)[textEditor documentView] textStorage];
    if (![[storage string] isEqualToString:sourceText]) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"Discard"];
        [alert addButtonWithTitle:@"Continue editing"];
        [alert setMessageText:@"Discard changes?"];
        [alert setInformativeText:@"Changes will be lost if the dialog is closed without saving."];
        [alert setAlertStyle:NSAlertStyleWarning];
        if ([alert runModal] != NSAlertFirstButtonReturn) {
            return;
        }
    }
    [NSApp stopModalWithCode:NSModalResponseStop];
    [self close];
}

- (BOOL)windowShouldClose:(id)sender {
    [NSApp stopModalWithCode:NSModalResponseStop];
    return YES;
}

@end
