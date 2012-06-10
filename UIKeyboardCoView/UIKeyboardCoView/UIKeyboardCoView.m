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

@property (nonatomic,assign) BOOL coViewIsAnimating;

- (void) keyboardCoViewCommonInit;
- (void) keyboardWillAppear:(NSNotification*)notification;
- (void) keyboardDidAppear:(NSNotification*)notification;
- (void) keyboardWillDissappear:(NSNotification*)notification;
- (void) keyboardDidDissappear:(NSNotification*)notification;
- (CGRect) fixKeyboardRect:(CGRect)originalRect;

@end


@implementation UIKeyboardCoView
@synthesize coViewIsAnimating = _coViewIsAnimating;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDissappear:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidDissappear:) name:UIKeyboardDidHideNotification object:nil];
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
    
    self.coViewIsAnimating = true;
    
    //Transform rects to local coordinates
    beginRect = [self fixKeyboardRect:beginRect];
    endRect = [self fixKeyboardRect:endRect];
    
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
    [UIView animateWithDuration:animDuration delay:0.0f
                    options:UIViewAnimationOptionAllowUserInteraction
                     animations:^(void){
                         self.frame = selfEndingRect;
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         self.frame = selfEndingRect;
                         self.alpha = 1.0f;
                         self.coViewIsAnimating = false;
                     }];
        
}

- (void) keyboardDidAppear:(NSNotification*)notification{
}

- (void) keyboardWillDissappear:(NSNotification*)notification{

    //Get begin, ending rect and animation duration
    CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.coViewIsAnimating = true;

    //Transform rects to local coordinates
    beginRect = [self fixKeyboardRect:beginRect];
    endRect = [self fixKeyboardRect:endRect];
    
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
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^(void){
                         self.frame = selfEndingRect;
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.frame = selfEndingRect;
                         self.alpha = 0.0f;
                         [self setHidden:YES];
                         self.coViewIsAnimating = false;
                     }];
}

- (void) keyboardDidDissappear:(NSNotification*)notification{

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
