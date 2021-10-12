/**
 * ti.popover
 *
 * Created by Your Name
 * Copyright (c) 2021 Your Company. All rights reserved.
 */

#import "TiBottomsheetcontrollerModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiBottomsheetcontrollerProxy.h"

@implementation TiBottomsheetcontrollerModule


id myBottomSheet = nil;

#pragma mark Internal

- (id)moduleGUID
{
  return @"09a963f0-c30f-40eb-957a-1cff851c53fb";
}

- (NSString *)moduleId
{
  return @"ti.bottomsheetcontroller";
}

#pragma mark Public API

- (id)createBottomSheet:(id)args{
   // NSLog(@"createBottomSheet ");
    
    // [self performSelector:@selector(updateContentViewWithSafeAreaInsets:) withObject:insetsValue afterDelay:.05];

    if (myBottomSheet == nil){
        myBottomSheet = [[TiBottomsheetcontrollerProxy alloc] _initWithPageContext:[self executionContext] args:args];
        [myBottomSheet bottomSheetModule:self];
        return myBottomSheet;
    }
    else {
       // NSLog(@"is open ");
       // [self throwException:@"BottomSheet is already presented" subreason:nil location:CODELOCATION];
        //[myBottomSheet hide:nil];
        return myBottomSheet;
    }
 
}

@end
