//
//  BottomSheetViewController.m
//  ti.bottomsheetcontroller-ios
//
//  Created by Marc Bender on 2020/5/29.
//  Copyright © 2020 by Marc Bender. All rights reserved.
//
#define USE_TI_UINAVIGATIONWINDOW
#import "BottomSheetViewController.h"
#import "TiBottomsheetcontrollerProxy.h"


@interface BottomSheetViewController (){
    TiBottomsheetcontrollerProxy *myParentProxy;
}

@end

@implementation BottomSheetViewController



#pragma mark Public APIs

-(id)proxyOfBottomSheetController
{
    return myParentProxy;
}

-(void)setProxyOfBottomSheetController:(id)args
{
    if (myParentProxy != args) {
        [myParentProxy release];
        myParentProxy = [args retain];
    }
}

- (void)dealloc
{
    [myParentProxy release];
    [super dealloc];
}


#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    maxState = full;
    maxPosition = 0;
    minState = partial;
    minPosition = 0;
    panEnabled = YES;
    panInit = NO;
    panFromScrollView = NO;
    width = 0;
    height = 0;
    customViewRect = CGRectZero;
    fullPositon = YES;
    mediumPosition = YES;
    smallPosition = YES;
    lastScrollViewOffsetY = 0;
    newSrollViewOffsetY = 0;
    lastTranslation = 0;
    yPosition = 0;
    dismissModeOfSheet = NO;
    doNotTranslate = NO;
    backgroundViewHidden = NO;
    viewBackgroundColor = nil;
    dimmedViewBackgroundColor = nil;
    largestUndimmedDetent = nil;
    startDetent = nil;
    detentString = nil;
    director = up;
    _fullViewYPosition = 100;
    _partialViewYPosition = [UIScreen mainScreen].bounds.size.height - 130;
    _expandedViewYPosition = ceilf([UIScreen mainScreen].bounds.size.height / 2);
    
    self.fullViewYPosition = _fullViewYPosition;
    self.partialViewYPosition = _partialViewYPosition;
    self.expandedViewYPosition = _expandedViewYPosition;
    customView = [myParentProxy contentViewOfSheet];
    if (customView != nil) {
        windowRect = customView.frame;
    }

    if (myParentProxy != nil) {
        [self setupData];
    }
    [self setupGestureEvent];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    __weak __typeof(self)weakSelf = self;
    
    
    director = up;
    
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if ([myParentProxy backgroundView] != nil){
            [myParentProxy backgroundView].backgroundColor = viewBackgroundColor;
        }
        [weakSelf moveView:weakSelf.lastStatus fromEvent:NO];
    } completion:^(BOOL finished) {
        CGFloat startY = _fullViewYPosition;

        if (self.lastStatus == partial) {
            startY = _partialViewYPosition;
        } else if (self.lastStatus == expanded) {
            startY = _expandedViewYPosition;
        }
        customView = [myParentProxy contentViewOfSheet];
        windowRect = customView.frame;

        if (customSheetScrollView) {
            customViewRect = customSheetScrollView.frame;
        } else {
            customViewRect = customView.frame;
        }
        customViewRect.size.height = self.view.frame.size.height - startY;

        if (myParentProxy.fixedHeight == NO) {
            [myParentProxy.viewProxy reposition];
            [myParentProxy.viewProxy layoutChildrenIfNeeded];
        }
    }];
    [myParentProxy fireEvent:@"open" withObject:nil];
}

#pragma mark -

