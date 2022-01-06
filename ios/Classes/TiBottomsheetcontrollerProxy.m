/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2021 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 *
 *
 */
#define USE_TI_UINAVIGATIONWINDOW

#import "TiBottomsheetcontrollerProxy.h"
#import <TitaniumKit/TiApp.h>
#import <TitaniumKit/TiUtils.h>
#import <TitaniumKit/TiWindowProxy.h>
#import <libkern/OSAtomic.h>
#import "TiBottomsheetcontrollerModule.h"
#import <objc/runtime.h>

@implementation TiBottomsheetcontrollerProxy

#pragma mark Setup


//- (id)_initWithPageContext:(id<TiEvaluator>)context args:(id)args
//{
//    if (self = [super _initWithPageContext:context]) {
//        bottomSheetclosingCondition = [[NSCondition alloc] init];
//        poWidth = TiDimensionUndefined;
//        poHeight = TiDimensionUndefined;
//        poBWidth = TiDimensionUndefined;
//        poBHeight = TiDimensionUndefined;
//        nonSystemSheetShouldScroll = NO;
//        defaultsToNonSystemSheet = YES;
//        nonSystemSheetAutomaticStartPositionFromContentViewHeight = NO;
//        useNavController = NO;
//        bottomSheetInitialized = NO;
//        contentViewScrollingDisabled = NO;
//        UIViewController<TiControllerContainment> *topContainerController = [[[TiApp app] controller] topContainerController];
//        bottomSheetSafeAreaInset = [[topContainerController hostingView] safeAreaInsets];
//    }
//    
//    return self;
//}



- (id)init
{
    if (self = [super init]) {
       // bottomSheetclosingCondition = [[NSCondition alloc] init];
        poWidth = TiDimensionUndefined;
        poHeight = TiDimensionUndefined;
        poBWidth = TiDimensionUndefined;
        poBHeight = TiDimensionUndefined;
        customBottomSheet = nil;
        currentTiBottomSheet = nil;
        nonSystemSheetShouldScroll = NO;
        defaultsToNonSystemSheet = YES;
        nonSystemSheetAutomaticStartPositionFromContentViewHeight = NO;
        useNavController = NO;
        bottomSheetInitialized = NO;
        contentViewScrollingDisabled = NO;
        UIViewController<TiControllerContainment> *topContainerController = [[[TiApp app] controller] topContainerController];
        bottomSheetSafeAreaInset = [[topContainerController hostingView] safeAreaInsets];
    }

    return self;
}

- (void)dealloc
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [viewController.view removeObserver:self forKeyPath:@"safeAreaInsets"];
    RELEASE_TO_NIL(viewController);
    bottomSheetInitialized = NO;
    currentTiBottomSheet = nil;
    nonSystemSheetAutomaticStartPositionFromContentViewHeight = NO;
   // RELEASE_TO_NIL(bottomSheetclosingCondition);
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
        if (@available(iOS 15, macCatalyst 15, *)) {
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
    }
    else {
        return customBottomSheet.selectedDetentIdentifier;
    }
    
}

- (void)changeCurrentDetent:(id)value
{
    ENSURE_ARG_COUNT(value, 1);
    NSString *identifier = [TiUtils stringValue:[value objectAtIndex:0]];
    if (@available(iOS 15, macCatalyst 15, *)) {
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
- (BOOL)nonSystemSheetShouldScroll
{
    return nonSystemSheetShouldScroll;
}



- (void)setNonSystemSheetAutomaticStartPositionFromContentViewHeight:(id)value
{
    nonSystemSheetAutomaticStartPositionFromContentViewHeight = [TiUtils boolValue:value];
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
  self.viewProxy = contentViewProxy;
  [self replaceValue:contentViewProxy forKey:@"contentView" notification:NO];
}


- (void)sendEvent:(id)args
{
    detentStatus = [TiUtils stringValue:args];
    
    if ([detentStatus isEqual:@"dismiss"]){
        if (isDismissing == NO){
            isDismissing = YES;
            [self close:nil];
        }
    }
    else {
        if (lastDetentStatus != detentStatus){
            NSMutableDictionary * event = [NSMutableDictionary dictionary];
            customBottomSheet.selectedDetentIdentifier = detentStatus;
            [event setValue:detentStatus
                     forKey:@"selectedDetentIdentifier"];
         
            [self fireEvent:@"detentChange" withObject:event];
        }
        if (myScrollView != nil){
            self.dismissing = NO;
            [customBottomSheet panRecognizerEnabled:YES];
        }
    }
    lastDetentStatus = detentStatus;
}




#pragma mark Public Methods
- (void)addEventListener:(NSArray *)args
{
    NSString *type = [args objectAtIndex:0];

    if (![self _hasListeners:type]) {
        [super addEventListener:args];
    }
}

- (void)open:(id)args
{
  ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
  if (bottomSheetInitialized == NO) {
      eventFired = NO;
      bottomSheetInitialized = YES;

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
          },
        YES);
  }
  else {
      NSLog(@"[ERROR] BottomSheet is open. Ignoring call") return;
  }
}

