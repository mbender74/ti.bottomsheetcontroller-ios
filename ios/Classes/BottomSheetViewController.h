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


@interface BottomSheetViewController : UIViewController {

enum State maxState;
CGFloat maxPosition;
enum State minState;
CGFloat minPosition;
UIEdgeInsets insets;
UIEdgeInsets scrollBarinsets;
bool panEnabled;
bool panInit;
bool panFromScrollView;
CGFloat width;
CGFloat height;
CGRect customViewRect;
bool fullPositon;
bool mediumPosition;
bool smallPosition;
CGFloat lastScrollViewOffsetY;
CGFloat newSrollViewOffsetY;
CGFloat lastTranslation;
CGFloat yPosition;
NSDictionary *userDetents;
bool dismissModeOfSheet;
bool doNotTranslate;
bool backgroundViewHidden;
UIColor *viewBackgroundColor;
UIColor *dimmedViewBackgroundColor;
NSString *largestUndimmedDetent;
NSString *startDetent;
NSString *detentString ;
Director director;
UIScrollView *customSheetScrollView;
UIView *customView;
CGRect windowRect;
UIPanGestureRecognizer *thisGesture;
UIEdgeInsets safeAreaInset;

}

@property (assign, nonatomic) State lastStatus;
@property (assign, nonatomic) NSString *selectedDetentIdentifier;
@property (assign, nonatomic) CGFloat fullViewYPosition;
@property (assign, nonatomic) CGFloat partialViewYPosition;
@property (assign, nonatomic) CGFloat expandedViewYPosition;

- (id)proxyOfBottomSheetController;
- (void)setProxyOfBottomSheetController:(id)args;
- (void)moveViewWithGesture:(UIPanGestureRecognizer *)recognizer;
- (void)panGesture:(UIPanGestureRecognizer *)recognizer;
- (void)moveView:(State)state fromEvent:(bool)tapEvent;
- (State)state;
- (void)panRecognizerEnabled:(bool)enabled;
- (bool)panRecognizerState;
- (UIPanGestureRecognizer *)panRecognizer;
- (void)panRecognizerInit:(bool)enabled;
- (void)panFromScrollView:(bool)enabled;
- (void)changeInsets:(UIView *)view;
- (void)scrollView:(UIScrollView*)scrollview;
- (void)lastContentOffsetY:(CGFloat)contentOffsetY;
- (void)setupData;
@end

NS_ASSUME_NONNULL_END