- (void)setupData {
    dismissModeOfSheet = NO;
    backgroundViewHidden = YES;
    viewBackgroundColor = [UIColor clearColor];
    dimmedViewBackgroundColor = [[TiUtils colorValue:@"#22000000"] _color];
    
    
    if ([myParentProxy valueForKey:@"nonSystemSheetSmallHeight"]){
        self.partialViewYPosition = [UIScreen mainScreen].bounds.size.height - [TiUtils intValue:[myParentProxy valueForKey:@"nonSystemSheetSmallHeight"]];
    }
    if ([myParentProxy valueForKey:@"nonSystemSheetMediumHeight"]){
        self.expandedViewYPosition = [UIScreen mainScreen].bounds.size.height - [TiUtils intValue:[myParentProxy valueForKey:@"nonSystemSheetMediumHeight"]];

    }
    if ([myParentProxy valueForKey:@"nonSystemSheetLargeHeight"]){
        self.fullViewYPosition = [UIScreen mainScreen].bounds.size.height - [TiUtils intValue:[myParentProxy valueForKey:@"nonSystemSheetLargeHeight"]];
    }
    
    _fullViewYPosition = self.fullViewYPosition;
    _partialViewYPosition = self.partialViewYPosition;
    _expandedViewYPosition = self.expandedViewYPosition;
    
    width = self.view.frame.size.width;
    height = self.view.frame.size.height;

    safeAreaInset = UIEdgeInsetsZero;
    UIViewController<TiControllerContainment> *topContainerController = [[[TiApp app] controller] topContainerController];
    safeAreaInset = [[topContainerController hostingView] safeAreaInsets];
    
    
    maxPosition = _fullViewYPosition;
    maxState = full;

    minPosition = _partialViewYPosition;
    minState = partial;

    if ([myParentProxy valueForKey:@"startDetent"]){
        startDetent = [TiUtils stringValue:[myParentProxy valueForKey:@"startDetent"]];
    }
    else {
        startDetent = @"small";
    }
    
    if ([myParentProxy valueForKey:@"detents"]){
        userDetents = [myParentProxy valueForKey:@"detents"];

        BOOL hasLarge = [TiUtils boolValue:[userDetents valueForKey:@"large"] def:YES];
        BOOL hasMedium = [TiUtils boolValue:[userDetents valueForKey:@"medium"] def:YES];
        BOOL hasSmall = [TiUtils boolValue:[userDetents valueForKey:@"small"] def:YES];

        // Determine max/min positions based on available detents
        if (hasLarge) {
            maxPosition = _fullViewYPosition;
            maxState = full;
        }
        else if (hasMedium) {
            maxPosition = _expandedViewYPosition;
            maxState = expanded;
            fullPositon = NO;
        }
        else if (hasSmall) {
            maxPosition = _partialViewYPosition;
            maxState = partial;
            mediumPosition = NO;
            fullPositon = NO;
        }

        if (!hasSmall) {
            smallPosition = NO;
            minPosition = _expandedViewYPosition;
            minState = expanded;
        }
        if (!hasMedium) {
            mediumPosition = NO;
            if (hasLarge) {
                minPosition = _fullViewYPosition;
                minState = full;
            }
        }

        // Adjust startDetent to a valid detent
        if (![startDetent isEqual:@"small"] && ![startDetent isEqual:@"medium"] && ![startDetent isEqual:@"large"] && hasSmall) {
            startDetent = @"small";
        }
        if ([startDetent isEqual:@"small"] && !hasSmall) {
            startDetent = hasMedium ? @"medium" : @"large";
        }
        if ([startDetent isEqual:@"medium"] && !hasMedium) {
            startDetent = hasSmall ? @"small" : @"large";
        }
        if ([startDetent isEqual:@"large"] && !hasLarge) {
            startDetent = hasMedium ? @"medium" : @"small";
        }
    }
    
    
    if ([myParentProxy nonSystemSheetAutomaticStartPositionFromContentViewHeight] == YES){
        CGFloat realHeight;
        //realHeight = [myParentProxy realContentHeight] + safeAreaInset.bottom;
        realHeight = [myParentProxy realContentHeight];

        _fullViewYPosition = [UIScreen mainScreen].bounds.size.height - realHeight;
                
        maxPosition = _fullViewYPosition;
        minPosition = _fullViewYPosition;
        maxState = full;
        minState = full;
        mediumPosition = NO;
        smallPosition = NO;
        fullPositon = YES;
        startDetent = @"large";
    }

    if ([myParentProxy valueForKey:@"largestUndimmedDetentIdentifier"]){
        largestUndimmedDetent = [TiUtils stringValue:[myParentProxy valueForKey:@"largestUndimmedDetentIdentifier"]];
    }
    else {
        largestUndimmedDetent = @"small";
    }

    // Determine initial state from startDetent
    NSString *currentUndimmed = nil;
    if ([startDetent isEqual: @"small"]) {
        self.lastStatus = partial;
        currentUndimmed = @"small";
    }
    else if ([startDetent isEqual: @"medium"]) {
        self.lastStatus = expanded;
        currentUndimmed = @"medium";
    }
    else if ([startDetent isEqual: @"large"]) {
        self.lastStatus = full;
        currentUndimmed = @"full";
    }
    else {
        self.lastStatus = expanded;
        currentUndimmed = nil;
    }

    // Set background dimming if current state is larger than undimmed detent
    if (currentUndimmed != nil && ![currentUndimmed isEqual: largestUndimmedDetent]) {
        backgroundViewHidden = NO;
        viewBackgroundColor = dimmedViewBackgroundColor;
    }

    if ([myParentProxy backgroundView] != nil) {
        [myParentProxy backgroundView].hidden = backgroundViewHidden;
    }
}

