//
//  BottomSheetViewController.m
//  navi-lite
//
//  Created by Phineas.Huang on 2020/5/29.
//  Copyright © 2020 Garmin. All rights reserved.
//

#import "BottomSheetViewController.h"
#import "TiBottomsheetcontrollerProxy.h"


@interface BottomSheetViewController ()


@end

@implementation BottomSheetViewController


#pragma mark Public APIs

TiBottomsheetcontrollerProxy *myParentProxy;
UIScrollView *customSheetScrollView;
UIView *customView;
CGRect windowRect;

UIPanGestureRecognizer *thisGesture;
UIEdgeInsets safeAreaInset;

-(id)proxyOfBottomSheetController
{
    return myParentProxy;
}
-(void)setProxyOfBottomSheetController:(id)args
{
    myParentProxy = args;
}



#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fullViewYPosition = 100;
    partialViewYPosition = [UIScreen mainScreen].bounds.size.height - 130;
    expandedViewYPosition = ceilf([UIScreen mainScreen].bounds.size.height / 2);
    
    self.fullViewYPosition = fullViewYPosition;
    self.partialViewYPosition = partialViewYPosition;
    self.expandedViewYPosition = expandedViewYPosition;
    
    [self setupData];
    [self setupGestureEvent];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    __weak __typeof(self)weakSelf = self;
    
    
    customView = [myParentProxy contentViewOfSheet];
    windowRect = customView.frame;
    director = up;
    
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [myParentProxy backgroundView].backgroundColor = viewBackgroundColor;
        [weakSelf moveView:weakSelf.lastStatus];
    } completion:^(BOOL finished) {
        
        CGFloat startY = fullViewYPosition;

        if (self.lastStatus == partial) {
            startY = partialViewYPosition;
        } else if (self.lastStatus == expanded) {
            startY = expandedViewYPosition;
        }
        customView = [myParentProxy contentViewOfSheet];
        windowRect = customView.frame;

        if (customSheetScrollView){
                customViewRect = customSheetScrollView.frame;
                customViewRect.size.height = self.view.frame.size.height - startY;
                customSheetScrollView.frame = customViewRect;
                customView.frame = windowRect;

            if (myParentProxy.fixedHeight == NO){
                [myParentProxy.viewProxy reposition];
                [myParentProxy.viewProxy layoutChildrenIfNeeded];
            }
        }
        else {
            if (myParentProxy.fixedHeight == NO){
                customViewRect = customView.frame;
                customViewRect.size.height = self.view.frame.size.height - startY;
                customView.frame = customViewRect;

                [myParentProxy.viewProxy reposition];
                [myParentProxy.viewProxy layoutChildrenIfNeeded];
            }
        }

    }];
    [myParentProxy fireEvent:@"opened" withObject:nil];
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
    
    fullViewYPosition = self.fullViewYPosition;
    partialViewYPosition = self.partialViewYPosition;
    expandedViewYPosition = self.expandedViewYPosition;
    
    width = self.view.frame.size.width;
    height = self.view.frame.size.height;

    safeAreaInset = UIEdgeInsetsZero;
    UIViewController<TiControllerContainment> *topContainerController = [[[TiApp app] controller] topContainerController];
    safeAreaInset = [[topContainerController hostingView] safeAreaInsets];
    
    
    maxPosition = fullViewYPosition;
    maxState = full;

    minPosition = partialViewYPosition;
    minState = partial;

    if ([myParentProxy valueForKey:@"startDetent"]){
        startDetent = [TiUtils stringValue:[myParentProxy valueForKey:@"startDetent"]];
    }
    else {
        startDetent = @"small";
    }
    
    if ([myParentProxy valueForKey:@"detents"]){
        userDetents = [myParentProxy valueForKey:@"detents"];
        
        if ([TiUtils boolValue:[userDetents valueForKey:@"large"] def:YES]){
            maxPosition = fullViewYPosition;
            maxState = full;
            if (![TiUtils boolValue:[userDetents valueForKey:@"small"] def:YES] && ![TiUtils boolValue:[userDetents valueForKey:@"medium"] def:YES]){
                mediumPosition = NO;
                smallPosition = NO;

                minPosition = fullViewYPosition;
                minState = full;
                startDetent = @"large";
            }
            else {
                if (![TiUtils boolValue:[userDetents valueForKey:@"small"] def:YES] && [TiUtils boolValue:[userDetents valueForKey:@"medium"] def:YES]){
                    minPosition = expandedViewYPosition;
                    minState = expanded;
                    smallPosition = NO;

                    if (![startDetent isEqual:@"medium"] && ![startDetent isEqual:@"large"]){
                        startDetent = @"medium";
                    }
                }
                else if ([TiUtils boolValue:[userDetents valueForKey:@"small"] def:YES] && ![TiUtils boolValue:[userDetents valueForKey:@"medium"] def:YES]){
                    mediumPosition = NO;

                    if ([startDetent isEqual:@"medium"] && ![startDetent isEqual:@"large"]){
                        startDetent = @"small";
                    }
                }
            }
        }
        else if ([TiUtils boolValue:[userDetents valueForKey:@"medium"] def:YES]){
            maxPosition = expandedViewYPosition;
            maxState = expanded;
            fullPositon = NO;

            if (![TiUtils boolValue:[userDetents valueForKey:@"small"] def:YES]){
                minPosition = expandedViewYPosition;
                minState = expanded;
                smallPosition = NO;

                if ([startDetent isEqual:@"small"] || [startDetent isEqual:@"large"]){
                    startDetent = @"medium";
                }
            }
            else {
                if ([startDetent isEqual:@"large"]){
                    startDetent = @"medium";
                }
            }
        }
        else if ([TiUtils boolValue:[userDetents valueForKey:@"small"] def:YES]){
            maxPosition = partialViewYPosition;
            maxState = partial;
            mediumPosition = NO;
            fullPositon = NO;

            if ([startDetent isEqual:@"medium"] || [startDetent isEqual:@"large"]){
                startDetent = @"small";
            }
        }
        else {
            maxPosition = fullViewYPosition;
            maxState = full;
        }
    }
    
    
    if ([myParentProxy nonSystemSheetAutomaticStartPositionFromContentViewHeight] == YES){
        CGFloat realHeight;
        //realHeight = [myParentProxy realContentHeight] + safeAreaInset.bottom;
        realHeight = [myParentProxy realContentHeight];

        fullViewYPosition = [UIScreen mainScreen].bounds.size.height - realHeight;
                
        maxPosition = fullViewYPosition;
        minPosition = fullViewYPosition;
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
    
   
    if ([startDetent isEqual: @"small"]){
        if ([TiUtils boolValue:[userDetents valueForKey:@"small"] def:YES]){
            self.lastStatus = partial;
            
            if (![largestUndimmedDetent isEqual: @"small"]){
                backgroundViewHidden = NO;
                viewBackgroundColor = dimmedViewBackgroundColor;
            }
        }
        else {
            self.lastStatus = expanded;
            
            if (![largestUndimmedDetent isEqual: @"medium"]){
                backgroundViewHidden = NO;
                viewBackgroundColor = dimmedViewBackgroundColor;
            }
        }
    }
    else if ([startDetent isEqual: @"medium"]){
        if ([TiUtils boolValue:[userDetents valueForKey:@"medium"] def:YES]){
            self.lastStatus = expanded;
            if (![largestUndimmedDetent isEqual: @"medium"]){
                backgroundViewHidden = NO;
                viewBackgroundColor = dimmedViewBackgroundColor;
            }
        }
        else {
            self.lastStatus = full;
            if (![largestUndimmedDetent isEqual: @"full"]){
                backgroundViewHidden = NO;
                viewBackgroundColor = dimmedViewBackgroundColor;
            }
        }
    }
    else if ([startDetent isEqual: @"large"]){
        if ([TiUtils boolValue:[userDetents valueForKey:@"large"] def:YES]){
            self.lastStatus = full;
            if (![largestUndimmedDetent isEqual: @"full"]){
                backgroundViewHidden = NO;
                viewBackgroundColor = dimmedViewBackgroundColor;
            }
        }
        else {
            self.lastStatus = expanded;
            if (![largestUndimmedDetent isEqual: @"medium"]){
                backgroundViewHidden = NO;
                viewBackgroundColor = dimmedViewBackgroundColor;
            }
        }
    }
    else {
        self.lastStatus = expanded;
        if ([largestUndimmedDetent isEqual: @"small"]){
            backgroundViewHidden = NO;
            viewBackgroundColor = dimmedViewBackgroundColor;
        }
    }
    [myParentProxy backgroundView].hidden = backgroundViewHidden;
}

