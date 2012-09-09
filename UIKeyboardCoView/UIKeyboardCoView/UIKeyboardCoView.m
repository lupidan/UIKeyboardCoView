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
#import "UIKeyboardCoView.h"



@interface UIKeyboardCoView ()
/**
    Is set to true when a Will Rotate notification is posted, and to false when a Did Rotate notification is posted
 */
@property (nonatomic,assign) BOOL isRotating;

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
- (void) keyboardWillDisappear:(NSNotification*)notification;

/**
    This method is called when a notification of type UIKeyboardCoViewWillRotateNotification is received
    @param notification The notification object
 */
- (void) viewControllerWillRotate:(NSNotification*)notification;

/**
    This method is called when a notification of type UIKeyboardCoViewDidRotateNotification is received
    @param notification The notification object
 */
- (void) viewControllerDidRotate:(NSNotification*)notification;

/**
	This method fix a CGRect from the keyboard show and hide notifications and transforms it into a relative to this view's superview CGRect
	@param originalRect The original CGRect
	@returns The fixed and this view's superview relative CGRect
 */
- (CGRect) fixKeyboardRect:(CGRect)originalRect;

@end









@implementation UIKeyboardCoView
@synthesize delegate = _delegate;
@synthesize isRotating = _isRotating;






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
    //It's not rotating
    self.isRotating = NO;
    
    //Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerWillRotate:) name:UIKeyboardCoViewWillRotateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerDidRotate:) name:UIKeyboardCoViewDidRotateNotification object:nil];

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
    
    //If it's rotating, begin animation from current state
    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
    if (self.isRotating){
        options |= UIViewAnimationOptionBeginFromCurrentState;
    }
    
    //Start the animation
    if ([self.delegate respondsToSelector:@selector(keyboardCoViewWillAppear:)])
        [self.delegate keyboardCoViewWillAppear:self];
    [UIView animateWithDuration:animDuration delay:0.0f
                    options:options
                     animations:^(void){
                         self.frame = selfEndingRect;
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         self.frame = selfEndingRect;
                         self.alpha = 1.0f;
                         if ([self.delegate respondsToSelector:@selector(keyboardCoViewDidAppear:)])
                             [self.delegate keyboardCoViewDidAppear:self];
                     }];
        
}


- (void) keyboardWillDisappear:(NSNotification*)notification{

    //Start animation ONLY if the view will not rotate
    if (!self.isRotating){
    
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

        
        //Animation options
        UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
        
        //Animate view
        if ([self.delegate respondsToSelector:@selector(keyboardCoViewWillDisappear:)])
            [self.delegate keyboardCoViewWillDisappear:self];
        [UIView animateWithDuration:animDuration delay:0.0f
                            options:options
                         animations:^(void){
                             self.frame = selfEndingRect;
                             self.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             self.frame = selfEndingRect;
                             self.alpha = 0.0f;
                             [self setHidden:YES];
                             if ([self.delegate respondsToSelector:@selector(keyboardCoViewDidDisappear:)])
                                 [self.delegate keyboardCoViewDidDisappear:self];
                         }];
    }
}











#pragma mark - Custom rotation notification methods
- (void) viewControllerWillRotate:(NSNotification*)notification{
    //Is rotating
    self.isRotating = YES;
}


- (void) viewControllerDidRotate:(NSNotification*)notification{
    //Is not rotating
    self.isRotating = NO;
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
