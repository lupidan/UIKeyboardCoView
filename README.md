UIKeyboardCoView
================

A UIView to appear along the iOS default keyboard. It manages also ROTATION when keyboard is present. For iOS4+

The UIKeyboardCoView is totally CUSTOMIZABLE. Just add one UIKeyboardCoView in your XIB and put anything you need inside it :)

![Landscape Image](https://github.com/lupidan/UIKeyboardCoView/raw/master/landscape.png "Landscape Image")
![Portrait Image](https://github.com/lupidan/UIKeyboardCoView/raw/master/portrait.png "Portrait Image")

How to use
================
Just add it as a normal UIView programmatically or trough the Interface Builder.
It has also a delegate outlet to know when the Keyboard Co View did/will appear/disappear.

Finally, to manage keyboard rotations correctly, paste this code in your ROOT UIViewController willRotate and didRotate methods, like so:

	- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    	[[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardCoViewWillRotateNotification object:nil];
	}

	- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardCoViewDidRotateNotification object:nil];
	}
	
License
================
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