- (void)close:(id)args
{
      if (bottomSheetInitialized == NO) {
          NSLog(@"BottomSheet is not open. Ignoring call") return;
      }

  TiThreadPerformOnMainThread(
      ^{

          if (defaultsToNonSystemSheet == NO){
              [self->contentViewProxy windowWillClose];

              self->animated = [TiUtils boolValue:@"animated" properties:args def:YES];

              [[self viewController] dismissViewControllerAnimated:self->animated
                completion:^{
                      if (eventFired == NO){
                          eventFired = YES;
                                                    
                        [self fireEvent:@"close" withObject:nil];
                        
                        [self cleanup];

//                          bottomSheetInitialized = NO;
//
//                          bottomSheet = nil;
//                          viewController = nil;
//                          contentViewProxy = nil;
//                          centerProxy = nil;
//                          closeButtonView = nil;
//                          currentTiBottomSheet = nil;
                      }
                }];
          }
          else {

              if (eventFired == NO){
                  eventFired = YES;
                  [self->contentViewProxy windowWillClose];

                  UIColor *viewBackgroundColor = [UIColor clearColor];
                                
                  [UIView animateWithDuration:0.25
                        delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                        animations:^{
                          if (backgroundView != nil){
                              backgroundView.backgroundColor = viewBackgroundColor;
                          }
                          CGFloat width = customBottomSheet.view.frame.size.width;
                          CGFloat height = customBottomSheet.view.frame.size.height;
                          CGRect rect = CGRectMake(0 , [UIScreen mainScreen].bounds.size.height, width, height);
                          customBottomSheet.view.frame = rect;
                        } completion:^(BOOL finished) {
                            
                            if (finished){
                                                        
                                    [self fireEvent:@"close" withObject:nil];
                                    
                                    if (useNavController) {
                                        [centerProxy windowWillClose];
                                        [centerProxy close:nil];
                                        [centerProxy windowDidClose];
                                    }
                                    if (backgroundView != nil){
                                        [backgroundView removeFromSuperview];
                                    }
                                
                                
                                    [customBottomSheet.view removeFromSuperview];
                                    [self cleanup];

                                  //  [viewController.view removeFromSuperview];
//                                    myScrollView = nil;
//                                    bottomSheetInitialized = NO;
//                                    contentViewProxy = nil;
//                                    customBottomSheet = nil;
//                                    backgroundView = nil;
//                                    viewController = nil;
//                                    closeButtonView = nil;
                            }
                  }];
              }
          }
      },
      YES);
}

- (UIView *)containerView
{
  return containerView;
}

- (CGFloat)realContentHeight
{
    return realContentHeight;
}
- (CGFloat)scrollableContentHeight
{
    return scrollableContentHeight;
}


- (BOOL)nonSystemSheetAutomaticStartPositionFromContentViewHeight
{
    return nonSystemSheetAutomaticStartPositionFromContentViewHeight;
}

- (UIView *)backgroundView
{
    if (backgroundView != nil){
        return backgroundView;
    }
    else {
        return nil;
    }
}

- (UIView *)contentViewOfSheet
{
  return contentViewOfSheet;
}




- (UIScrollView *)scrollView
{
  return myScrollView;
}


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
  viewController.view.clipsToBounds = NO;
  return viewController;
}

#pragma mark Internal Methods


- (void)cleanup
{
  [contentViewProxy setProxyObserver:nil];
  [contentViewProxy windowWillClose];
  [contentViewProxy windowDidClose];
  if ([contentViewProxy isKindOfClass:[TiWindowProxy class]]) {
    UIView *topWindowView = [[[TiApp app] controller] topWindowProxyView];
    if ([topWindowView isKindOfClass:[TiUIView class]]) {
      TiViewProxy *theProxy = (TiViewProxy *)[(TiUIView *)topWindowView proxy];
      if ([theProxy conformsToProtocol:@protocol(TiWindowProtocol)]) {
        [(id<TiWindowProtocol>)theProxy gainFocus];
      }
    }
  }
  [viewController.view removeObserver:self forKeyPath:@"safeAreaInsets"];
  //[[NSNotificationCenter defaultCenter] removeObserver:self];
 // [self performSelector:@selector(release) withObject:nil afterDelay:0.5];
 // [bottomSheetclosingCondition lock];
  nonSystemSheetAutomaticStartPositionFromContentViewHeight = NO;
 // [bottomSheetclosingCondition signal];
 // [bottomSheetclosingCondition unlock];
  isDismissing = NO;
  bottomSheetInitialized = NO;
  eventFired = NO;
  bottomSheet.delegate = nil;

  myScrollView = nil;
  backgroundView = nil;
  customBottomSheet = nil;
  viewController = nil;
  closeButtonView = nil;
  closeButtonProxy = nil;
  currentTiBottomSheet = nil;
 // bottomSheetclosingCondition = nil;
  contentViewProxy = nil;
  centerProxy = nil;
  if (@available(iOS 15, *)) {
    [_detents release];
    [_largestUndimmedDetentIdentifier release];
  }
  RELEASE_TO_NIL(myScrollView);
  RELEASE_TO_NIL(backgroundView);
  RELEASE_TO_NIL(customBottomSheet);
  RELEASE_TO_NIL(viewController);
  RELEASE_TO_NIL(closeButtonView);
  RELEASE_TO_NIL(closeButtonProxy);
  RELEASE_TO_NIL(currentTiBottomSheet);
  //RELEASE_TO_NIL(bottomSheetclosingCondition);
  RELEASE_TO_NIL(contentViewProxy);
  RELEASE_TO_NIL(centerProxy);
  [self forgetSelf];
  [self _destroy];
  [self autorelease];
  //[self release];
}