#pragma mark -

- (void)changeInsets:(UIView *)view
{
    CGFloat bottomIntent = safeAreaInset.bottom;
    
    if (self.lastStatus == partial) {
        bottomIntent = (height - 130) + safeAreaInset.bottom;
    }
    else if (self.lastStatus == expanded) {
        bottomIntent = (height / 2) + safeAreaInset.bottom;
    }
    else {
        bottomIntent = safeAreaInset.bottom + 100;
    }
    
    if ([view respondsToSelector:@selector(setScrollEnabled:)]){
        UIScrollView *scrollView = (UIScrollView *)view;
        CGFloat topInset = scrollView.contentInset.top;

        insets = UIEdgeInsetsMake(topInset, 0, bottomIntent - 20, 0);
        scrollBarinsets = UIEdgeInsetsMake(topInset + 20, 0, bottomIntent, 0);
        [scrollView setContentInset:insets];
        [scrollView setScrollIndicatorInsets:scrollBarinsets];
    }
    
    for (UIView *eachView in view.subviews) {
        [self changeInsets:eachView];
    }
}

- (State)state {
    return self.lastStatus;
}
- (void)panFromScrollView:(bool)enabled {
    panFromScrollView = enabled;
}
- (void)panRecognizerEnabled:(bool)enabled {
    panEnabled = enabled;
}
- (bool)panRecognizerState {
    return panEnabled;
}

- (void)panRecognizerInit:(bool)enabled {
    panInit = enabled;
}
- (UIPanGestureRecognizer *)panRecognizer {
    return thisGesture;
}

- (void)setupGestureEvent {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *singleFingerTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    thisTapGesture = singleFingerTap;
    singleFingerTap.delegate = self;

    thisGesture = gesture;
    [self roundViews];
}

