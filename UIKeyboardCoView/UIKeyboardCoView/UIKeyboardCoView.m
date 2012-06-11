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

#import "UIKeyboardCoView.h"



@interface UIKeyboardCoView ()
/**
	This is true when the device did rotate. We use this to set up correct options for view animation
 */
@property (nonatomic,assign) BOOL deviceDidRotate;
/**
	The common init method for the view
 */
- (void) keyboardCoViewCommonInit;
/**
	This method is called when a notification of type UIKeyboardWillShowNotification is received
	@param notification The notification object
 */
- (void) keyboardWillAppear:(NSNotification*)notification;
/**
    This method is called when a notification of type UIKeyboardWillHideNotification is received
    @param notification The notification object
 */
- (void) keyboardWillDissappear:(NSNotification*)notification;
/**
    This method is called when a notification of type UIDeviceOrientationDidChangeNotification is received
    @param notification The notification object
 */
- (void) deviceDidRotate:(NSNotification*)notification;
/**
	This method fix a CGRect from the keyboard show and hide notifications and transforms it into a relative to this view's superview CGRect
	@param originalRect The original CGRect
	@returns The fixed and this view's superview relative CGRect
 */
- (CGRect) fixKeyboardRect:(CGRect)originalRect;

@end









@implementation UIKeyboardCoView
@synthesize deviceDidRotate = _deviceDidRotate;


#pragma mark - Init Methods
- (id) init{
    self = [super init];
    if (self){
        [self keyboardCoViewCommonInit];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self keyboardCoViewCommonInit];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self keyboardCoViewCommonInit];
    }
    return self;
}


- (void) keyboardCoViewCommonInit{
    //Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDissappear:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];

}







#pragma mark - Dealloc method

- (void) dealloc{
    //Unregister notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}








#pragma mark - Keyboard notification methods
- (void) keyboardWillAppear:(NSNotification*)notification{

    //Get begin, ending rect and animation duration
    CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //Transform rects to local coordinates
    beginRect = [self fixKeyboardRect:beginRect];
    endRect = [self fixKeyboardRect:endRect];
    
    //Get this view begin and end rect
    CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
                                      beginRect.origin.y - self.frame.size.height,
                                      beginRect.size.width,
                                      self.frame.size.height);
    CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                       endRect.origin.y - self.frame.size.height,
                                       endRect.size.width,
                                       self.frame.size.height);
    
    //Set view position and hidden
    self.frame = selfBeginRect;
    self.alpha = 0.0f;
    [self setHidden:NO];
    
    //Animate view
    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
    //If the device did rotate, to get a smooth movement, we add this option
    if (self.deviceDidRotate){
        //To start from the current view position (not the one we have just set
        options |= UIViewAnimationOptionBeginFromCurrentState;
        //And reset the deviceDidRotate to false
        self.deviceDidRotate = false;
    }
    
    //Start the animation
    [UIView animateWithDuration:animDuration delay:0.0f
                    options:options
                     animations:^(void){
                         self.frame = selfEndingRect;
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         self.frame = selfEndingRect;
                         self.alpha = 1.0f;
                     }];
        
}


- (void) keyboardWillDissappear:(NSNotification*)notification{

    //Animate ONLY if the devide did not rotate
    //If the device did rotate, we are only interested in the appear animation, the dissappear animation
    //messes up our appear animation (they are executed in the same frame)
    if (!self.deviceDidRotate){
        
        //Get begin, ending rect and animation duration
        CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

        //Transform rects to local coordinates
        beginRect = [self fixKeyboardRect:beginRect];
        endRect = [self fixKeyboardRect:endRect];
        
        //Get this view begin and end rect
        CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
                                          beginRect.origin.y - self.frame.size.height,
                                          beginRect.size.width,
                                          self.frame.size.height);
        CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                          endRect.origin.y - self.frame.size.height,
                                          endRect.size.width,
                                           self.frame.size.height);
        
        //Set view position and hidden
        self.frame = selfBeginRect;
        self.alpha = 1.0f;

        //Animate view
        [UIView animateWithDuration:animDuration delay:0.0f
                            options:UIViewAnimationOptionAllowAnimatedContent
                         animations:^(void){
                             self.frame = selfEndingRect;
                             self.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             self.frame = selfEndingRect;
                             self.alpha = 0.0f;
                             [self setHidden:YES];
                         }];
    }
}






#pragma mark - Other notification methodss
- (void) deviceDidRotate:(NSNotification *)notification{
    //Only set the deviceDidRotate boolean IF the view is not Hidden (the keyboard has appeared) and the device orientation is correct
    if ((!self.isHidden) &&
        ([UIDevice currentDevice].orientation != UIDeviceOrientationFaceDown) && 
        ([UIDevice currentDevice].orientation != UIDeviceOrientationFaceUp) && 
        ([UIDevice currentDevice].orientation != UIDeviceOrientationUnknown) )
        self.deviceDidRotate = true;
}







#pragma mark - Private methods
- (CGRect) fixKeyboardRect:(CGRect)originalRect{
    
    //Get the UIWindow by going through the superviews
    UIView * referenceView = self.superview;
    while ((referenceView != nil) && ![referenceView isKindOfClass:[UIWindow class]]){
        referenceView = referenceView.superview;
    }
    
    //If we finally got a UIWindow
    CGRect newRect = originalRect;
    if ([referenceView isKindOfClass:[UIWindow class]]){
        //Convert the received rect using the window
        UIWindow * myWindow = (UIWindow*)referenceView;
        newRect = [myWindow convertRect:originalRect toView:self.superview];
    }
    
    //Return the new rect (or the original if we couldn't find the Window -> this should never happen if the view is present)
    return newRect;
}





@end