- (void)initAndShowSheetController
{
  self.fixedHeight = NO;
  self.insetsDone = NO;
  if (nonSystemSheetAutomaticStartPositionFromContentViewHeight == YES){
      nonSystemSheetShouldScroll = NO;
      self.fixedHeight = YES;
  }

  deviceRotated = NO;
  [contentViewProxy setProxyObserver:self];
    scrollableContentHeight = 0;

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
   [(TiWindowProxy *)contentViewProxy reposition];
   [(TiWindowProxy *)contentViewProxy layoutChildrenIfNeeded];
      
   if (closeButtonProxy){
      [closeButtonProxy windowWillOpen];
      [closeButtonProxy reposition];
      [closeButtonProxy layoutChildrenIfNeeded];

      CGFloat width = [closeButtonProxy autoWidthForSize:CGSizeMake(1000, 1000)];
      CGFloat height = [closeButtonProxy autoHeightForSize:CGSizeMake(width, 0)];
      CGRect closeButtonViewFrame = CGRectMake( 0 , 0, width, height);
      closeButtonView = [[UIView alloc] initWithFrame:closeButtonViewFrame];
   }
      
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[[contentViewProxy class] description] isEqualToString:@"TiUINavigationWindowProxy"]) {
            TiWindowProxy *childWindowProxy = [contentViewProxy valueForKey:@"window"];
            
            id childWindowProxyHeight = [childWindowProxy valueForUndefinedKey:@"height"];
            if (childWindowProxyHeight) {
                if ([childWindowProxyHeight isEqual:@"SIZE"]){
                    
                }
                else if ([childWindowProxyHeight isEqual:@"FILL"]){
                    
                }
                else {
                    self.fixedHeight = YES;
                }
            }

            
            
            realContentHeight = [(TiWindowProxy *)childWindowProxy view].frame.size.height;
            if (realContentHeight >= [UIScreen mainScreen].bounds.size.height){
                realContentHeight = realContentHeight - 200;
            }
        }
        else {
            id contentViewProxyHeight = [contentViewProxy valueForUndefinedKey:@"height"];
            if (contentViewProxyHeight) {
                if ([contentViewProxyHeight isEqual:@"SIZE"]){
                    
                }
                else if ([contentViewProxyHeight isEqual:@"FILL"]){
                    
                }
                else {
                    self.fixedHeight = YES;
                }
            }


            realContentHeight = [(TiWindowProxy *)contentViewProxy view].frame.size.height;
            if (realContentHeight >= [UIScreen mainScreen].bounds.size.height){
                realContentHeight = realContentHeight - 200;
            }
        }
               
        [self updatePopoverNow];
        [contentViewProxy windowDidOpen];
    });
  } else {
      self.fixedHeight = NO;


      CGSize reCalculatedSize;
      reCalculatedSize.height = 0;
      [contentViewProxy windowWillOpen];
      [contentViewProxy reposition];
      
      id contentViewProxyHeight = [contentViewProxy valueForUndefinedKey:@"height"];
      if (contentViewProxyHeight) {
          if ([contentViewProxyHeight isEqual:@"SIZE"]){
              
          }
          else if ([contentViewProxyHeight isEqual:@"FILL"]){
              
          }
          else {
              self.fixedHeight = YES;
          }
      }

      /*
    if (nonSystemSheetShouldScroll == YES && defaultsToNonSystemSheet == YES){
        if ([contentViewProxy.view isKindOfClass:[TiUITableView class]] || [contentViewProxy.view isKindOfClass:[TiUIScrollViewImpl class]]) {

            
            UITableView *sv = nil;
           
            if ([contentViewProxy.view isKindOfClass:[TiUITableView class]]){

                object_setClass(sv, [UITableView class]);
                sv = (UITableView *)[(TiUITableView*)contentViewProxy.view tableView];
                if ([sv isScrollEnabled] == NO){
                    reCalculatedSize = sv.contentSize;
                    CGRect newFrame = contentViewProxy.view.frame;
                    newFrame.size.height = reCalculatedSize.height;
                    contentViewProxy.view.frame = newFrame;
                    [contentViewProxy replaceValue:@"Ti.UI.SIZE" forKey:@"height" notification:YES];
                }
                else {
                    nonSystemSheetShouldScroll = NO;
                }
            }
            else {
                object_setClass(sv, [TiUIScrollViewImpl class]);
                sv = [(TiUIScrollView*)contentViewProxy.view scrollView];
                if ([sv isScrollEnabled] == NO){
                    reCalculatedSize = sv.contentSize;
                    [contentViewProxy replaceValue:@"Ti.UI.SIZE" forKey:@"height" notification:YES];
                    [contentViewProxy replaceValue:@"false" forKey:@"scrollingEnabled" notification:YES];
                }
                else {
                    nonSystemSheetShouldScroll = NO;
                }
            }

        }
        else {

            for (TiViewProxy * proxy in [contentViewProxy children]) {
                
                UITableView *sv = nil;

                [proxy windowWillOpen];
                [proxy reposition];

                if ([proxy.view isKindOfClass:[TiUITableView class]] || [proxy.view isKindOfClass:[TiUIScrollViewImpl class]]) {

                    if ([proxy.view isKindOfClass:[TiUITableView class]]){

                        object_setClass(sv, [UITableView class]);
                        sv = (UITableView *)[(TiUITableView*)proxy.view tableView];
                        
                        [proxy replaceValue:@"false" forKey:@"scrollable" notification:YES];
                        reCalculatedSize = sv.contentSize;
                        CGRect newFrame = proxy.view.frame;
                        newFrame.size.height = reCalculatedSize.height;
                        proxy.view.frame = newFrame;
                        [proxy replaceValue:[NSNumber numberWithInt:reCalculatedSize.height] forKey:@"height" notification:YES];
                    }
                    else {
                        object_setClass(sv, [TiUIScrollViewImpl class]);
                        sv = [(TiUIScrollView*)proxy.view scrollView];
                        reCalculatedSize = sv.contentSize;
                        [proxy replaceValue:@"false" forKey:@"scrollingEnabled" notification:YES];
                        CGRect newFrame = proxy.view.frame;
                        newFrame.size.height = reCalculatedSize.height;
                        proxy.view.frame = newFrame;
                        [proxy replaceValue:[NSNumber numberWithInt:reCalculatedSize.height] forKey:@"height" notification:YES];
                    }
                }
            }
        }
        scrollableContentHeight = reCalculatedSize.height;
    }
    else {
        scrollableContentHeight = 0;
    }
       */
      scrollableContentHeight = 0;

    if (closeButtonProxy){
      [closeButtonProxy windowWillOpen];
      [closeButtonProxy reposition];
      [closeButtonProxy layoutChildrenIfNeeded];
      CGFloat width = [closeButtonProxy autoWidthForSize:CGSizeMake(1000, 1000)];
      CGFloat height = [closeButtonProxy autoHeightForSize:CGSizeMake(width, 0)];
      CGRect closeButtonViewFrame = CGRectMake( 0 , 0, width, height);
      closeButtonView = [[UIView alloc] initWithFrame:closeButtonViewFrame];
    }

      realContentHeight = [self updateContentSizeWithReturn].height;
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              if (realContentHeight >= [UIScreen mainScreen].bounds.size.height){
                  realContentHeight = realContentHeight - 200;
              }
              
              if (scrollableContentHeight == 0){
                  scrollableContentHeight = realContentHeight;
              }
            [self updatePopoverNow];
            [contentViewProxy windowDidOpen];
      });
  }
}