- (void)moveView:(State)state fromEvent:(bool)tapEvent {
     
    yPosition = _fullViewYPosition;

    if (dismissModeOfSheet == NO){
        if (state == partial) {
            yPosition = _partialViewYPosition;
        } else if (state == expanded) {
            yPosition = _expandedViewYPosition;
        }
        else {
            yPosition = _fullViewYPosition;
        }
    }
    else {
        yPosition = [UIScreen mainScreen].bounds.size.height;
    }

    CGRect rect = CGRectMake(0 , yPosition, width, height);
    customViewRect.size.height = height - yPosition;
        
    self.view.frame = rect;
    
    if (tapEvent == YES) {
        [self repositionContentView];
    }
    
        
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)recognizer {
    bool doNotDismiss = NO;
    if ([TiUtils boolValue:[myParentProxy valueForUndefinedKey:@"nonSystemSheetDisablePanGestureDismiss"] def:NO] == YES){
        doNotDismiss = YES;
    }
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint location = [recognizer locationInView:self.view];
    doNotTranslate = NO;

    if(panInit == YES){
        panInit = NO;
        translation.y = 0;
    }
    const CGFloat minY = self.view.frame.origin.y;
    dismissModeOfSheet = NO;
    CGFloat newY = minY + translation.y;
       
    if (location.x < customView.superview.frame.origin.x || location.x > (customView.superview.frame.origin.x + customView.superview.frame.size.width)){
        doNotTranslate = YES;
        return;
    }

    if (doNotDismiss == YES){
        if (newY > maxPosition) {
            if (newY < minPosition){
                width = self.view.frame.size.width;
                height = self.view.frame.size.height;
                const CGRect rect = CGRectMake(0 , newY, width, height);
                self.view.frame = rect;

                if (recognizer.state != UIGestureRecognizerStateEnded) {
                    customViewRect.size.height = height - newY;
                    [self repositionContentView];
                }
                [recognizer setTranslation:CGPointZero inView:self.view];
                dismissModeOfSheet = NO;
            }
            else {
                doNotTranslate = YES;
            }
        }
    }
    
    else {
        if ((newY > maxPosition)) {
            width = self.view.frame.size.width;
            height = self.view.frame.size.height;
            const CGRect rect = CGRectMake(0 , newY, width, height);
            self.view.frame = rect;

            if (recognizer.state != UIGestureRecognizerStateEnded) {
                customViewRect.size.height = height - newY;
                [self repositionContentView];
            }
            [recognizer setTranslation:CGPointZero inView:self.view];
            if (newY > minPosition) {
                dismissModeOfSheet = YES;
            }
            else {
                dismissModeOfSheet = NO;
            }
        }
        else {
            doNotTranslate = YES;
        }
    }

}




- (void)roundViews {
    self.view.clipsToBounds = NO;
}

- (void)repositionContentView {
    if (myParentProxy.fixedHeight == NO) {
        if (customSheetScrollView) {
            customSheetScrollView.frame = customViewRect;
            customView.frame = windowRect;
        } else {
            customView.frame = customViewRect;
        }
        [myParentProxy.viewProxy reposition];
        [myParentProxy.viewProxy layoutChildren:YES];
        [myParentProxy.viewProxy willChangeSize];
    }
}

