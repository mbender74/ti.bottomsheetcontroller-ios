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

API_AVAILABLE(ios(15), macosx(12))

TiBottomsheetcontrollerProxy *currentTiBottomSheet;

@implementation TiBottomsheetcontrollerProxy


#pragma mark Setup

- (id)init
{
  if (self = [super init]) {
    bottomSheetclosingCondition = [[NSCondition alloc] init];
    poWidth = TiDimensionUndefined;
    poHeight = TiDimensionUndefined;
  }
 
  return self;
}

- (void)dealloc
{
    [super dealloc];
   
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
    RELEASE_TO_NIL(bottomSheet);
}

#pragma mark Public API
- (NSString *)apiName
{
    return @"Ti.UI.BottomSheetController";
}

#pragma mark Public Constants

- (NSString *)selectedDetentIdentifier
{
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



- (void)setContentView:(id)value
{
  if (popoverInitialized) {
    DebugLog(@"[ERROR] Changing contentView when the popover is showing is not supported");
    return;
  }
  ENSURE_SINGLE_ARG(value, TiViewProxy);

  if (contentViewProxy != nil) {
      RELEASE_TO_NIL(contentViewProxy);
  }
  contentViewProxy = [(TiViewProxy *)value retain];
  [self replaceValue:contentViewProxy forKey:@"contentView" notification:NO];
}

#pragma mark Public Methods

- (void)show:(id)args
{

  if (contentViewProxy == nil) {
    DebugLog(@"[ERROR] Popover presentation without contentView property set is no longer supported. Ignoring call") return;
  }

  ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
  [self rememberSelf];
    [self retain];
    
  animated = [TiUtils boolValue:@"animated" properties:args def:YES];

  popoverInitialized = YES;

  TiThreadPerformOnMainThread(
      ^{
        [self initAndShowSheetController];
      },
      YES);
}

- (void)hide:(id)args
{
  if (!popoverInitialized) {
    DebugLog(@"Popover is not showing. Ignoring call") return;
  }

  ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);

  TiThreadPerformOnMainThread(
      ^{
          [self->contentViewProxy windowWillClose];
         

          self->animated = [TiUtils boolValue:@"animated" properties:args def:NO];
          [[self viewController] dismissViewControllerAnimated:self->animated
                                                  completion:^{
              
                                                 
                                                 
              [self fireEvent:@"closed" withObject:nil];
                                                    //[self cleanup];
                                                  }];
      },
      NO);
}





