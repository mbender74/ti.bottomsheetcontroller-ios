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
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupGestureEvent];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    __weak __typeof(self)weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [UIView animateWithDuration:0.25
              delay:0.0
              options:UIViewAnimationOptionCurveEaseOut
              animations:^{
                [myParentProxy backgroundView].backgroundColor = viewBackgroundColor;
                //weakSelf.parentViewController.view.backgroundColor = viewBackgroundColor;
                [weakSelf moveView:weakSelf.lastStatus];
            } completion:^(BOOL finished) {
        }];
    });
    
}

#pragma mark -



- (void)setupData {
    dismissModeOfSheet = NO;
    backgroundViewHidden = YES;
    viewBackgroundColor = [UIColor clearColor];
    dimmedViewBackgroundColor = [[TiUtils colorValue:@"#22000000"] _color];
    fullViewYPosition = 100;
    partialViewYPosition = [UIScreen mainScreen].bounds.size.height - 130;
    expandedViewYPosition = ceilf([UIScreen mainScreen].bounds.size.height / 2);

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

        NSMutableArray *detentsOfController = [NSMutableArray arrayWithCapacity:2];

        //[TiUtils boolValue:[self valueForKey:@"prefersEdgeAttachedInCompactHeight"]
        
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

    
    if (customSheetScrollView){
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height;
        CGFloat bottomIntent = safeAreaInset.bottom;
        CGFloat topInset = customSheetScrollView.contentInset.top;

        if (self.lastStatus == partial) {
            bottomIntent = (((height) - 136) - bottomIntent);
        }
        else if (self.lastStatus == expanded) {
            bottomIntent = (((height)/2) - bottomIntent) - 6;
        }
        else {
            bottomIntent = bottomIntent + 24;
        }
        insets = UIEdgeInsetsMake(topInset, 0, bottomIntent, 0);
        [customSheetScrollView setContentInset:insets];
        [customSheetScrollView setScrollIndicatorInsets:insets];
    }

    
}

#pragma mark -

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
    CGFloat yPosition = fullViewYPosition;
    const CGFloat width = self.view.frame.size.width;
    const CGFloat height = self.view.frame.size.height;
    CGFloat bottomIntent = safeAreaInset.bottom;

    if (dismissModeOfSheet == NO){
        if (state == partial) {
            yPosition = partialViewYPosition;
            bottomIntent = (((height) - 136) - bottomIntent);
            
        } else if (state == expanded) {
            yPosition = expandedViewYPosition;
            bottomIntent = (((height)/2) - bottomIntent) - 6;
        }
        else {
           // bottomIntent = 130;
          //  bottomIntent = bottomIntent - 100;
           // bottomIntent = bottomIntent + 24;
            bottomIntent = bottomIntent + 24;

        }
    }
    else {
        yPosition = [UIScreen mainScreen].bounds.size.height;
       // bottomIntent = bottomIntent - 100;
       // bottomIntent = bottomIntent + 24;
        bottomIntent = bottomIntent + 24;

    }

    CGRect rect = CGRectMake(0 , yPosition, width, height);


   // NSLog(@"before insets %f",bottomIntent);
   // NSLog(@"customSheetScrollView %@",customSheetScrollView);

    CGFloat topInset = customSheetScrollView.contentInset.top;

    if (customSheetScrollView){
     //   NSLog(@"intents %f",bottomIntent);

        insets = UIEdgeInsetsMake(topInset, 0, bottomIntent, 0);
        [customSheetScrollView setContentInset:insets];
        [customSheetScrollView setScrollIndicatorInsets:insets];
    }
    
    self.view.frame = rect;
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    
    if(panInit == YES){
        panInit = NO;
        translation.y = 0;
    }
    
  //  NSLog(@"sheet translation %f", translation.y);

    
