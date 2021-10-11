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

// This is generated for your module, please do not change it
- (id)moduleGUID
{
  return @"09a963f0-c30f-40eb-957a-1cff851c53fb";
}

// This is generated for your module, please do not change it
- (NSString *)moduleId
{
  return @"ti.bottomsheetcontroller";
}

#pragma mark Lifecycle

- (void)startup
{
  // This method is called when the module is first loaded
  // You *must* call the superclass
  [super startup];
    NSLog(@"[DEBUG] %@ loaded", self);
}


-(void)shutdown:(id)sender
{
    // this method is called when the module is being unloaded
    // typically this is during shutdown. make sure you don't do too
    // much processing here or the app will be quit forceably

    // you *must* call the superclass
    [super shutdown:sender];
}

#pragma mark Public API
- (void)cleanup
{
  myBottomSheet = nil;
   // NSLog(@"cleanup");
}

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