#pragma mark Internal Methods
- (UIViewController *)viewController
{
  if (viewController == nil) {
    if ([contentViewProxy isKindOfClass:[TiWindowProxy class]]) {
      [(TiWindowProxy *)contentViewProxy setIsManaged:YES];
        viewController = [[(TiWindowProxy *)contentViewProxy hostingController] retain];
      [viewController.view addObserver:self forKeyPath:@"safeAreaInsets" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    } else {
      viewController = [[TiViewController alloc] initWithViewProxy:contentViewProxy];
      [viewController.view addObserver:self forKeyPath:@"safeAreaInsets" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
  }
  viewController.view.clipsToBounds = YES;
  return viewController;
}

- (void)cleanup
{
  currentTiBottomSheet = nil;
    NSLog(@"cleanup 1 ");
    
    NSLog(@"cleanup 2 ");

    
  [contentViewProxy setProxyObserver:nil];
  [contentViewProxy windowWillClose];

  popoverInitialized = NO;
 // [self fireEvent:@"hide" withObject:nil]; //Checking for listeners are done by fireEvent anyways.
//  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
  [contentViewProxy windowDidClose];
    NSLog(@"cleanup 3 ");

  if ([contentViewProxy isKindOfClass:[TiWindowProxy class]]) {
    UIView *topWindowView = [[[TiApp app] controller] topWindowProxyView];
    if ([topWindowView isKindOfClass:[TiUIView class]]) {
      TiViewProxy *theProxy = (TiViewProxy *)[(TiUIView *)topWindowView proxy];
      if ([theProxy conformsToProtocol:@protocol(TiWindowProtocol)]) {
        [(id<TiWindowProtocol>)theProxy gainFocus];
      }
    }
  }
    NSLog(@"cleanup 4 ");

  [self forgetSelf];
  [viewController.view removeObserver:self forKeyPath:@"safeAreaInsets"];
  RELEASE_TO_NIL(viewController);
    NSLog(@"cleanup 5 ");

  [self performSelector:@selector(release) withObject:nil afterDelay:0.5];
  [bottomSheetclosingCondition lock];
  isDismissing = NO;
  [bottomSheetclosingCondition signal];
  [bottomSheetclosingCondition unlock];

    NSLog(@"cleanup 6 ");

    popoverInitialized = NO;
    currentTiBottomSheet = nil;
    NSLog(@"cleanup 7 ");

    RELEASE_TO_NIL(bottomSheetclosingCondition);
    RELEASE_TO_NIL(contentViewProxy);
   // bottomSheet.delegate = nil;
    //RELEASE_TO_NIL(bottomSheet);
    NSLog(@"cleanup 8 ");

}

- (void)initAndShowSheetController
{
   // NSLog(@"initAndShowSheetController ");

  deviceRotated = NO;
  currentTiBottomSheet = self;
  [contentViewProxy setProxyObserver:self];
  if ([contentViewProxy isKindOfClass:[TiWindowProxy class]]) {
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updatePopoverNow];
        [contentViewProxy windowDidOpen];
    });
  } else {
    [contentViewProxy windowWillOpen];
    [contentViewProxy reposition];
    //[self updateContentSize];
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
  [[self viewController] setPreferredContentSize:newSize];
  [contentViewProxy reposition];
}

- (void)updatePopoverNow
{
   // NSLog(@"updatePopoverNow ");

  UIViewController *theController = [self viewController];
    

//        [theController setModalPresentationStyle:UIModalPresentationPageSheet];

   
        bottomSheet = [theController sheetPresentationController];
        
        bottomSheet.delegate = self;


        if ([self valueForKey:@"largestUndimmedDetentIdentifier"]){
            if ([[TiUtils stringValue:[self valueForKey:@"largestUndimmedDetentIdentifier"]] isEqual: @"large"]){
                _largestUndimmedDetentIdentifier = UISheetPresentationControllerDetentIdentifierLarge;
            }
            else {
                _largestUndimmedDetentIdentifier = UISheetPresentationControllerDetentIdentifierMedium;
            }
            bottomSheet.largestUndimmedDetentIdentifier = _largestUndimmedDetentIdentifier;
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

            //[TiUtils boolValue:[self valueForKey:@"prefersEdgeAttachedInCompactHeight"]
            
            if ([TiUtils boolValue:[userDetents valueForKey:@"medium"] def:NO]) {
                [detentsOfController addObject:[UISheetPresentationControllerDetent mediumDetent]];
            }
            if ([TiUtils boolValue:[userDetents valueForKey:@"large"] def:NO]) {
                [detentsOfController addObject:[UISheetPresentationControllerDetent largeDetent]];
            }

            bottomSheet.detents = detentsOfController;
        }
    
        bottomSheet.prefersGrabberVisible = [TiUtils boolValue:[self valueForKey:@"prefersGrabberVisible"] def:YES];
    

    if ([self valueForKey:@"backgroundColor"]){
        [theController.view setBackgroundColor:[[TiColor colorNamed:[self valueForKey:@"backgroundColor"]] _color]];

    }
    
    
    if ([self valueForKey:@"modalPresentation"]){
        if ([[TiUtils stringValue:[self valueForKey:@"modalPresentation"]] isEqual: @"overFullScreen"]){
            [theController setModalPresentationStyle:UIModalPresentationOverFullScreen];
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
            [theController setModalPresentationStyle:UIModalPresentationAutomatic];
        }
    }
    else {
        [theController setModalPresentationStyle:UIModalPresentationAutomatic];
    }
        
    [[[[TiApp app] controller] topPresentedController] presentViewController:theController animated:animated completion:^{
        [self fireEvent:@"opened" withObject:nil];
    }];


    
}


- (void)updateContentViewWithSafeAreaInsets:(NSValue *)insetsValue
{
  TiThreadPerformOnMainThread(
      ^{
        UIViewController *viewController = [self viewController];
          self->contentViewProxy.view.frame = viewController.view.frame;
        UIEdgeInsets edgeInsets = [insetsValue UIEdgeInsetsValue];
        viewController.view.frame = CGRectMake(viewController.view.frame.origin.x + edgeInsets.left, viewController.view.frame.origin.y + edgeInsets.top, viewController.view.frame.size.width - edgeInsets.left - edgeInsets.right, viewController.view.frame.size.height - edgeInsets.top - edgeInsets.bottom);
      },
      NO);
}


#pragma mark Delegate methods

- (void)proxyDidRelayout:(id)sender
{
  if (sender == contentViewProxy) {
    if (viewController != nil) {
      CGSize newSize = [self contentSize];
      if (TiBottomSheetContentSize.width != newSize.width || TiBottomSheetContentSize.height != newSize.height){
        if (!CGSizeEqualToSize([viewController preferredContentSize], newSize)) {
          //  NSLog(@"proxyDidRelayout ");
         // [self updateContentSize];
        }
      }
    }
  }
}


- (void)sheetPresentationControllerDidChangeSelectedDetentIdentifier :(UISheetPresentationController *)bottomSheetPresentationController
{
    
    NSLog(@"\n\n sheetPresentationControllerDidChangeSelectedDetentIdentifier ");

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
  if ([[self viewController] presentedViewController] != nil) {
    return NO;
  }
  [self fireEvent:@"dismissing" withObject:nil];

  [contentViewProxy windowWillClose];
  return YES;
}

- (void)presentationControllerDidDismiss:(UISheetPresentationController *)bottomSheetPresentationController
{
 //   NSLog(@"presentationControllerDidDismiss ");
   currentTiBottomSheet = nil;

  [self fireEvent:@"closed" withObject:nil];

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
     // [self updateContentViewWithSafeAreaInsets:insetsValue];
    } else if (deviceRotated) {
      // [self viewController]  need a bit of time to set its frame while rotating
      deviceRotated = NO;
     // [self performSelector:@selector(updateContentViewWithSafeAreaInsets:) withObject:insetsValue afterDelay:.05];
    }
  }
}

- (void)deviceRotated:(NSNotification *)sender
{
  deviceRotated = YES;
}

@end