//    if (translation.y > 1){
//        translation.y = 1;
//    }
    
    const CGFloat minY = self.view.frame.origin.y;
    dismissModeOfSheet = NO;
    
    if ((minY + translation.y >= maxPosition)) {
        const CGFloat width = self.view.frame.size.width;
        const CGFloat height = self.view.frame.size.height;
        const CGRect rect = CGRectMake(0 , minY + translation.y, width, height);
        self.view.frame = rect;
        [recognizer setTranslation:CGPointZero inView:self.view];
        if (minY + translation.y > minPosition) {
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

//    NSLog(@"panEnabled %d",panEnabled);
//
//    NSLog(@"translation %f",translation.y);
//    NSLog(@"lastTranslation %f",lastTranslation);
//
//    NSLog(@"newSrollViewOffsetY %f",newSrollViewOffsetY);
//    NSLog(@"lastScrollViewOffsetY %f",lastScrollViewOffsetY);
//    NSLog(@"customSheetScrollView.isDragging %d",customSheetScrollView.isDragging);
//
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//    });
    
    
    if (customSheetScrollView != nil){

        
        if (panFromScrollView == YES){
           // NSLog(@"----------------  panFromScrollView");

            if (panEnabled == YES && customSheetScrollView.isDragging == NO){
              //  NSLog(@"----------------  panFromScrollView SKIP");

                return;
            }

        }
        else {
          //  NSLog(@"--------------  NO panFromScrollView");

        }
        
        if (lastScrollViewOffsetY != newSrollViewOffsetY && customSheetScrollView.isDragging != NO){
          //  NSLog(@"lastScrollViewOffsetY != newSrollViewOffsetY &&  dragging != NO");
            lastScrollViewOffsetY = newSrollViewOffsetY;
            lastTranslation = translation.y;
        }
        else {

            if ((panEnabled == YES && lastTranslation == newSrollViewOffsetY) || (panEnabled == YES && translation.y == 0)){
                
                if ((panEnabled == YES && lastScrollViewOffsetY == newSrollViewOffsetY)){
                    lastTranslation = translation.y;
                    lastScrollViewOffsetY = newSrollViewOffsetY;
               //     NSLog(@"++++++++++++++  NO SKIP");

                }
                else  {
                    if (customSheetScrollView.isDragging == NO){
                       // NSLog(@"SKIP");
                        lastTranslation = translation.y;
                        lastScrollViewOffsetY = newSrollViewOffsetY;
                        return;
                    }
                  //  NSLog(@"++++++++++++++  NO SKIP AFTER");

                    lastTranslation = translation.y;
                    lastScrollViewOffsetY = newSrollViewOffsetY;
                }
            }
            
            lastTranslation = translation.y;
            lastScrollViewOffsetY = newSrollViewOffsetY;
        }
        if (panEnabled == NO){
            lastTranslation = translation.y;

            lastScrollViewOffsetY = newSrollViewOffsetY;
            return;
        }
        lastTranslation = translation.y;

        lastScrollViewOffsetY = newSrollViewOffsetY;
    }
    
    
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
       // dispatch_async(dispatch_get_main_queue(), ^{

        [UIView animateKeyframesWithDuration:0.25
                                       delay:0.0
                                     options:UIViewKeyframeAnimationOptionAllowUserInteraction
                                  animations:^{
            const Director director = [recognizer velocityInView:weakSelf.view].y >= 0 ? down: up;
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

                                [UIView animateWithDuration:0.25
                                      delay:0.0
                                      options:UIViewAnimationOptionCurveEaseOut
                                      animations:^{
                                        [myParentProxy backgroundView].backgroundColor = viewBackgroundColor;
                                    } completion:^(BOOL finished) {
                                        if (backgroundViewHidden == YES){
                                            [myParentProxy backgroundView].hidden = backgroundViewHidden;
                                        }
                                        if (customSheetScrollView != nil){
                                            customSheetScrollView.panGestureRecognizer.enabled = YES;
                                        }
                                }];
                            });
                            
                           
                    }

                    id detentID = detentString;

                    [myParentProxy sendEvent:detentID];
                    dismissModeOfSheet = NO;

            
                } completion:^(BOOL finished) {
                   
                    
                }];
       // });
    }
    

}

@end
