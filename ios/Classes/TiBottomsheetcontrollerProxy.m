/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2021 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 *
 *
 * CODE taken form Titaniim SDK
 */

#import "TiBottomsheetcontrollerProxy.h"
#import <TitaniumKit/TiApp.h>
#import <TitaniumKit/TiUtils.h>
#import <TitaniumKit/TiWindowProxy.h>
#import <libkern/OSAtomic.h>
#import "BottomSheetViewController.h"
#import "TiBottomsheetcontrollerModule.h"

TiBottomsheetcontrollerProxy *currentTiBottomSheet;
BottomSheetViewController *customBottomSheet;
TiBottomsheetcontrollerModule *bottomSheetModule;
UIView *closeButtonView = nil;

@implementation TiBottomsheetcontrollerProxy

#pragma mark Setup

- (id)init
{
    if (self = [super init]) {
      bottomSheetclosingCondition = [[NSCondition alloc] init];
      poWidth = TiDimensionUndefined;
      poHeight = TiDimensionUndefined;
      poBWidth = TiDimensionUndefined;
      poBHeight = TiDimensionUndefined;
       // NSLog(@"self %@",self);
      nonSystemSheetShouldScroll = NO;
      defaultsToNonSystemSheet = YES;
    }
        
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [viewController.view removeObserver:self forKeyPath:@"safeAreaInsets"];
    RELEASE_TO_NIL(viewController);
    popoverInitialized = NO;
    currentTiBottomSheet = nil;

    RELEASE_TO_NIL(bottomSheetclosingCondition);
    RELEASE_TO_NIL(contentViewProxy);
    #if !TARGET_OS_MACCATALYST
    bottomSheet.delegate = nil;
    #endif
    RELEASE_TO_NIL(customBottomSheet);
    RELEASE_TO_NIL(bottomSheet);
    
    [_detents release];
    [_largestUndimmedDetentIdentifier release];
  
    [super dealloc];
}

#pragma mark Public API
- (NSString *)apiName
{
    return @"Ti.UI.BottomSheetController";
}


- (NSString *)selectedDetentIdentifier
{
    if (defaultsToNonSystemSheet == NO){
        if (bottomSheet.selectedDetentIdentifier == UISheetPresentationControllerDetentIdentifierMedium){
            return @"medium";
        }
        else if (bottomSheet.selectedDetentIdentifier == UISheetPresentationControllerDetentIdentifierLarge){
            return @"large";
        }
        else {
            return @"none";
        }
    }
    else {
        return customBottomSheet.selectedDetentIdentifier;
    }
    
}


- (void)changeCurrentDetent:(id)value
{
    ENSURE_ARG_COUNT(value, 1);
    NSString *identifier = [TiUtils stringValue:[value objectAtIndex:0]];

    if (defaultsToNonSystemSheet == NO){
      
        UISheetPresentationControllerDetentIdentifier newDetent = bottomSheet.selectedDetentIdentifier;

        if ([identifier isEqual: @"large"] && ([bottomSheet.detents containsObject:[UISheetPresentationControllerDetent largeDetent]])){
            newDetent = UISheetPresentationControllerDetentIdentifierLarge;
        }
        else if ([identifier isEqual: @"medium"] && ([bottomSheet.detents containsObject:[UISheetPresentationControllerDetent mediumDetent]])){
            newDetent = UISheetPresentationControllerDetentIdentifierMedium;
        }
        [bottomSheet animateChanges:^{
            bottomSheet.selectedDetentIdentifier = newDetent;
        }];
    }
}

#pragma mark Public Constants


- (void)setLargestUndimmedDetentIdentifier:(id)value
{
    if ([[TiUtils stringValue:value] isEqual: @"large"]){
        _largestUndimmedDetentIdentifier = UISheetPresentationControllerDetentIdentifierLarge;
        if (bottomSheet != nil){
            bottomSheet.largestUndimmedDetentIdentifier = _largestUndimmedDetentIdentifier;
        }
    }
    else if ([[TiUtils stringValue:value] isEqual: @"medium"]){
        _largestUndimmedDetentIdentifier = UISheetPresentationControllerDetentIdentifierMedium;
        if (bottomSheet != nil){
            bottomSheet.largestUndimmedDetentIdentifier = _largestUndimmedDetentIdentifier;
        }
    }
}



- (void)setCloseButton:(id)value
{
  ENSURE_SINGLE_ARG(value, TiViewProxy);
 // NSLog(@"set closeButton ");

  if (closeButtonProxy != nil) {
    //  NSLog(@"release closeButtonproxy ");

      RELEASE_TO_NIL(closeButtonProxy);
  }

   // NSLog(@"closeButton ");

    closeButtonProxy = [(TiViewProxy *)value retain];
    [self replaceValue:closeButtonProxy forKey:@"closeButton" notification:NO];
   
    //
   
}
- (void)setNonSystemSheetShouldScroll:(id)value
{
    nonSystemSheetShouldScroll = [TiUtils boolValue:value];
}

- (void)setNonSystemSheet:(id)value
{
    if (@available(iOS 15, macCatalyst 15, *)) {
        defaultsToNonSystemSheet = [TiUtils boolValue:value];
    }
    else {
        defaultsToNonSystemSheet = YES;
    }
}


- (void)setContentView:(id)value
{
  ENSURE_SINGLE_ARG(value, TiViewProxy);
  if (contentViewProxy != nil) {
    RELEASE_TO_NIL(contentViewProxy);
  }
  contentViewProxy = [(TiViewProxy *)value retain];
    
  [self replaceValue:contentViewProxy forKey:@"contentView" notification:NO];
}


