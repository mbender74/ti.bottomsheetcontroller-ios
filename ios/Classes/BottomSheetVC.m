//
//  BottomSheetVC.m
//  BottomSheetTutorial
//
//  Created by Khoa Mai on 5/4/19.
//  Copyright © 2019 Khoa Mai. All rights reserved.
//

#import "BottomSheetVC.h"

@interface BottomSheetVC ()

@end

@implementation BottomSheetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:panGesture];
}

-(void) onPan:(UIPanGestureRecognizer *) sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    CGFloat y = CGRectGetMinY(self.view.frame);
    if (y + translation.y >= self.view.frame.size.height * 0.7 && y + translation.y <= [[UIScreen mainScreen] bounds].size.height - 80) {
        self.view.frame = CGRectMake(0, y + translation.y, self.view.frame.size.width, self.view.frame.size.height);
        [sender setTranslation:CGPointZero inView:self.view];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        double duration = velocity.y < 0 ? (y - self.view.frame.size.height * 0.7) / -velocity.y : ([[UIScreen mainScreen] bounds].size.height - 60) / velocity.y;
        duration = duration > 1.3 ? 1.0 : duration;
        [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            if (velocity.y >= 0) {
                self.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 60, self.view.frame.size.width, self.view.frame.size.height);
            } else {
                self.view.frame = CGRectMake(0, self.view.frame.size.height * 0.7, self.view.frame.size.width, self.view.frame.size.height);
            }
        } completion:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        CGFloat yComponent = [[UIScreen mainScreen] bounds].size.height - 60;
        self.view.frame = CGRectMake(0, yComponent, frame.size.width, frame.size.height);
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareBackground];
}

-(void) prepareBackground {
    self.view.layer.cornerRadius = 20.0;
    self.view.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
}

@end