- (void)scrollView:(UIScrollView*)scrollview {
    customSheetScrollView = scrollview;
}
- (void)lastContentOffsetY:(CGFloat)contentOffsetY{
    newSrollViewOffsetY = contentOffsetY;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    
    CGPoint locationInSheet = [recognizer locationInView:self.view];

    if ([TiUtils boolValue:[myParentProxy valueForUndefinedKey:@"nonSystemSheetDisableDimmedBackgroundTouchDismiss"] def:NO] == NO){
        if (locationInSheet.x < customView.superview.frame.origin.x || locationInSheet.x > customView.superview.frame.origin.x+customView.superview.frame.size.width){
            dismissModeOfSheet = YES;
            [myParentProxy sendEvent:@"dismiss"];
            [myParentProxy fireEvent:@"dismissing" withObject:nil];
            return;
        }
        
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)recognizer {
    
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    [self moveViewWithGesture:recognizer];

    if (recognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }

    __weak __typeof(self)weakSelf = self;

    if (dismissModeOfSheet == YES){
        [myParentProxy sendEvent:@"dismiss"];
        [myParentProxy fireEvent:@"dismissing" withObject:nil];
        return;
    }
    
    if (doNotTranslate == YES){
        return;
    }
    else {

        [UIView animateKeyframesWithDuration:0.3
                                       delay:0.0
                                     options:UIViewKeyframeAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut
                                  animations:^{
            director = [recognizer velocityInView:weakSelf.view].y >= 0 ? down: up;
            State state = weakSelf.lastStatus;

            if (weakSelf.lastStatus == partial && director == up) {
                if (mediumPosition){
                    state = expanded;
                }
                else if (fullPositon){
                    state = full;
                }
                else {
                    if (smallPosition){
                        state = partial;
                    }
                    else {
                        state = partial;
                    }
                }
                
            } else if (weakSelf.lastStatus == expanded && director == up) {
                if (maxState == full){
                    state = full;
                }
                else {
                    state = expanded;
                }
            }

            if (weakSelf.lastStatus == full && director == down) {
                if (mediumPosition){
                    state = expanded;
                }
                else {
                    state = partial;
                }
               
            } else if (weakSelf.lastStatus == expanded && director == down) {
                if (smallPosition){
                    state = partial;
                }
                else {
                    state = expanded;
                }
            }

            // handle
            if (recognizer.view) {
                if (state == expanded) {
                    CGFloat endLocation = recognizer.view.frame.origin.y;
                    if (endLocation > _expandedViewYPosition &&
                        director == down && smallPosition) {
                        state = partial;
     
                    } else if (endLocation < _expandedViewYPosition &&
                               director == up && fullPositon) {
                        if (maxPosition == _fullViewYPosition){
                            state = full;
                        }
                        else {
                            state = expanded;
                        }
                    }

                } else if (state == partial &&
                    weakSelf.lastStatus == partial) {
                    CGFloat endLocation = recognizer.view.frame.origin.y;
                    if (endLocation < _expandedViewYPosition && mediumPosition) {
                        state = expanded;
                    }
                    else {
                        if (fullPositon){
                            state = full;
                        }
                        else {
                            state = partial;
                        }
                    }
                }
            }

            weakSelf.lastStatus = state;


            [weakSelf moveView:state fromEvent:NO];
            if (director == up) {
                [weakSelf repositionContentView];
            }

                   
                    if (self.lastStatus == expanded){
                        detentString = @"medium";
                    }
                    else if (self.lastStatus == full){
                        detentString = @"large";
                    }
                    else {
                        if (dismissModeOfSheet == false){
                            detentString = @"small";
                        }
                        else {
                            detentString = @"dismiss";
                        }
                    }

                    if (dismissModeOfSheet == NO){


                            if (weakSelf.lastStatus == expanded){
                                if ([largestUndimmedDetent isEqual: @"medium"]){
                                    backgroundViewHidden = YES;
                                    viewBackgroundColor = [UIColor clearColor];
                                }
                                else {
                                    if ([largestUndimmedDetent isEqual: @"small"]){
                                        backgroundViewHidden = NO;
                                        viewBackgroundColor = dimmedViewBackgroundColor;
                                    }
                                    else {
                                        backgroundViewHidden = YES;
                                        viewBackgroundColor = [UIColor clearColor];
                                    }
                                }
                            }
                            else if (weakSelf.lastStatus == full){
                                if ([largestUndimmedDetent isEqual: @"full"]){
                                    backgroundViewHidden = YES;
                                    viewBackgroundColor = [UIColor clearColor];
                                }
                                else {
                                    backgroundViewHidden = NO;
                                    viewBackgroundColor = dimmedViewBackgroundColor;
                                }
                            }
                            else {
                                // partial
                                if ([largestUndimmedDetent isEqual: @"small"] || [largestUndimmedDetent isEqual: @"medium"] || [largestUndimmedDetent isEqual: @"full"]){
                                    backgroundViewHidden = YES;
                                    viewBackgroundColor = [UIColor clearColor];
                                }
                                else {
                                    backgroundViewHidden = NO;
                                    viewBackgroundColor = dimmedViewBackgroundColor;
                                }
                            }

                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (backgroundViewHidden == NO && [myParentProxy backgroundView] != nil){
                                    [myParentProxy backgroundView].hidden = backgroundViewHidden;
                                }

                                
                                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                    [myParentProxy backgroundView].backgroundColor = viewBackgroundColor;
                                    } completion:^(BOOL finished) {
                                        if (backgroundViewHidden == YES && [myParentProxy backgroundView] != nil){
                                            [myParentProxy backgroundView].hidden = backgroundViewHidden;
                                        }
                                       

                                    }];
                               
                            });
                            
                    }

                    id detentID = detentString;

                    [myParentProxy sendEvent:detentID];
                    dismissModeOfSheet = NO;

            
                } completion:^(BOOL finished) {
                    if (director == down) {
                        [weakSelf repositionContentView];
                    }
                }];
    }
}

    
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView:self.view];

    if (CGRectContainsPoint(customView.superview.frame, location)) {
        if (gestureRecognizer == thisTapGesture){
            return NO;
        }
        return YES;
    }
   return YES;
}
    
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    return YES;
}
    
@end
