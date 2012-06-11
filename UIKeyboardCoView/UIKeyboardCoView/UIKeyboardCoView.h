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

#import <UIKit/UIKit.h>

/**
	This class is a subclass of UIView that stays on top of the keyboard. To make it View Controller Independent, we listen to
    orientation changes from the device directly, so we can apply that smooth move when rotating the device and the keyboard rotates
    User should not care about setting the frame of this view, but the user should play with autoresize values for the subviews of
    this view. For best results, the view in the XIB should be HIDDEN at first
 */
@interface UIKeyboardCoView : UIView

@end