#pragma mark -

- (void)changeInsets:(UIView *)view
{
    CGFloat bottomIntent = safeAreaInset.bottom;
    CGFloat topInset;
    CGFloat diffPos = (yPosition-(yPosition-maxPosition));
    
    
    if (self.lastStatus == partial) {
                bottomIntent = ((height)-130)+safeAreaInset.bottom;
            }
    else if (self.lastStatus == expanded) {
                bottomIntent = ((height/2))+safeAreaInset.bottom;
    }
    else {
                bottomIntent = safeAreaInset.bottom + 100;
    }
    
    if ([view respondsToSelector:@selector(setScrollEnabled:)]){

            if ([view isKindOfClass:[UITableView class]]){
                UITableView *thisTableView = (UITableView *)view;
                topInset = thisTableView.contentInset.top;

                scrollBarinsets = UIEdgeInsetsMake(topInset + 20, 0, bottomIntent - 20, 0);
                insets = UIEdgeInsetsMake(topInset, 0, bottomIntent - 20, 0);
                [thisTableView setContentInset:insets];
                [thisTableView setScrollIndicatorInsets:scrollBarinsets];
            }
            else if ([view isKindOfClass:[UIScrollView class]]){
                UIScrollView *thisTableView = (UIScrollView *)view;
                topInset = thisTableView.contentInset.top;
                insets = UIEdgeInsetsMake(topInset, 0, bottomIntent - 20, 0);
                scrollBarinsets = UIEdgeInsetsMake(topInset + 20, 0, bottomIntent, 0);
                [thisTableView setContentInset:insets];
                [thisTableView setScrollIndicatorInsets:scrollBarinsets];
            }
            else {
            }
    }
    else {
        for (UIView *eachView in view.subviews) {

            if ([eachView respondsToSelector:@selector(setScrollEnabled:)]){
                    
                    if ([eachView isKindOfClass:[UITableView class]]){
                        UITableView *thisTableView = (UITableView *)eachView;
                        topInset = thisTableView.contentInset.top;
                        insets = UIEdgeInsetsMake(topInset, 0, bottomIntent, 0);
                        scrollBarinsets = UIEdgeInsetsMake(topInset + 20, 0, bottomIntent, 0);

                        [thisTableView setContentInset:insets];
                        [thisTableView setScrollIndicatorInsets:scrollBarinsets];
                    }
                    else if ([eachView isKindOfClass:[UIScrollView class]]){
                        UIScrollView *thisTableView = (UIScrollView *)eachView;
                        topInset = thisTableView.contentInset.top;
                        insets = UIEdgeInsetsMake(topInset, 0, bottomIntent - 20, 0);
                        scrollBarinsets = UIEdgeInsetsMake(topInset + 20, 0, bottomIntent, 0);

                        [thisTableView setContentInset:insets];
                        [thisTableView setScrollIndicatorInsets:scrollBarinsets];
                    }
                    else {
                    }
            }
            [self changeInsets:eachView];
        }
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
    thisGesture = gesture;
    [self roundViews];
}

- (void)moveView:(State)state {
    yPosition = fullViewYPosition;

    if (dismissModeOfSheet == NO){
        if (state == partial) {
            yPosition = partialViewYPosition;
        } else if (state == expanded) {
            yPosition = expandedViewYPosition;
        }
        else {

        }
    }
    else {
        yPosition = [UIScreen mainScreen].bounds.size.height;
    }

    CGRect rect = CGRectMake(0 , yPosition, width, height);
    customViewRect.size.height = height - yPosition;
        
    self.view.frame = rect;
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    
    if(panInit == YES){
        panInit = NO;
        translation.y = 0;
    }

    const CGFloat minY = self.view.frame.origin.y;
    dismissModeOfSheet = NO;
    CGFloat newY = minY + translation.y;

    if ((newY >= maxPosition)) {
        width = self.view.frame.size.width;
        height = self.view.frame.size.height;
        const CGRect rect = CGRectMake(0 , newY, width, height);
        self.view.frame = rect;
               
        if (recognizer.state != UIGestureRecognizerStateEnded) {
            customViewRect.size.height = height - newY;

            if (customSheetScrollView){
                    customSheetScrollView.frame = customViewRect;
                    customView.frame = windowRect;

                if (myParentProxy.fixedHeight == NO){
                    [myParentProxy.viewProxy reposition];

                    [myParentProxy.viewProxy layoutChildren:YES];
                    [myParentProxy.viewProxy willChangeSize];
                }
            }
            else {
                if (myParentProxy.fixedHeight == NO){
                    customView.frame = customViewRect;

                    [myParentProxy.viewProxy reposition];

                    [myParentProxy.viewProxy layoutChildren:YES];
                    [myParentProxy.viewProxy willChangeSize];
                }
            }

        }
        [recognizer setTranslation:CGPointZero inView:self.view];
        if (newY > minPosition) {
            dismissModeOfSheet = YES;
        }
        else {
            dismissModeOfSheet = NO;
        }
    }
}




- (void)roundViews {
    self.view.clipsToBounds = NO;
}

- (void)scrollView:(UIScrollView*)scrollview {
    customSheetScrollView = scrollview;
}
- (void)lastContentOffsetY:(CGFloat)contentOffsetY{
    newSrollViewOffsetY = contentOffsetY;
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
                    if (endLocation > expandedViewYPosition &&
                        director == down && smallPosition) {
                        state = partial;
     
                    } else if (endLocation < expandedViewYPosition &&
                               director == up && fullPositon) {
                        if (maxPosition == fullViewYPosition){
                            state = full;
                        }
                        else {
                            state = expanded;
                        }
                    }

                } else if (state == partial &&
                    weakSelf.lastStatus == partial) {
                    CGFloat endLocation = recognizer.view.frame.origin.y;
                    if (endLocation < expandedViewYPosition && mediumPosition) {
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
            
            
            [weakSelf moveView:state];
            if (director == up){
                if (customSheetScrollView){
                        customSheetScrollView.frame = customViewRect;
                        customView.frame = windowRect;

                    if (myParentProxy.fixedHeight == NO){
                        [myParentProxy.viewProxy reposition];

                        [myParentProxy.viewProxy layoutChildren:YES];
                        [myParentProxy.viewProxy willChangeSize];
                    }
                }
                else {

                    if (myParentProxy.fixedHeight == NO){
                        customView.frame = customViewRect;

                        [myParentProxy.viewProxy reposition];

                        [myParentProxy.viewProxy layoutChildren:YES];
                        [myParentProxy.viewProxy willChangeSize];
                    }
                }
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
                                if (backgroundViewHidden == NO){
                                    [myParentProxy backgroundView].hidden = backgroundViewHidden;
                                }

                                
                                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                    [myParentProxy backgroundView].backgroundColor = viewBackgroundColor;
                                    } completion:^(BOOL finished) {
                                        if (backgroundViewHidden == YES){
                                            [myParentProxy backgroundView].hidden = backgroundViewHidden;
                                        }
                                       

                                    }];
                               
                            });
                            
                    }

                    id detentID = detentString;

                    [myParentProxy sendEvent:detentID];
                    dismissModeOfSheet = NO;

            
                } completion:^(BOOL finished) {
                    if (director == down){
                        if (customSheetScrollView){
                                customSheetScrollView.frame = customViewRect;
                                customView.frame = windowRect;

                            if (myParentProxy.fixedHeight == NO){
                                [myParentProxy.viewProxy reposition];

                                [myParentProxy.viewProxy willChangeSize];
                                [myParentProxy.viewProxy layoutChildren:YES];

                            }
                        }
                        else {

                            if (myParentProxy.fixedHeight == NO){
                                customView.frame = customViewRect;

                                [myParentProxy.viewProxy reposition];

                                [myParentProxy.viewProxy willChangeSize];
                                [myParentProxy.viewProxy layoutChildren:YES];
                            }
                        }


                    }
                }];
    }
}

@end