- (void)sendEvent:(id)args
{
    //NSLog(@"sendEvent");

    detentStatus = [TiUtils stringValue:args];
    
    if ([detentStatus isEqual:@"dismiss"]){

      //  NSLog(@"sendEvent dismiss");
        if (isDismissing == NO){
            isDismissing = YES;
            [self hide:nil];
        }
    }
    else {
        if (lastDetentStatus != detentStatus){
            NSMutableDictionary * event = [NSMutableDictionary dictionary];
            customBottomSheet.selectedDetentIdentifier = detentStatus;
            [event setValue:detentStatus
                     forKey:@"selectedDetentIdentifier"];
         
            [self fireEvent:@"detentChange" withObject:event];

           

          //  NSLog(@"sendEvent %@",[TiUtils stringValue:args]);
        }
        if (scrollView != nil){
          //  scrollView.scrollEnabled = YES;
          //  scrollView.userInteractionEnabled = NO;

          //  scrollView.panGestureRecognizer.enabled = YES;
            scrollView.dismissing = NO;
           // [customBottomSheet lastContentOffsetY:-1];
           // scrollView.panGestureRecognizer.enabled = YES;
            [customBottomSheet panFromScrollView:NO];

            [customBottomSheet panRecognizerEnabled:YES];
          //  scrollView.panGestureRecognizer.enabled = YES;

        }
    }
    lastDetentStatus = detentStatus;
}




#pragma mark Public Methods
- (void)addEventListener:(NSArray *)args
{
    NSString *type = [args objectAtIndex:0];

    if (![self _hasListeners:@"closed"] && [type isEqual:@"closed"]) {
       // NSLog(@"BottomSheet addEventListener");

        [super addEventListener:args];
    }
    if (![self _hasListeners:@"opened"] && [type isEqual:@"opened"]) {
       // NSLog(@"BottomSheet addEventListener");

        [super addEventListener:args];
    }
    if (![self _hasListeners:@"dismissing"] && [type isEqual:@"dismissing"]) {
      //  NSLog(@"BottomSheet addEventListener");

        [super addEventListener:args];
    }
    if (![self _hasListeners:@"detentChange"] && [type isEqual:@"detentChange"]) {
     //   NSLog(@"BottomSheet addEventListener");

        [super addEventListener:args];
    }

}

- (void)show:(id)args
{
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
   // NSLog(@"BottomSheet show");

   // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
       // if (isDismissing == NO){
           

            
          if (popoverInitialized == NO) {
            //  NSLog(@"!popoverInitialized");
              eventFired = NO;

              if (contentViewProxy == nil) {
                  NSLog(@"[ERROR] BottomSheet no contentView set - Ignoring call") return;
              }
             

              [self rememberSelf];
              [self retain];
                
              animated = [TiUtils boolValue:@"animated" properties:args def:YES];


              TiThreadPerformOnMainThread(
                  ^{
                    [self initAndShowSheetController];
                    isDismissing = NO;
                    popoverInitialized = YES;
                  },
                 YES);
          }
          else {

              NSLog(@"[ERROR] BottomSheet is showing. Ignoring call") return;
              
//              TiThreadPerformOnMainThread(
//                  ^{
//              [currentTiBottomSheet sendEvent:@"dismiss"];
//                  },
//                  YES);
              
          }
      //  }
        
  //  });

}

- (void)hide:(id)args
{
    //NSLog(@"BottomSheet hide");
    
      if (popoverInitialized == NO) {
          NSLog(@"BottomSheet is not showing. Ignoring call") return;
      }

    
  TiThreadPerformOnMainThread(
      ^{

          if (defaultsToNonSystemSheet == NO){
              [self->contentViewProxy windowWillClose];

              self->animated = [TiUtils boolValue:@"animated" properties:args def:YES];

              [[self viewController] dismissViewControllerAnimated:self->animated
                                                          completion:^{
                //  NSLog(@"BottomSheet closed iOS15+");
                      if (eventFired == NO){
                          eventFired = YES;
                          
                       //   NSLog(@"BottomSheet before closed fired");
                          
                          if ([self _hasListeners:@"closed"]) {
                              [self fireEvent:@"closed" withObject:nil];
                          }
                          
                       //   NSLog(@"BottomSheet closed fired");
                          
                          popoverInitialized = NO;

                          bottomSheet = nil;
                          viewController = nil;
                          contentViewProxy = nil;
                          centerProxy = nil;
                          closeButtonView = nil;
                          currentTiBottomSheet = nil;
                      }
                  
                                                        //[self cleanup];
                                                          }];

          }
          else {

              if (eventFired == NO){
                  eventFired = YES;
               //   NSLog(@"BottomSheet closed iOS < 15+");
                  [self->contentViewProxy windowWillClose];

                //


                  UIColor *viewBackgroundColor = [UIColor clearColor];
                                
                 

                  [UIView animateWithDuration:0.25
                        delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                        animations:^{
                          backgroundView.backgroundColor = viewBackgroundColor;
                          CGFloat width = customBottomSheet.view.frame.size.width;
                          CGFloat height = customBottomSheet.view.frame.size.height;
                          CGRect rect = CGRectMake(0 , [UIScreen mainScreen].bounds.size.height, width, height);
                          customBottomSheet.view.frame = rect;
                        } completion:^(BOOL finished) {
                            
                            if (finished){
                        
                              //  NSLog(@"BottomSheet before closed fired");
                                
                                if ([self _hasListeners:@"closed"]) {
                                    [self fireEvent:@"closed" withObject:nil];
                                  //  NSLog(@"BottomSheet closed fired");
                                }
                                    
                                    if (useNavController) {
                                        [centerProxy windowWillClose];
                                        [centerProxy close:nil];
                                        [centerProxy windowDidClose];
                                        centerProxy = nil;
                                    }
                                    [backgroundView removeFromSuperview];
                                    [customBottomSheet.view removeFromSuperview];
                                  //  [[TiApp app] hideModalController:viewController animated:NO];
                                [[NSNotificationCenter defaultCenter] removeObserver:self];
                                currentTiBottomSheet = nil;
                                
                                
                                [self forgetSelf];
                                [self release];
                                  //  [viewController.view removeFromSuperview];
                                    scrollView = nil;
                                    popoverInitialized = NO;
                                    contentViewProxy = nil;
                                    customBottomSheet = nil;
                                    backgroundView = nil;
                                    viewController = nil;
                                    closeButtonView = nil;

                                // [customBottomSheet willMoveToParentViewController:viewController];
                                // [customBottomSheet.view removeFromSuperview];
                                // [customBottomSheet removeFromParentViewController];

                                
                               

                            }


                  }];
                 

              }
              else {
                //  NSLog(@"BottomSheet closed Event already fired");
              }
          }
          
         // [self dealloc];
      },
      YES);
   
   
  //  NSLog(@"BottomSheet hide done");

}