- (CGSize)contentSize:(TiViewProxy *)thisProxy
{
#ifndef TI_USE_AUTOLAYOUT
  CGSize screenSize = [[UIScreen mainScreen] bounds].size;
  if (poWidth.type != TiDimensionTypeUndefined) {
    [thisProxy layoutProperties]->width.type = poWidth.type;
    [thisProxy layoutProperties]->width.value = poWidth.value;
    poWidth = TiDimensionUndefined;
  }

  if (poHeight.type != TiDimensionTypeUndefined) {
    [thisProxy layoutProperties]->height.type = poHeight.type;
    [thisProxy layoutProperties]->height.value = poHeight.value;
    poHeight = TiDimensionUndefined;
  }

 TiBottomSheetContentSize = SizeConstraintViewWithSizeAddingResizing([thisProxy layoutProperties], thisProxy, screenSize, NULL);

  return TiBottomSheetContentSize;
#else
  return CGSizeZero;
#endif
}

- (void)updateContentSize
{
   // TiThreadPerformOnMainThread(
   //     ^{
            CGSize newSize = [self contentSize:contentViewProxy];

            if (defaultsToNonSystemSheet == NO){
                 [[self viewController] setPreferredContentSize:newSize];
            }
            [contentViewProxy reposition];
      //  },
      //  NO);
}



- (CGSize)updateContentSizeWithReturn
{
    CGSize newSize = [self contentSize:contentViewProxy];

    if (defaultsToNonSystemSheet == NO){
         [[self viewController] setPreferredContentSize:newSize];
    }
    [contentViewProxy reposition];
    return newSize;
}

