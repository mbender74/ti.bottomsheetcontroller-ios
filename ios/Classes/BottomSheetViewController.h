//
//  BottomSheetViewController.h
//  navi-lite
//
//  Created by Phineas.Huang on 2020/5/29.
//  Copyright © 2020 Garmin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum Director {
    up,
    down,
}Director;

typedef enum State {
    partial,
    expanded,
    full,
    dismiss
}State;
static State maxState = full;
static CGFloat maxPosition = 0;
static State minState = partial;
static CGFloat minPosition = 0;
static UIEdgeInsets insets;
static bool panEnabled = YES;
static bool panInit = NO;
static bool panFromScrollView = NO;

static bool fullPositon = YES;
static bool mediumPosition = YES;
static bool smallPosition = YES;
static CGFloat lastScrollViewOffsetY = 0;
static CGFloat newSrollViewOffsetY = 0;
static CGFloat lastTranslation = 0;


static NSDictionary *userDetents;
static CGFloat fullViewYPosition = 0;
static CGFloat partialViewYPosition = 0;
static CGFloat expandedViewYPosition = 0;
static bool dismissModeOfSheet = NO;
static bool backgroundViewHidden = NO;
static UIColor *viewBackgroundColor = nil;
static UIColor *dimmedViewBackgroundColor = nil;
static NSString *largestUndimmedDetent = nil;
static NSString *startDetent = nil;
static NSString *detentString = nil;
@interface BottomSheetViewController : UIViewController
@property (assign, nonatomic) State lastStatus;
@property (assign, nonatomic) NSString *selectedDetentIdentifier;

- (id)proxyOfBottomSheetController;
- (void)setProxyOfBottomSheetController:(id)args;
- (void)moveViewWithGesture:(UIPanGestureRecognizer *)recognizer;
- (void)panGesture:(UIPanGestureRecognizer *)recognizer;
- (void)moveView:(State)state;
- (State)state;
- (void)panRecognizerEnabled:(bool)enabled;
- (bool)panRecognizerState;
- (UIPanGestureRecognizer *)panRecognizer;
- (void)panRecognizerInit:(bool)enabled;
- (void)panFromScrollView:(bool)enabled;

- (void)scrollView:(UIScrollView*)scrollview;
- (void)lastContentOffsetY:(CGFloat)contentOffsetY;
@end

NS_ASSUME_NONNULL_END