- (TiBottomsheetcontrollerProxy*)bottomSheet
{
    return bottomSheet;
}

- (void)bottomSheetModule:(id)args
{
    bottomSheetModule = args;
}


- (UIView *)backgroundView
{
  return backgroundView;
}

- (UIScrollView *)scrollView
{
  return scrollView;
}


- (UIViewController *)viewController
{
  if (viewController == nil) {
    if ([contentViewProxy isKindOfClass:[TiWindowProxy class]]) {
      [(TiWindowProxy *)contentViewProxy setIsManaged:YES];
        viewController = [[(TiWindowProxy *)contentViewProxy hostingController] retain];
      //[viewController.view addObserver:self forKeyPath:@"safeAreaInsets" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    } else {
     //

      viewController = [[TiViewController alloc] initWithViewProxy:contentViewProxy];
     // [viewController.view addObserver:self forKeyPath:@"safeAreaInsets" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
  }
  viewController.view.clipsToBounds = NO;
  return viewController;
}

#pragma mark Internal Methods


- (void)cleanup
{
  currentTiBottomSheet = nil;
    // NSLog(@"cleanup 1 ");
    
    // NSLog(@"cleanup 2 ");

    
  [contentViewProxy setProxyObserver:nil];
  [contentViewProxy windowWillClose];

  popoverInitialized = NO;
 // [self fireEvent:@"hide" withObject:nil]; //Checking for listeners are done by fireEvent anyways.
//  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
  [contentViewProxy windowDidClose];
    // NSLog(@"cleanup 3 ");

  if ([contentViewProxy isKindOfClass:[TiWindowProxy class]]) {
    UIView *topWindowView = [[[TiApp app] controller] topWindowProxyView];
    if ([topWindowView isKindOfClass:[TiUIView class]]) {
      TiViewProxy *theProxy = (TiViewProxy *)[(TiUIView *)topWindowView proxy];
      if ([theProxy conformsToProtocol:@protocol(TiWindowProtocol)]) {
        [(id<TiWindowProtocol>)theProxy gainFocus];
      }
    }
  }
    // NSLog(@"cleanup 4 ");

  [self forgetSelf];
  [viewController.view removeObserver:self forKeyPath:@"safeAreaInsets"];
  RELEASE_TO_NIL(viewController);
    // NSLog(@"cleanup 5 ");

  [self performSelector:@selector(release) withObject:nil afterDelay:0.5];
  [bottomSheetclosingCondition lock];
  isDismissing = NO;
  [bottomSheetclosingCondition signal];
  [bottomSheetclosingCondition unlock];

    // NSLog(@"cleanup 6 ");

    popoverInitialized = NO;
    currentTiBottomSheet = nil;
    // NSLog(@"cleanup 7 ");

    RELEASE_TO_NIL(bottomSheetclosingCondition);
    RELEASE_TO_NIL(contentViewProxy);
   // bottomSheet.delegate = nil;
    //RELEASE_TO_NIL(bottomSheet);
    // NSLog(@"cleanup 8 ");

}

- (void)initAndShowSheetController
{
   // NSLog(@"initAndShowSheetController ");

  deviceRotated = NO;
  currentTiBottomSheet = self;
  [contentViewProxy setProxyObserver:self];
  if ([contentViewProxy isKindOfClass:[TiWindowProxy class]]) {
    useNavController = YES;

    UIView *topWindowView = [[[TiApp app] controller] topWindowProxyView];
    if ([topWindowView isKindOfClass:[TiUIView class]]) {
      TiViewProxy *theProxy = (TiViewProxy *)[(TiUIView *)topWindowView proxy];
      if ([theProxy conformsToProtocol:@protocol(TiWindowProtocol)]) {
        [(id<TiWindowProtocol>)theProxy resignFocus];
      }
    }
    [(TiWindowProxy *)contentViewProxy setIsManaged:YES];
    [(TiWindowProxy *)contentViewProxy open:nil];
    [(TiWindowProxy *)contentViewProxy gainFocus];
      
      if (closeButtonProxy){
          [closeButtonProxy windowWillOpen];
          [closeButtonProxy reposition];
          [closeButtonProxy layoutChildrenIfNeeded];

          CGFloat width = [closeButtonProxy autoWidthForSize:CGSizeMake(1000, 1000)];
          CGFloat height = [closeButtonProxy autoHeightForSize:CGSizeMake(width, 0)];
          CGRect closeButtonViewFrame = CGRectMake( 0 , 0, width, height);
          closeButtonView = [[UIView alloc] initWithFrame:closeButtonViewFrame];
         // NSLog(@"closeButton %f x %f",width,height);
      }
      
      
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updatePopoverNow];
        [contentViewProxy windowDidOpen];
    });
  } else {
    [contentViewProxy windowWillOpen];
    [contentViewProxy reposition];
     // NSLog(@"closeButtonProxy %@",closeButtonProxy);

      if (closeButtonProxy){
          [closeButtonProxy windowWillOpen];
          [closeButtonProxy reposition];
          [closeButtonProxy layoutChildrenIfNeeded];

          CGFloat width = [closeButtonProxy autoWidthForSize:CGSizeMake(1000, 1000)];
          CGFloat height = [closeButtonProxy autoHeightForSize:CGSizeMake(width, 0)];
          CGRect closeButtonViewFrame = CGRectMake( 0 , 0, width, height);
          closeButtonView = [[UIView alloc] initWithFrame:closeButtonViewFrame];

         // NSLog(@"closeButton %f x %f",width,height);
      }
    [self updateContentSize];

   // NSLog(@"before updatePopoverNow ");

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self updatePopoverNow];
      [contentViewProxy windowDidOpen];
    });
  }
}

