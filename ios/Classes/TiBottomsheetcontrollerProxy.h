/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2021 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#define USE_TI_UINAVIGATIONWINDOW

#import <TitaniumKit/TiViewController.h>
#import <TitaniumKit/TiViewProxy.h>
#import <TitaniumKit/TiProxy.h>
#import <TitaniumKit/TitaniumKit.h>
#import "TiUINavigationWindowProxy.h"
#import "TiUINavigationWindowInternal.h"

@interface ContentScrollView : UIScrollView

@property (assign, nonatomic) bool dismissing;

@end


@interface TiBottomsheetcontrollerProxy : TiProxy <UISheetPresentationControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, TiProxyObserver> {
  pthread_rwlock_t listenerLockSheet;
  NSMutableDictionary *listenersSheet;
  UIEdgeInsets insets;
  UIView *containerView;
  ContentScrollView *scrollView;
  BOOL nonSystemSheetShouldScroll;
  BOOL eventFired;
  BOOL useNavController;
  BOOL defaultsToNonSystemSheet;
  CGSize TiBottomSheetContentSize;
  UIViewController *viewController;
  TiUINavigationWindowProxy *centerProxy;
  UISheetPresentationController *bottomSheet;
  NSDictionary *userDetents;
  NSString *detentStatus;
  NSString *lastDetentStatus;
  UIView *backgroundView;
  @private
  TiViewProxy *contentViewProxy;
  TiViewProxy *closeButtonProxy;
  BOOL animated;
  BOOL popoverInitialized;
  BOOL isDismissing;
  NSCondition *bottomSheetclosingCondition;
  TiDimension poWidth;
  TiDimension poHeight;
  TiDimension poBWidth;
  TiDimension poBHeight;
  BOOL deviceRotated;
}
@property(nonatomic, copy) NSArray<UISheetPresentationControllerDetent *> * _Nullable detents;
@property(nonatomic, copy, nullable) UISheetPresentationControllerDetentIdentifier largestUndimmedDetentIdentifier;
- (void)sendEvent:(id)args;
- (UIView*)backgroundView;
- (UIScrollView*)scrollView;
- (TiBottomsheetcontrollerProxy*)bottomSheet;
- (void)bottomSheetModule:(id)args;

@end

@interface myViewController : UIViewController

@end