- (void)updatePopoverNow
{
    if (![self valueForKey:@"backgroundColor"] || [[self valueForKey:@"backgroundColor"] isEqual:@"transparent"]){
           [self replaceValue:[TiUtils hexColorValue:[UIColor lightGrayColor]] forKey:@"backgroundColor" notification:YES];
    }
    currentTiBottomSheet = self;

    if (defaultsToNonSystemSheet == NO){

                UIViewController *theController = [self viewController];
                if (@available(iOS 15.0, macCatalyst 15.0, *)) {
                    bottomSheet = [theController sheetPresentationController];
                }
                bottomSheet.delegate = self;
       
                if ([self valueForKey:@"largestUndimmedDetentIdentifier"]){
                    if ([[TiUtils stringValue:[self valueForKey:@"largestUndimmedDetentIdentifier"]] isEqual: @"large"]){
                        if (@available(iOS 15.0, macCatalyst 15.0, *)) {
                            _largestUndimmedDetentIdentifier = UISheetPresentationControllerDetentIdentifierLarge;
                        }
                        bottomSheet.largestUndimmedDetentIdentifier = _largestUndimmedDetentIdentifier;
                    }
                    else if ([[TiUtils stringValue:[self valueForKey:@"largestUndimmedDetentIdentifier"]] isEqual: @"medium"]){
                        if (@available(iOS 15.0, macCatalyst 15.0, *)) {
                            _largestUndimmedDetentIdentifier = UISheetPresentationControllerDetentIdentifierMedium;
                        }
                        bottomSheet.largestUndimmedDetentIdentifier = _largestUndimmedDetentIdentifier;

                    }
                    else {
                    }
                }
                
                if ([self valueForKey:@"preferredCornerRadius"]){
                    bottomSheet.preferredCornerRadius = [TiUtils floatValue:[self valueForKey:@"preferredCornerRadius"]];
                }
        
                bottomSheet.prefersScrollingExpandsWhenScrolledToEdge = [TiUtils boolValue:[self valueForKey:@"prefersScrollingExpandsWhenScrolledToEdge"] def:NO];
                   
                bottomSheet.prefersEdgeAttachedInCompactHeight = [TiUtils boolValue:[self valueForKey:@"prefersEdgeAttachedInCompactHeight"] def:NO];
                
                bottomSheet.widthFollowsPreferredContentSizeWhenEdgeAttached = [TiUtils boolValue:[self valueForKey:@"widthFollowsPreferredContentSizeWhenEdgeAttached"] def:NO];
            
        
              if ([self valueForKey:@"detents"]){
                  userDetents = [self valueForKey:@"detents"];

                  NSMutableArray *detentsOfController = [NSMutableArray arrayWithCapacity:2];

                  if ([TiUtils boolValue:[self valueForKey:@"nonModal"] def:NO]) {
                      if ([TiUtils boolValue:[userDetents valueForKey:@"large"] def:NO]) {
                                                    
                          if (@available(iOS 15.0, macCatalyst 15.0, *)) {
                              [detentsOfController addObject:[UISheetPresentationControllerDetent largeDetent]];
                          }
                      }
                      if ([TiUtils boolValue:[userDetents valueForKey:@"medium"] def:NO]) {
                          if (@available(iOS 15.0, macCatalyst 15.0, *)) {
                              [detentsOfController addObject:[UISheetPresentationControllerDetent mediumDetent]];
                          }
                      }
                  }
                  else {
                      if ([TiUtils boolValue:[userDetents valueForKey:@"medium"] def:NO]) {
                          if (@available(iOS 15.0, macCatalyst 15.0, *)) {
                              [detentsOfController addObject:[UISheetPresentationControllerDetent mediumDetent]];
                          }
                      }
                      if ([TiUtils boolValue:[userDetents valueForKey:@"large"] def:NO]) {
                          if (@available(iOS 15.0, macCatalyst 15.0, *)) {
                              [detentsOfController addObject:[UISheetPresentationControllerDetent largeDetent]];
                        }
                      }
                  }
                  
                 
                  bottomSheet.detents = detentsOfController;

                  if ([TiUtils stringValue:[self valueForKey:@"startDetent"]]){
                      if ([[TiUtils stringValue:[self valueForKey:@"startDetent"]] isEqual: @"large"] && ([TiUtils boolValue:[userDetents valueForKey:@"large"] def:NO])){
                          if (@available(iOS 15.0, macCatalyst 15.0, *)) {
                              bottomSheet.selectedDetentIdentifier = UISheetPresentationControllerDetentIdentifierLarge;
                          }
                      }
                      else if ([[TiUtils stringValue:[self valueForKey:@"startDetent"]] isEqual: @"medium"] && ([TiUtils boolValue:[userDetents valueForKey:@"medium"] def:NO])){
                          if (@available(iOS 15.0, macCatalyst 15.0, *)) {
                              bottomSheet.selectedDetentIdentifier = UISheetPresentationControllerDetentIdentifierMedium;
                          }
                      }
                      else {
                          
                      }
                  }
              }
          
            
            bottomSheet.prefersGrabberVisible = [TiUtils boolValue:[self valueForKey:@"prefersGrabberVisible"] def:YES];
            
            CGRect handleViewContainerFrame = CGRectMake( 0, 0, contentViewProxy.view.frame.size.width , 20);
            UIView *handleContainer = [[UIView alloc] initWithFrame:handleViewContainerFrame];
            [contentViewProxy.view addSubview:handleContainer];
            [handleContainer release];

           [theController.view setBackgroundColor:[[TiUtils colorValue:[self valueForKey:@"backgroundColor"]] _color]];

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
                
       
        if (closeButtonView != nil){
            closeButtonProxy.view.frame = closeButtonView.bounds;
            [closeButtonView addSubview:closeButtonProxy.view];
            [closeButtonProxy reposition];

            CGSize size = theController.view.frame.size;
            [closeButtonView setCenter:CGPointMake((size.width - (closeButtonView.bounds.size.width/2)), 24)];

            [theController.view addSubview:closeButtonView];
            [theController.view bringSubviewToFront:closeButtonView];
       }

                
        [[[[TiApp app] controller] topPresentedController] presentViewController:theController animated:animated completion:^{
            [self fireEvent:@"open" withObject:nil];
        }];
    }
    
    else {
        customBottomSheet = [BottomSheetViewController new];
        [customBottomSheet setProxyOfBottomSheetController:self];
        
        const CGFloat y = [[[TiApp app] controller] topPresentedController].view.frame.origin.y;
        const CGFloat height = [[[TiApp app] controller] topPresentedController].view.frame.size.height;
        const CGFloat width = [[[TiApp app] controller] topPresentedController].view.frame.size.width;

        
        if ([TiUtils boolValue:[self valueForUndefinedKey:@"nonSystemSheetDisableDimmedBackground"] def:NO] == NO){
            backgroundView = [[UIView alloc] init];
            backgroundView.frame = CGRectMake( 0, 0, width, height);
            
            if ([TiUtils boolValue:[self valueForUndefinedKey:@"nonSystemSheetDisableDimmedBackgroundTouchDismiss"] def:NO] == NO){
                UITapGestureRecognizer *singleFingerTap =
                  [[UITapGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(handleSingleTap:)];
                [backgroundView addGestureRecognizer:singleFingerTap];
            }
        }

        customBottomSheet.view.frame = CGRectMake( 0, y + height, width, height);

        containerView = [[UIView alloc] init];
                
        if ([TiUtils boolValue:[self valueForUndefinedKey:@"nonSystemSheetTopShadow"] def:NO]){
            customBottomSheet.view.layer.shadowOffset = CGSizeMake(0,-2);
            customBottomSheet.view.layer.shadowRadius = 6;
            customBottomSheet.view.layer.shadowOpacity = .6f;
            customBottomSheet.view.layer.shadowColor = [UIColor blackColor].CGColor;
        }
        containerView.clipsToBounds = YES;
        [customBottomSheet.view addSubview:containerView];
        
        useNavController = NO;

        if ([[[contentViewProxy class] description] isEqualToString:@"TiUINavigationWindowProxy"]) {
          useNavController = YES;
        }
        
        if (useNavController) {
            centerProxy = [self valueForUndefinedKey:@"contentView"];
            contentViewOfSheet = [[centerProxy controller] view];
        }
        else {
            contentViewOfSheet = [contentViewProxy view];
        }
        
        CGFloat heightOfContainer;
        CGFloat widthOfContainer = customBottomSheet.view.frame.size.width;
        if (nonSystemSheetAutomaticStartPositionFromContentViewHeight == YES){
            nonSystemSheetShouldScroll = NO;
            //heightOfContainer = realContentHeight + bottomSheetSafeAreaInset.bottom;
            heightOfContainer = realContentHeight;
        }
        else {
            heightOfContainer = customBottomSheet.view.frame.size.height;
        }
        containerView.frame = CGRectMake( 0, 0, widthOfContainer, heightOfContainer);
        
        CGRect controllerViewFrame = CGRectMake( 0, 0, widthOfContainer, heightOfContainer);
        if (nonSystemSheetShouldScroll == YES){
            
            if (useNavController == YES){
                scrollableContentHeight = realContentHeight;
               // controllerViewFrame.size.height = scrollableContentHeight;
                
                if (self.fixedHeight == YES){
                    controllerViewFrame.size.height = realContentHeight;
                }
                               
            }
            else {
                if (scrollableContentHeight > 0){
                    controllerViewFrame.size.height = scrollableContentHeight;
                }
                else {
                    scrollableContentHeight = realContentHeight;
                }
            }
            [contentViewOfSheet setFrame:controllerViewFrame];

            const CGFloat heightOfScrollContainer = containerView.frame.size.height;
            const CGFloat widthOfScrollContainer = containerView.frame.size.width;
            
            myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, widthOfScrollContainer, heightOfScrollContainer)];
            [customBottomSheet scrollView:myScrollView];

            self.dismissing = NO;
            myScrollView.delegate = self;
            myScrollView.delaysContentTouches = NO;
            myScrollView.scrollEnabled = YES;
            // scrollView.pagingEnabled = YES;
            myScrollView.alwaysBounceVertical = NO;
            myScrollView.showsVerticalScrollIndicator = YES;
            myScrollView.showsHorizontalScrollIndicator = NO;
            myScrollView.canCancelContentTouches = YES;
            myScrollView.contentInset = UIEdgeInsetsMake(0, 0, bottomSheetSafeAreaInset.bottom, 0);
            [myScrollView setScrollIndicatorInsets:UIEdgeInsetsMake(20, 0, bottomSheetSafeAreaInset.bottom, 0)];
            //scrollView.insetsLayoutMarginsFromSafeArea = YES;
            [containerView addSubview:myScrollView];
            [myScrollView addSubview:contentViewOfSheet];
            myScrollView.contentSize = CGSizeMake(contentViewOfSheet.frame.size.width, scrollableContentHeight);
            CGPoint contentOffet = myScrollView.contentOffset;
            contentOffet.y = 0;
            myScrollView.contentOffset = contentOffet;
            [customBottomSheet panRecognizerEnabled:YES];
        }
        else {
            if (self.fixedHeight == NO){
                if (nonSystemSheetAutomaticStartPositionFromContentViewHeight == YES){
                  //  controllerViewFrame.size.height = controllerViewFrame.size.height + bottomSheetSafeAreaInset.bottom;
                }
                else {
                  //  controllerViewFrame.size.height = controllerViewFrame.size.height - bottomSheetSafeAreaInset.bottom;
                }
                controllerViewFrame.size.height = realContentHeight;

            }
            else {
                if (nonSystemSheetAutomaticStartPositionFromContentViewHeight == YES){
                    controllerViewFrame.size.height = realContentHeight;
                   // controllerViewFrame.size.height = realContentHeight + bottomSheetSafeAreaInset.bottom;

                }
                else  {
                    controllerViewFrame.size.height = realContentHeight;
                }
            }
            
            [contentViewOfSheet setFrame:controllerViewFrame];
            [containerView addSubview:contentViewOfSheet];
            [self scrollingInsets:contentViewOfSheet];
        }
        
        if ([self valueForKey:@"preferredCornerRadius"]){
            containerView.layer.cornerRadius = [TiUtils floatValue:[self valueForKey:@"preferredCornerRadius"]];
        }
        else {
            containerView.layer.cornerRadius = 10;
        }
        
        containerView.backgroundColor =  [[TiUtils colorValue:[self valueForKey:@"backgroundColor"]] _color];
        
        CGRect handleViewContainerFrame = CGRectMake( 0, 0, containerView.frame.size.width , 20);
        UIView *handleContainer = [[UIView alloc] initWithFrame:handleViewContainerFrame];
        if (nonSystemSheetShouldScroll == YES){
            [containerView insertSubview:handleContainer aboveSubview:myScrollView];
        }
        else {
            [containerView insertSubview:handleContainer aboveSubview:contentViewOfSheet];
        }
       
        if ([TiUtils boolValue:[self valueForKey:@"prefersGrabberVisible"] def:YES]){
                        
            CGRect handleContainerViewFrame = CGRectMake( 0, 0, 60, 20);
            UIView *handleViewContainer = [[UIView alloc] initWithFrame:handleContainerViewFrame];
            [handleContainer addSubview:handleViewContainer];
            [handleViewContainer setCenter:CGPointMake(containerView.frame.size.width/2, 10)];
            
            
            CGRect handleViewFrame = CGRectMake( 0, 0, 36, 5);
            handle = [[UIView alloc] initWithFrame:handleViewFrame];
            
            if ([self valueForUndefinedKey:@"nonSystemSheetHandleColor"]){
                handle.backgroundColor = [[TiUtils colorValue:[self valueForKey:@"nonSystemSheetHandleColor"]] _color];
            }
            else {
                handle.backgroundColor = [self adaptiveGrabberColor];
            }
            handle.layer.cornerRadius = 4;
            [handle setCenter:CGPointMake(handleViewContainer.frame.size.width/2, 10)];
           
            [handleViewContainer addSubview:handle];
            [handle setUserInteractionEnabled:NO];
            UITapGestureRecognizer *singlHandleTap =
              [[UITapGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleSingleHandleTap:)];
            [handleViewContainer addGestureRecognizer:singlHandleTap];
            [handleViewContainer release];
            [handleContainer release];

        }

        
        if (closeButtonView != nil){
            closeButtonProxy.view.frame = closeButtonView.bounds;
            [closeButtonView addSubview:closeButtonProxy.view];
            [closeButtonProxy reposition];
            [closeButtonView setCenter:CGPointMake((containerView.frame.size.width - (closeButtonView.bounds.size.width/2)), 24)];
            [containerView insertSubview:closeButtonView aboveSubview:handleContainer];
       }
        if (backgroundView != nil){
            [[[[TiApp app] controller] topPresentedController].view addSubview:backgroundView];
            [[[[TiApp app] controller] topPresentedController].view insertSubview:customBottomSheet.view aboveSubview:backgroundView];
        }
        else {
            [[[[TiApp app] controller] topPresentedController].view addSubview:customBottomSheet.view];
        }
    }
    
}