- (CGSize)contentSize
{
#ifndef TI_USE_AUTOLAYOUT
  CGSize screenSize = [[UIScreen mainScreen] bounds].size;
  if (poWidth.type != TiDimensionTypeUndefined) {
    [contentViewProxy layoutProperties]->width.type = poWidth.type;
    [contentViewProxy layoutProperties]->width.value = poWidth.value;
    poWidth = TiDimensionUndefined;
  }

  if (poHeight.type != TiDimensionTypeUndefined) {
    [contentViewProxy layoutProperties]->height.type = poHeight.type;
    [contentViewProxy layoutProperties]->height.value = poHeight.value;
    poHeight = TiDimensionUndefined;
  }

 TiBottomSheetContentSize = SizeConstraintViewWithSizeAddingResizing([contentViewProxy layoutProperties], contentViewProxy, screenSize, NULL);

  return TiBottomSheetContentSize;
#else
  return CGSizeZero;
#endif
}

- (void)updateContentSize
{
//  NSLog(@"updateContentSize ");
    CGSize newSize = [self contentSize];

    if (defaultsToNonSystemSheet == NO){
        [[self viewController] setPreferredContentSize:newSize];
    }
    [contentViewProxy reposition];

}

- (void)updatePopoverNow
{
  //  NSLog(@"updatePopoverNow ");
    if (![self valueForKey:@"backgroundColor"] || [[self valueForKey:@"backgroundColor"] isEqual:@"transparent"]){
           [self replaceValue:[TiUtils hexColorValue:[UIColor lightGrayColor]] forKey:@"backgroundColor" notification:YES];
    }

    
    if (defaultsToNonSystemSheet == NO){

                UIViewController *theController = [self viewController];
       
                bottomSheet = [theController sheetPresentationController];
                
                bottomSheet.delegate = self;
       
                if ([self valueForKey:@"largestUndimmedDetentIdentifier"]){
                    if ([[TiUtils stringValue:[self valueForKey:@"largestUndimmedDetentIdentifier"]] isEqual: @"large"]){
                        _largestUndimmedDetentIdentifier = UISheetPresentationControllerDetentIdentifierLarge;
                        bottomSheet.largestUndimmedDetentIdentifier = _largestUndimmedDetentIdentifier;
                    }
                    else if ([[TiUtils stringValue:[self valueForKey:@"largestUndimmedDetentIdentifier"]] isEqual: @"medium"]){
                        _largestUndimmedDetentIdentifier = UISheetPresentationControllerDetentIdentifierMedium;

                        bottomSheet.largestUndimmedDetentIdentifier = _largestUndimmedDetentIdentifier;

                    }
                    else {
                    }
                }
                
                if ([self valueForKey:@"preferredCornerRadius"]){
                    bottomSheet.preferredCornerRadius = [TiUtils floatValue:[self valueForKey:@"preferredCornerRadius"]];
                }
                
        
        
               
        
                bottomSheet.prefersScrollingExpandsWhenScrolledToEdge = [TiUtils boolValue:[self valueForKey:@"prefersScrollingExpandsWhenScrolledToEdge"] def:YES];
                   
                bottomSheet.prefersEdgeAttachedInCompactHeight = [TiUtils boolValue:[self valueForKey:@"prefersEdgeAttachedInCompactHeight"] def:YES];
                
                bottomSheet.widthFollowsPreferredContentSizeWhenEdgeAttached = [TiUtils boolValue:[self valueForKey:@"widthFollowsPreferredContentSizeWhenEdgeAttached"] def:YES];
            
        
        
        
        
              if ([self valueForKey:@"detents"]){
                  userDetents = [self valueForKey:@"detents"];

                  NSMutableArray *detentsOfController = [NSMutableArray arrayWithCapacity:2];

                  if ([TiUtils boolValue:[self valueForKey:@"nonModal"] def:NO]) {
                      if ([TiUtils boolValue:[userDetents valueForKey:@"large"] def:NO]) {
                          [detentsOfController addObject:[UISheetPresentationControllerDetent largeDetent]];
                      }
                      if ([TiUtils boolValue:[userDetents valueForKey:@"medium"] def:NO]) {
                          [detentsOfController addObject:[UISheetPresentationControllerDetent mediumDetent]];
                      }
                  }
                  else {
                      if ([TiUtils boolValue:[userDetents valueForKey:@"medium"] def:NO]) {
                          [detentsOfController addObject:[UISheetPresentationControllerDetent mediumDetent]];
                      }
                      if ([TiUtils boolValue:[userDetents valueForKey:@"large"] def:NO]) {
                          [detentsOfController addObject:[UISheetPresentationControllerDetent largeDetent]];
                      }
                  }
                  
                 
                  bottomSheet.detents = detentsOfController;

                  if ([TiUtils stringValue:[self valueForKey:@"startDetent"]]){
                      if ([[TiUtils stringValue:[self valueForKey:@"startDetent"]] isEqual: @"large"] && ([TiUtils boolValue:[userDetents valueForKey:@"large"] def:NO])){
                          bottomSheet.selectedDetentIdentifier = UISheetPresentationControllerDetentIdentifierLarge;

                      }
                      else if ([[TiUtils stringValue:[self valueForKey:@"startDetent"]] isEqual: @"medium"] && ([TiUtils boolValue:[userDetents valueForKey:@"medium"] def:NO])){
                          bottomSheet.selectedDetentIdentifier = UISheetPresentationControllerDetentIdentifierMedium;

                      }
                      else {
                          
                      }
                  }
              }
          
            
                bottomSheet.prefersGrabberVisible = [TiUtils boolValue:[self valueForKey:@"prefersGrabberVisible"] def:YES];
            


            if ([self valueForKey:@"backgroundColor"]){

           //     [theController.view setBackgroundColor:[[TiUtils colorValue:[self valueForKey:@"backgroundColor"]] _color]];

//                [theController.view setBackgroundColor:[[TiUtils colorValue:[self valueForKey:@"backgroundColor"]] _color]];
            }
           [theController.view setBackgroundColor:[[TiUtils colorValue:[self valueForKey:@"backgroundColor"]] _color]];

           // [theController.view setBackgroundColor:[UIColor redColor]];

            if ([self valueForKey:@"modalPresentation"]){
                if ([[TiUtils stringValue:[self valueForKey:@"modalPresentation"]] isEqual: @"fullScreen"]){
                    [theController setModalPresentationStyle:UIModalPresentationFullScreen];
                }
                else if ([[TiUtils stringValue:[self valueForKey:@"modalPresentation"]] isEqual: @"pageSheet"]){
                    [theController setModalPresentationStyle:UIModalPresentationPageSheet];
                }
                else if ([[TiUtils stringValue:[self valueForKey:@"modalPresentation"]] isEqual: @"currentContext"]){
                    [theController setModalPresentationStyle:UIModalPresentationCurrentContext];
                }
                else if ([[TiUtils stringValue:[self valueForKey:@"modalPresentation"]] isEqual: @"overCurrentContext"]){
                    [theController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
                }
                else {
                    [theController setModalPresentationStyle:UIModalPresentationPageSheet];
                }
            }
            else {
                [theController setModalPresentationStyle:UIModalPresentationPageSheet];
            }
                
       
      //  NSLog(@"before closeButtonView ");

        if (closeButtonView != nil){
            closeButtonProxy.view.frame = closeButtonView.bounds;
            [closeButtonView addSubview:closeButtonProxy.view];
            [closeButtonProxy reposition];

            CGSize size = theController.view.frame.size;
            [closeButtonView setCenter:CGPointMake((size.width - (closeButtonView.bounds.size.width/2)), 24)];

            [theController.view addSubview:closeButtonView];
            [theController.view bringSubviewToFront:closeButtonView];
            
          //  NSLog(@"added closeButtonView ");
          //  NSLog(@"closeButtonView %@",closeButtonView);
       }

            [[[[TiApp app] controller] topPresentedController] presentViewController:theController animated:animated completion:^{
                [self fireEvent:@"opened" withObject:nil];

            }];
            
        
    }
    
    else {
        customBottomSheet = [BottomSheetViewController new];
        [customBottomSheet setProxyOfBottomSheetController:self];
      
      
        const CGFloat y = [[[TiApp app] controller] topPresentedController].view.frame.origin.y;
        const CGFloat height = [[[TiApp app] controller] topPresentedController].view.frame.size.height;
        const CGFloat width = [[[TiApp app] controller] topPresentedController].view.frame.size.width;

        backgroundView = [[UIView alloc] init];
        backgroundView.frame = CGRectMake( 0, 0, width, height);
        
        UITapGestureRecognizer *singleFingerTap =
          [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleSingleTap:)];
        [backgroundView addGestureRecognizer:singleFingerTap];


        customBottomSheet.view.frame = CGRectMake( 0, y + height, width, height);

        containerView = [[UIView alloc] init];
        
        if ([TiUtils boolValue:[self valueForUndefinedKey:@"nonSystemSheetTopShadow"] def:NO]){
            customBottomSheet.view.layer.shadowOffset = CGSizeMake(0,-2);
            customBottomSheet.view.layer.shadowRadius = 6;
            customBottomSheet.view.layer.shadowOpacity = .6f;
            customBottomSheet.view.layer.shadowColor = [UIColor blackColor].CGColor;
            //customBottomSheet.view.layer.masksToBounds = NO;
        }
        containerView.clipsToBounds = YES;

       
        
        [customBottomSheet.view addSubview:containerView];
        
        const CGFloat heightOfContainer = customBottomSheet.view.frame.size.height - 100;
        const CGFloat widthOfContainer = customBottomSheet.view.frame.size.width;
        containerView.frame = CGRectMake( 0, 0, widthOfContainer, heightOfContainer);
        
     

        useNavController = NO;

        if ([[[contentViewProxy class] description] isEqualToString:@"TiUINavigationWindowProxy"]) {
          useNavController = YES;
        }

        UIView *controllerView_;
        
        if (useNavController) {
          //[(TiWindowProxy *)contentViewProxy setIsManaged:YES];
            centerProxy = [self valueForUndefinedKey:@"contentView"];
            controllerView_ = [[centerProxy controller] view];
            [controllerView_ setFrame:[containerView bounds]];
        }
        else {
            controllerView_ = [contentViewProxy view];
            [controllerView_ setFrame:[containerView bounds]];
        }

        
        
        if (nonSystemSheetShouldScroll == YES){

          //  NSLog(@"nonSystemSheetShouldScroll == YES ");
            UIEdgeInsets safeAreaInset = UIEdgeInsetsZero;
            UIViewController<TiControllerContainment> *topContainerController = [[[TiApp app] controller] topContainerController];

            safeAreaInset = [[topContainerController hostingView] safeAreaInsets];

                const CGFloat heightOfScrollContainer = containerView.frame.size.height;
                const CGFloat widthOfScrollContainer = containerView.frame.size.width;
            
            
            scrollView = [[ContentScrollView alloc] initWithFrame:CGRectMake( 0, 0, widthOfScrollContainer, heightOfScrollContainer)];
            scrollView.dismissing = NO;
            scrollView.delegate = self;
//                UITapGestureRecognizer *panScrollView =
//                  [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                          action:@selector(handleGesture:)];
//                [scrollView addGestureRecognizer:panScrollView];
            scrollView.delaysContentTouches = NO;
               scrollView.scrollEnabled = YES;
              // scrollView.pagingEnabled = YES;
               scrollView.showsVerticalScrollIndicator = YES;
               scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.canCancelContentTouches = YES;
               scrollView.contentSize = CGSizeMake(controllerView_.frame.size.width, controllerView_.frame.size.height);
           // NSLog(@"contentSize height %f ",[contentViewProxy view].frame.size.height);
            scrollView.insetsLayoutMarginsFromSafeArea = YES;
            [containerView addSubview:scrollView];
            [scrollView addSubview:controllerView_];
            CGPoint contentOffet = scrollView.contentOffset;
            contentOffet.y = 0;
            scrollView.contentOffset = contentOffet;
            //[customBottomSheet panRecognizerEnabled:NO];
            [customBottomSheet panRecognizerEnabled:YES];
            [customBottomSheet scrollView:scrollView];
            [customBottomSheet lastContentOffsetY:0];
            
            
            [self disableScrolling:controllerView_];

        }
        else {
           // NSLog(@"nonSystemSheetShouldScroll == NO ");

            [containerView addSubview:controllerView_];
        }
        
       
        
        if ([self valueForKey:@"preferredCornerRadius"]){
            containerView.layer.cornerRadius = [TiUtils floatValue:[self valueForKey:@"preferredCornerRadius"]];
        }
        else {
            containerView.layer.cornerRadius = 10;
        }
        
        containerView.backgroundColor =  [[TiUtils colorValue:[self valueForKey:@"backgroundColor"]] _color];

        if ([TiUtils boolValue:[self valueForKey:@"prefersGrabberVisible"] def:YES]){
            CGRect handleViewFrame = CGRectMake( 0, 0, 44, 6);
            UIView *handle = [[UIView alloc] initWithFrame:handleViewFrame];
            handle.backgroundColor = [UIColor blackColor];
            handle.layer.cornerRadius = 4;
            handle.alpha = 0.4;
            CGSize size = containerView.frame.size;
            [handle setCenter:CGPointMake(size.width/2, 10)];

            if (nonSystemSheetShouldScroll == YES){
                [containerView insertSubview:handle aboveSubview:scrollView];
            }
            else {
                [containerView insertSubview:handle aboveSubview:controllerView_];
            }

            [handle release];
        }

        
        if (closeButtonView != nil){
            
            closeButtonProxy.view.frame = closeButtonView.bounds;
            [closeButtonView addSubview:closeButtonProxy.view];
            [closeButtonProxy reposition];


            CGSize size = containerView.frame.size;

            [closeButtonView setCenter:CGPointMake((size.width - (closeButtonView.bounds.size.width/2)), 24)];

            if (nonSystemSheetShouldScroll == YES){
                [containerView insertSubview:closeButtonView aboveSubview:scrollView];
            }
            else {
                [containerView insertSubview:closeButtonView aboveSubview:controllerView_];
            }
       }
        
     
       
       // [[[[TiApp app] controller] topPresentedController] presentViewController:theController animated:animated completion:^{
//        }];
        
        

        [[[[TiApp app] controller] topPresentedController].view addSubview:backgroundView];

        [[[[TiApp app] controller] topPresentedController].view insertSubview:customBottomSheet.view aboveSubview:backgroundView];

        
        
       // [[[[TiApp app] controller] topPresentedController].view addSubview:theController.view];
       // [[TiApp app] showModalController:theController animated:animated];

        [self fireEvent:@"opened" withObject:nil];

    }
    
}


