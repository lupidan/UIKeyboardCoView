/**
 * UIKeyboardCoView
 *
 * Copyright 2012 Daniel Lupiañez Casares <lupidan@gmail.com>
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either 
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public 
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 * 
 **/

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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}




#pragma mark - IBActions
- (IBAction)backgroundTouchDown:(id)sender {
    [self.texField resignFirstResponder];
}


@end
