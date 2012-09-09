/**
     Copyright 2012 Daniel Lupiañez Casares <lupidan@gmail.com>
     
     Licensed under the Apache License, Version 2.0 (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at
     
     http://www.apache.org/licenses/LICENSE-2.0
     
     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
 */

#import "ViewController.h"

@implementation ViewController
@synthesize texField;



#pragma mark - Dealloc method
- (void)dealloc {
    [texField release];
    [super dealloc];
}




#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [self setTexField:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}




#pragma mark - Rotation control
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardCoViewWillRotateNotification object:nil];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardCoViewDidRotateNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}




#pragma mark - IBActions
- (IBAction)backgroundTouchDown:(id)sender {
    [self.texField resignFirstResponder];
}


#pragma mark - UI Keyboard Co View Delegate
- (void) keyboardCoViewWillAppear:(UIKeyboardCoView*)keyboardCoView{
    NSLog(@"Keyboard Co View Will Appear");
}

- (void) keyboardCoViewDidAppear:(UIKeyboardCoView*)keyboardCoView{
    NSLog(@"Keyboard Co View Did Appear");
}

- (void) keyboardCoViewWillDisappear:(UIKeyboardCoView*)keyboardCoView{
    NSLog(@"Keyboard Co View Will Disappear");
}


- (void) keyboardCoViewDidDisappear:(UIKeyboardCoView*)keyboardCoView{
    NSLog(@"Keyboard Co View Did Disappear");
}

@end