- (UIColor *)adaptiveGrabberColor
{
  // #5a5a5f
  if (TiApp.controller.traitCollection.userInterfaceStyle == UIDocumentBrowserUserInterfaceStyleDark) {
    return [UIColor colorWithRed:0.35 green:0.35 blue:0.37 alpha:1.0];
  }

  // #c5c5c7
  return [UIColor colorWithRed:0.77 green:0.77 blue:0.78 alpha:1.0];
}

- (void)scrollingInsets:(UIView *)view
{
    if ([view respondsToSelector:@selector(setScrollEnabled:)] && self.insetsDone == NO){

            CGFloat bottomInset = 0;
            if (self.fixedHeight == NO){
                bottomInset = bottomSheetSafeAreaInset.bottom;
            }
            
            if ([view isKindOfClass:[UITableView class]]){
                
                if (nonSystemSheetAutomaticStartPositionFromContentViewHeight == YES){
                    bottomInset = bottomSheetSafeAreaInset.bottom;

                  //  CGRect newFrame = [(UITableView *)view frame];
                  //  newFrame.size.height = newFrame.size.height + bottomSheetSafeAreaInset.bottom;
                  //  [(UITableView *)view setFrame:newFrame];
                }
                
                [(UITableView *)view setScrollIndicatorInsets:UIEdgeInsetsMake(20, 0, bottomInset, 0)];
                [(UITableView *)view setAlwaysBounceVertical:NO];

                [(UITableView *)view setContentInset:UIEdgeInsetsMake(0, 0, bottomInset, 0)];
                self.insetsDone = YES;
            }
            else if ([view isKindOfClass:[UIScrollView class]]){
                if (nonSystemSheetAutomaticStartPositionFromContentViewHeight == YES){
                    bottomInset = bottomSheetSafeAreaInset.bottom;

                   // CGRect newFrame = [(UIScrollView *)view frame];
                  //  newFrame.size.height = newFrame.size.height + bottomSheetSafeAreaInset.bottom;
                   // [(UIScrollView *)view setFrame:newFrame];
                }
                [(UIScrollView *)view setAlwaysBounceVertical:NO];

                [(UIScrollView *)view setScrollIndicatorInsets:UIEdgeInsetsMake(20, 0, bottomInset, 0)];
                [(UIScrollView *)view setContentInset:UIEdgeInsetsMake(0, 0, bottomInset, 0)];
                self.insetsDone = YES;
            }
            else {
              //  NSLog(@"UIView isScrollEnabled %d ",[view performSelector: @selector (isScrollEnabled)]);
            }
    }
    else {
            for (UIView *eachView in view.subviews) {
                [self scrollingInsets:eachView];
            }
    }
}


