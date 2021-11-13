/**
 * ti.popover
 *
 * Created by Your Name
 * Copyright (c) 2021 Your Company. All rights reserved.
 */
#import "TiBottomsheetcontrollerProxy.h"
#import "TiBottomsheetcontrollerModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiBottomsheetcontrollerModule



#pragma mark Internal

- (id)moduleGUID
{
  return @"09a963f0-c30f-40eb-957a-1cff851c53fb";
}

- (NSString *)moduleId
{
  return @"ti.bottomsheetcontroller";
}


#pragma mark Lifecycle

-(void)startup
{
    // this method is called when the module is first loaded
    // you *must* call the superclass
    [super startup];

    NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
    // this method is called when the module is being unloaded
    // typically this is during shutdown. make sure you don't do too
    // much processing here or the app will be quit forceably

    // you *must* call the superclass
    [super shutdown:sender];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
    // optionally release any resources that can be dynamically
    // reloaded once memory is available - such as caches
    [super didReceiveMemoryWarning:notification];
}
#pragma mark Public API

- (id)createBottomSheet:(id)args{
//    return [[TiBottomsheetcontrollerProxy alloc] _initWithPageContext:[self executionContext] args:args];
    return [[TiBottomsheetcontrollerProxy alloc] _initWithPageContext:[self executionContext] args:args];
}



@end
