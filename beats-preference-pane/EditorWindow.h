//
// Copyright (c) 2012–2018 Elastic <http://www.elastic.co>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Cocoa/Cocoa.h>

/* EditorWindow manages the window to edit configuration files
 */
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