//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
  CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    if (isDismissing == NO){
        isDismissing = YES;
        [self close:nil];
    }
}


- (void)handleSingleHandleTap:(UITapGestureRecognizer *)recognizer
{
    NSDictionary *userDetents = [self valueForKey:@"detents"];

    [UIView animateWithDuration:0.15 animations:^{
        [handle setAlpha:0.3f];
    } completion:^(BOOL finished) {
            if (customBottomSheet.lastStatus == 0){
                if ([TiUtils boolValue:[userDetents valueForKey:@"medium"] def:YES]){
                    customBottomSheet.lastStatus = 1;

                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [customBottomSheet moveView:1 fromEvent:YES];
                    } completion:^(BOOL finished) {
                    }];
                    [self sendEvent:@"medium"];

                }
                else if ([TiUtils boolValue:[userDetents valueForKey:@"large"] def:YES]){
                    customBottomSheet.lastStatus = 2;

                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [customBottomSheet moveView:2 fromEvent:YES];
                    } completion:^(BOOL finished) {

                    }];
                    [self sendEvent:@"large"];

                }
                else {
                    
                    
                    
                }
            }

            else if (customBottomSheet.lastStatus == 1){
                if ([TiUtils boolValue:[userDetents valueForKey:@"large"] def:YES]){
                    customBottomSheet.lastStatus = 2;

                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [customBottomSheet moveView:2 fromEvent:YES];
                    } completion:^(BOOL finished) {
                    }];
                    [self sendEvent:@"large"];

                }
                else if ([TiUtils boolValue:[userDetents valueForKey:@"small"] def:YES]){
                    customBottomSheet.lastStatus = 0;

                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [customBottomSheet moveView:0 fromEvent:YES];
                    } completion:^(BOOL finished) {
                    }];
                    [self sendEvent:@"small"];

                }
                else {

                }
            }

            else if (customBottomSheet.lastStatus == 2){
                if ([TiUtils boolValue:[userDetents valueForKey:@"small"] def:YES]){
                    customBottomSheet.lastStatus = 0;

                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [customBottomSheet moveView:0 fromEvent:YES];
                    } completion:^(BOOL finished) {
                    }];
                    [self sendEvent:@"small"];

                }
                else if ([TiUtils boolValue:[userDetents valueForKey:@"medium"] def:YES]){
                    customBottomSheet.lastStatus = 1;

                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [customBottomSheet moveView:1 fromEvent:YES];
                    } completion:^(BOOL finished) {
                    }];
                    [self sendEvent:@"medium"];

                }
                else {
                    
                }
            }
            [UIView animateWithDuration:0.15 animations:^{
                [handle setAlpha:1.0f];
            } completion:nil];
    }];
}



