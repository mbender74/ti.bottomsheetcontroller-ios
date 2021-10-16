/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2021 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#define USE_TI_UINAVIGATIONWINDOW
#define USE_TI_UISCROLLVIEW // Enable access to the core class
#define USE_TI_UITABLEVIEW // Enable access to the core class
#define USE_TI_UILISTVIEW

#import <TitaniumKit/TiViewController.h>
#import <TitaniumKit/TiViewProxy.h>
#import <TitaniumKit/TiProxy.h>
#import <TitaniumKit/TitaniumKit.h>
#import "TiUINavigationWindowProxy.h"
#import "TiUINavigationWindowInternal.h"
#import "TiWindowProxy+Addons.h"
#import "TiUIScrollViewProxy.h"
#import "TiUITableViewProxy.h"
#import "TiUIListViewProxy.h"
#import "TiUIScrollView.h"
#import "TiUITableView.h"
#import "TiUIListView.h"
#import <TitaniumKit/TiViewTemplate.h>

@interface ContentScrollView : UIScrollView

@property (assign, nonatomic) bool dismissing;

@end


@interface TiBottomsheetcontrollerProxy : TiProxy <UISheetPresentationControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, TiProxyObserver> {
@private
  pthread_rwlock_t listenerLockSheet;
  NSMutableDictionary *listenersSheet;
  UIEdgeInsets insets;
  UIView *containerView;
  UIView *contentViewOfSheet;
  ContentScrollView *scrollView;
  BOOL nonSystemSheetShouldScroll;
  BOOL nonSystemSheetAutomaticStartPositionFromContentViewHeight;
  BOOL eventFired;
  BOOL useNavController;
  BOOL defaultsToNonSystemSheet;
  BOOL contentViewScrollingDisabled;
  CGSize TiBottomSheetContentSize;
  UIViewController *viewController;
  TiUINavigationWindowProxy *centerProxy;
  UISheetPresentationController *bottomSheet;
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
}


@property (assign, nonatomic) BOOL fixedHeight;
@property (assign, nonatomic) BOOL insetsDone;

@property (assign, nonatomic) TiViewProxy *viewProxy;

@property(nonatomic, copy) NSArray<UISheetPresentationControllerDetent *> * _Nullable detents;
@property(nonatomic, copy, nullable) UISheetPresentationControllerDetentIdentifier largestUndimmedDetentIdentifier;
- (void)sendEvent:(id)args;
- (UIView*)backgroundView;
- (UIView*)containerView;
- (CGFloat)realContentHeight;
- (CGFloat)scrollableContentHeight;
- (BOOL)nonSystemSheetAutomaticStartPositionFromContentViewHeight;
- (UIScrollView*)scrollView;
- (void)bottomSheetModule:(id)args;
- (BOOL)nonSystemSheetShouldScroll;
- (UIView*)contentViewOfSheet;
@end

@interface myViewController : UIViewController

@end
