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
#import "TiWindowProxy+Addons.h"

#import <TitaniumKit/TiViewTemplate.h>
#import "BottomSheetViewController.h"


@interface TiBottomsheetcontrollerProxy : TiProxy <UISheetPresentationControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, TiProxyObserver> {
//@private
  pthread_rwlock_t listenerLockSheet;
  NSMutableDictionary *listenersSheet;
  UIEdgeInsets insets;
  UIView *containerView;
  UIView *contentViewOfSheet;
  UIViewController *childController;
  UIScrollView *myScrollView;
  BOOL nonSystemSheetShouldScroll;
  BOOL nonSystemSheetAutomaticStartPositionFromContentViewHeight;
  BOOL eventFired;
  BOOL useNavController;
  BOOL defaultsToNonSystemSheet;
  BOOL contentViewScrollingDisabled;
  CGSize TiBottomSheetContentSize;
  UIViewController *viewController;
  TiUINavigationWindowProxy *centerProxy;
  UISheetPresentationController *bottomSheet API_AVAILABLE(ios(15.0),macCatalyst(15.0));
  UIView *handle;
  NSDictionary *userDetents;
  NSString *detentStatus;
  NSString *lastDetentStatus;
  UIView *backgroundView;
  CGFloat realContentHeight;
  CGFloat scrollableContentHeight;
  UIEdgeInsets bottomSheetSafeAreaInset;
  TiViewProxy *contentViewProxy;
  TiViewProxy *closeButtonProxy;
  BOOL animated;
  BOOL bottomSheetInitialized;
  BOOL isDismissing;
  NSCondition *bottomSheetclosingCondition;
  TiDimension poWidth;
  TiDimension poHeight;
  TiDimension poBWidth;
  TiDimension poBHeight;
  BOOL deviceRotated;
  TiBottomsheetcontrollerProxy *currentTiBottomSheet;
  UIView *closeButtonView;
  BottomSheetViewController *customBottomSheet;
}


@property (assign, nonatomic) BOOL fixedHeight;
@property (assign, nonatomic) BOOL insetsDone;
@property (assign, nonatomic) bool dismissing;
@property (assign, nonatomic) TiViewProxy * _Nonnull viewProxy;
@property(nonatomic, copy) NSArray<UISheetPresentationControllerDetent *> * detents API_AVAILABLE(ios(15.0),macCatalyst(15.0));
@property(nonatomic, copy, nullable) UISheetPresentationControllerDetentIdentifier largestUndimmedDetentIdentifier API_AVAILABLE(ios(15.0),macCatalyst(15.0));

- (void)sendEvent:(id _Nonnull)args;
- (UIView* _Nonnull)backgroundView;
- (UIView* _Nonnull)containerView;
- (CGFloat)realContentHeight;
- (CGFloat)scrollableContentHeight;
- (BOOL)nonSystemSheetAutomaticStartPositionFromContentViewHeight;
- (UIScrollView* _Nonnull)scrollView;
- (BOOL)nonSystemSheetShouldScroll;
- (UIView* _Nonnull)contentViewOfSheet;
@end

@interface myViewController : UIViewController

@end