- (void)handleGesture:(UITapGestureRecognizer *)recognizer
{
    if (self.dismissing == NO){
        [customBottomSheet panFromScrollView:YES];
    }
}


- (void)updateContentViewWithSafeAreaInsets:(NSValue *)insetsValue
{
  TiThreadPerformOnMainThread(
      ^{
          UIEdgeInsets edgeInsets = [insetsValue UIEdgeInsetsValue];

          if (defaultsToNonSystemSheet == YES){
              if (useNavController == YES && nonSystemSheetShouldScroll == NO){
                  [[self->contentViewProxy controller] view].frame = CGRectMake([[self->contentViewProxy controller] view].frame.origin.x + edgeInsets.left, [[self->contentViewProxy controller] view].frame.origin.y + (edgeInsets.top), [[self->contentViewProxy controller] view].frame.size.width - edgeInsets.left - edgeInsets.right, [[self->contentViewProxy controller] view].frame.size.height - (edgeInsets.top) - edgeInsets.bottom);
              }
              else {
                  if (nonSystemSheetShouldScroll == NO) {
                      self->contentViewProxy.view.frame = CGRectMake(self->contentViewProxy.view.frame.origin.x + edgeInsets.left, self->contentViewProxy.view.frame.origin.y + (edgeInsets.top), self->contentViewProxy.view.frame.size.width - edgeInsets.left - edgeInsets.right, self->contentViewProxy.view.frame.size.height - (edgeInsets.top) - edgeInsets.bottom);
                  }
              }
          }
      },
      NO);
}

#pragma mark Delegate methods


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
        
    if (scrollView.contentOffset.y <= 0) {
        //scrollView.contentOffset = CGPointZero;
        if (self.dismissing == NO){
            self.dismissing = YES;
        }
    }
    else {
        self.dismissing = NO;
    }
}
//
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView // scrolling has ended
{
    self.dismissing = NO;
}
//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.dismissing = NO;
}

//-(void)scrollViewWillBeginDragging:(ContentScrollView *)scrollView{
//   // [customBottomSheet panRecognizerEnabled:NO];
//    NSLog(@"scrollViewWillBeginDragging ");
//    if ([customBottomSheet panRecognizerState] == YES) {
//        NSLog(@"scrollViewWillBeginDragging pan disabled");
//        [customBottomSheet  :NO];
//    }
//}

- (void)proxyDidRelayout:(id)sender
{
    TiThreadPerformOnMainThread(
        ^{
            if (sender == contentViewProxy) {
              if (viewController != nil) {
                  CGSize newSize = [self contentSize:sender];
                if (TiBottomSheetContentSize.width != newSize.width || TiBottomSheetContentSize.height != newSize.height){
                  if (!CGSizeEqualToSize([viewController preferredContentSize], newSize)) {
                    [self updateContentSize];
                  }
                }
             }
            }
        },
      NO);

}

- (void)sheetPresentationControllerDidChangeSelectedDetentIdentifier :(UISheetPresentationController *)bottomSheetPresentationController API_AVAILABLE(ios(15.0),macCatalyst(15.0))
{
    if (bottomSheetPresentationController.selectedDetentIdentifier == UISheetPresentationControllerDetentIdentifierMedium){
        NSDictionary *detentObject = [NSDictionary dictionaryWithObjectsAndKeys:@"medium", @"selectedDetentIdentifier", nil];
        [self fireEvent:@"detentChange" withObject:detentObject];
    }
    else if (bottomSheetPresentationController.selectedDetentIdentifier == UISheetPresentationControllerDetentIdentifierLarge){
        NSDictionary *detentObject = [NSDictionary dictionaryWithObjectsAndKeys:@"large", @"selectedDetentIdentifier", nil];
        [self fireEvent:@"detentChange" withObject:detentObject];
    }
}

- (BOOL)presentationControllerShouldDismiss:(UISheetPresentationController *)bottomSheetPresentationController API_AVAILABLE(ios(15.0),macCatalyst(15.0))
{
  if ([[self viewController] presentedViewController] != nil) {
    return NO;
  }
  [self fireEvent:@"dismissing" withObject:nil];
  return YES;
}

- (void)presentationControllerDidDismiss:(UISheetPresentationController *)bottomSheetPresentationController API_AVAILABLE(ios(15.0),macCatalyst(15.0))
{
    if (eventFired == NO){
        eventFired = YES;
        [self fireEvent:@"close" withObject:nil];
    }
    [self cleanup];
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