- (void)disableScrolling:(UIView *)view
{
    
    if ([view respondsToSelector:@selector(setScrollEnabled:)]){
       // NSLog(@"UIView %@ ",view);

        if ([view performSelector: @selector (isScrollEnabled)]){
            
            if ([view isKindOfClass:[UITableView class]]){
                [(UITableView *)view setScrollEnabled:NO];
               // NSLog(@"TableView %@ ",view);

            }
            else if ([view isKindOfClass:[UIScrollView class]]){
                [(UIScrollView *)view setScrollEnabled:NO];
              //  NSLog(@"ScrollView %@ ",view);
            }
            else {
              //  NSLog(@"UIView isScrollEnabled %d ",[view performSelector: @selector (isScrollEnabled)]);
            }
        }
    }
    
    for (UIView *eachView in view.subviews) {

        if ([eachView respondsToSelector:@selector(setScrollEnabled:)]){
          //  NSLog(@"UIView %@ ",eachView);

            if ([eachView performSelector: @selector (isScrollEnabled)]){
                
                if ([eachView isKindOfClass:[UITableView class]]){
                    [(UITableView *)eachView setScrollEnabled:NO];
                    //NSLog(@"TableView %@ ",eachView);

                }
                else if ([eachView isKindOfClass:[UIScrollView class]]){
                    [(UIScrollView *)eachView setScrollEnabled:NO];
                    //NSLog(@"ScrollView %@ ",eachView);
                }
                else {
                  //  NSLog(@"UIView isScrollEnabled %d ",[eachView performSelector: @selector (isScrollEnabled)]);
                }
            }
        }
        [self disableScrolling:eachView];
    }
}


