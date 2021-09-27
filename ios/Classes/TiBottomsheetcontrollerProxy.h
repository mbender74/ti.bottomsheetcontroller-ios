/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2021 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */

#import <TitaniumKit/TiViewController.h>
#import <TitaniumKit/TiViewProxy.h>
#import <TitaniumKit/TitaniumKit.h>
#import "BottomSheetVC.h"


@interface TiBottomsheetcontrollerProxy : TiProxy <UISheetPresentationControllerDelegate, TiProxyObserver> {
  CGSize TiBottomSheetContentSize;
  UIViewController *viewController;
  UISheetPresentationController *bottomSheet;
  NSDictionary *userDetents;

  @private
  TiViewProxy *contentViewProxy;
  CGRect popoverRect;
  BOOL animated;
  BOOL popoverInitialized;
  BOOL isDismissing;
  NSCondition *bottomSheetclosingCondition;
  TiDimension poWidth;
  TiDimension poHeight;
  BOOL deviceRotated;
}
@property(nonatomic, copy) NSArray<UISheetPresentationControllerDetent *> * _Nullable detents;
@property(nonatomic, copy, nullable) UISheetPresentationControllerDetentIdentifier largestUndimmedDetentIdentifier;
@end


