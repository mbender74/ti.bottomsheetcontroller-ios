/**
 * ti.popover
 *
 * Created by Your Name
 * Copyright (c) 2021 Your Company. All rights reserved.
 */

#import "TiBottomsheetcontrollerModule.h"
#import "TiBottomsheetcontrollerProxy.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiBottomsheetcontrollerModule

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

#pragma mark Public API's

- (id)createBottomSheet:(id)args
{   
    if ([TiUtils isIOSVersionOrGreater:@"15.0"] || [TiUtils isMacOS] ) {
        if (@available(iOS 15, macCatalyst 15, *)) {
            return [[TiBottomsheetcontrollerProxy alloc] _initWithPageContext:[self executionContext] args:args];
        }
    }
    else {
        [self throwException:@"this API is not available on non iOS 15+" subreason:nil location:CODELOCATION];
        return nil;
    }
}

@end