//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
  CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    if (isDismissing == NO){
        isDismissing = YES;
        [self hide:nil];
    }
  //Do stuff here...
}

- (void)handleGesture:(UITapGestureRecognizer *)recognizer
{
    if (scrollView.dismissing == NO){
       // NSLog(@"*************** handleGesture");
        [customBottomSheet panFromScrollView:YES];
    }
}


- (void)updateContentViewWithSafeAreaInsets:(NSValue *)insetsValue
{
  TiThreadPerformOnMainThread(
      ^{
        UIViewController *viewController = [self viewController];
          
//          CGRect newControllerFrame = viewController.view.frame;
//
//          newControllerFrame.size.height = viewController.view.frame.size.height + 24;
//          viewController.view.frame = newControllerFrame;

          self->contentViewProxy.view.frame = viewController.view.frame;

//          CGRect controllerFrame = viewController.view.frame;
//          controllerFrame.origin.y = 24;
//         // controllerFrame.size.height = controllerFrame.size.height - 24;
//          self->contentViewProxy.view.frame = controllerFrame;

//
        UIEdgeInsets edgeInsets = [insetsValue UIEdgeInsetsValue];
//
        viewController.view.frame = CGRectMake(viewController.view.frame.origin.x + edgeInsets.left, viewController.view.frame.origin.y + (edgeInsets.top), viewController.view.frame.size.width - edgeInsets.left - edgeInsets.right, viewController.view.frame.size.height - (edgeInsets.top) - edgeInsets.bottom);
          

//
//
//          self->contentViewProxy.view.frame = CGRectMake(self->contentViewProxy.view.frame.origin.x + edgeInsets.left, self->contentViewProxy.view.frame.origin.y + (edgeInsets.top), self->contentViewProxy.view.frame.size.width - edgeInsets.left - edgeInsets.right, self->contentViewProxy.view.frame.size.height - (edgeInsets.top) - edgeInsets.bottom);
          
      },
      NO);
}

#pragma mark Delegate methods


-(void)scrollViewDidScroll:(ContentScrollView *)scrollView{
    
   // NSLog(@"++++++++++ scrollViewDidScroll ");

    [customBottomSheet lastContentOffsetY:scrollView.contentOffset.y];
    
    if (scrollView.contentOffset.y <= 0) {
        //scrollView.contentOffset = CGPointZero;

        if (scrollView.dismissing == NO){
            scrollView.dismissing = YES;
            [customBottomSheet panRecognizerInit:YES];
            [customBottomSheet panRecognizerEnabled:YES];
           // scrollView.panGestureRecognizer.enabled = NO;
           // scrollView.panGestureRecognizer.enabled = NO;
          //  NSLog(@"++++++++++ scrollViewDidScroll disable ScrollView ");
            
        }
    }
    else {
        scrollView.dismissing = NO;
        [customBottomSheet panRecognizerEnabled:NO];
      //  scrollView.panGestureRecognizer.enabled = YES;
      //  NSLog(@"++++++++++ scrollViewDidScroll enable ScrollView ");
       // [customBottomSheet panFromScrollView:NO];

//        if (scrollView.panGestureRecognizer.enabled == NO){
//            scrollView.panGestureRecognizer.enabled = YES;
//        }
    }
     
}
//
- (void)scrollViewDidEndDecelerating:(ContentScrollView *)scrollView_ // scrolling has ended
{
    [customBottomSheet panRecognizerEnabled:YES];
   // NSLog(@"scrollViewDidEndDecelerating ");
   // scrollView.panGestureRecognizer.enabled = YES;
    scrollView.dismissing = NO;
    [customBottomSheet panFromScrollView:NO];
//    scrollView.panGestureRecognizer.enabled = YES;
  //  [customBottomSheet panRecognizerEnabled:YES];

}
//
- (void)scrollViewDidEndDragging:(ContentScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  //  NSLog(@"scrollViewDidEndDragging ");
    scrollView.dismissing = NO;
   // scrollView.panGestureRecognizer.enabled = YES;
    [customBottomSheet panRecognizerEnabled:YES];
    [customBottomSheet panFromScrollView:NO];

  //  [customBottomSheet panFromScrollView:NO];

}
//
//-(void)scrollViewWillBeginDragging:(ContentScrollView *)scrollView{
//   // [customBottomSheet panRecognizerEnabled:NO];
//    NSLog(@"scrollViewWillBeginDragging ");
//    if ([customBottomSheet panRecognizerState] == YES) {
//        NSLog(@"scrollViewWillBeginDragging pan disabled");
//        [customBottomSheet panRecognizerEnabled:NO];
//    }
//}


- (void)proxyDidRelayout:(id)sender
{
  if (sender == contentViewProxy) {
    if (viewController != nil) {
      CGSize newSize = [self contentSize];
      if (TiBottomSheetContentSize.width != newSize.width || TiBottomSheetContentSize.height != newSize.height){
        if (!CGSizeEqualToSize([viewController preferredContentSize], newSize)) {
          //  NSLog(@"proxyDidRelayout ");
          [self updateContentSize];
        }
      }
    }
  }
}


- (void)sheetPresentationControllerDidChangeSelectedDetentIdentifier :(UISheetPresentationController *)bottomSheetPresentationController
{
    
   // NSLog(@"\n\n sheetPresentationControllerDidChangeSelectedDetentIdentifier ");

    if (bottomSheetPresentationController.selectedDetentIdentifier == UISheetPresentationControllerDetentIdentifierMedium){
        NSDictionary *detentObject = [NSDictionary dictionaryWithObjectsAndKeys:@"medium", @"selectedDetentIdentifier", nil];
        [self fireEvent:@"detentChange" withObject:detentObject];
    }
    else if (bottomSheetPresentationController.selectedDetentIdentifier == UISheetPresentationControllerDetentIdentifierLarge){
        NSDictionary *detentObject = [NSDictionary dictionaryWithObjectsAndKeys:@"large", @"selectedDetentIdentifier", nil];
        [self fireEvent:@"detentChange" withObject:detentObject];
    }
}



- (BOOL)presentationControllerShouldDismiss:(UISheetPresentationController *)bottomSheetPresentationController
{
    
  //  NSLog(@"presentationControllerShouldDismiss ");

    
  if ([[self viewController] presentedViewController] != nil) {
    return NO;
  }
  [self fireEvent:@"dismissing" withObject:nil];

  [contentViewProxy windowWillClose];
  return YES;
}

- (void)presentationControllerDidDismiss:(UISheetPresentationController *)bottomSheetPresentationController
{
   // NSLog(@"presentationControllerDidDismiss ");
  //  DebugLog(@"BottomSheet presentationControllerDidDismiss");
    if (eventFired == NO){
        eventFired = YES;
        [self fireEvent:@"closed" withObject:nil];
    }

  currentTiBottomSheet = nil;

 // [self cleanup];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context
{
  if ([TiUtils isIOSVersionOrGreater:@"13.0"] && object == viewController.view && [keyPath isEqualToString:@"safeAreaInsets"]) {
    UIEdgeInsets newInsets = [[change objectForKey:@"new"] UIEdgeInsetsValue];
    UIEdgeInsets oldInsets = [[change objectForKey:@"old"] UIEdgeInsetsValue];
    NSValue *insetsValue = [NSValue valueWithUIEdgeInsets:newInsets];

    if (!UIEdgeInsetsEqualToEdgeInsets(oldInsets, newInsets)) {
      deviceRotated = NO;
      [self updateContentViewWithSafeAreaInsets:insetsValue];
    } else if (deviceRotated) {
      // [self viewController]  need a bit of time to set its frame while rotating
      deviceRotated = NO;
      [self performSelector:@selector(updateContentViewWithSafeAreaInsets:) withObject:insetsValue afterDelay:.05];
    }
  }
}

- (void)deviceRotated:(NSNotification *)sender
{
  deviceRotated = YES;
}



@end

@implementation ContentScrollView
//
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *hitView = [super hitTest:point withEvent:event];
//
//    if (hitView == self) {
//        return nil;
//    }
//    return hitView;
//}

//- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIPanGestureRecognizer *)otherGestureRecognizer
//{
//    NSLog(@"gestureRecognizer: %f ",self.contentOffset.y);
//
////
////    if (self.scrollEnabled == YES){
////
////        if (self.contentOffset.y < 0) {
////
////            self.scrollEnabled = NO;
////
////            //self.contentOffset = CGPointZero;
////    //        if (self.scrollEnabled == YES){
////    //            self.scrollEnabled = NO;
////    //        }
////            NSLog(@"gestureRecognizer should pan");
////            return NO;
////
////
////           // scrollView.userInteractionEnabled = NO;
////           // scrollView.panGestureRecognizer.enabled = NO;
////        }
////        else {
////    //        if (self.scrollEnabled == NO){
////                self.scrollEnabled = YES;
////    //        }
////            NSLog(@"gestureRecognizer should NOT pan");
////            return NO;
////
////
////        }
////
////    }
//    if (self.contentOffset.y == 0) {
//        return YES;
//    }
//    else {
//        return NO;
//    }
//
//}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if (_panRecognizer == gestureRecognizer) {
//        if ([otherGestureRecognizer.view isKindOfClass:UIScrollView.class]) {
//            UIScrollView *scrollView = (UIScrollView *)otherGestureRecognizer.view;
//            if (scrollView.contentOffset.x == 0) {
//                return YES;
//            }
//        }
//    }
//
//    return NO;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    //NSLog(@"gestureRecognizer ");
//    if (self.contentOffset.y <= 0 && self.panGestureRecognizer.enabled == YES) {
//        self.panGestureRecognizer.enabled = NO;
//       // NSLog(@"gestureRecognizer disabled");
//    }
//  //  [customBottomSheet panFromScrollView:YES];
//
////    if (self.contentOffset.y <= 0) {
////
////        NSLog(@"panRecognizer offset.y <= 0");
////        return YES;
////
////    }
////    else {
////        NSLog(@"panRecognizer offset.y > 0");
////
////        return NO;
////    }
//    return YES;
//
////    NSLog(@"gestureRecognizer %@",gestureRecognizer.state);
//   // NSLog(@"otherGestureRecognizer %@",otherGestureRecognizer.state);
//
//    
////    if (self.dismissing == YES){
////        NSLog(@"gestureRecognizer YES");
////        return YES;
////    }
////    else {
////        NSLog(@"gestureRecognizer NO");
////
////        return NO;
////    }
////    return YES;
//}

@end


