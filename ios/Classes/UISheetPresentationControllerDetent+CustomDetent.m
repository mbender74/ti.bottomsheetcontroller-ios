//
//  UISheetPresentationControllerDetent+CustomDetent.m
//  UISheetPresentationControllerCustomDetent
//
//  Created by Alex Perez on 7/31/21.
//

#import "UISheetPresentationControllerDetent+CustomDetent.h"

NSString *const UISheetPresentationControllerDetentIdentifierCustomPrefix = @"UISheetPresentationController.Detent.Custom";

API_AVAILABLE(ios(15.0),macCatalyst(15.0))
UISheetPresentationControllerDetentIdentifier UISheetPresentationControllerDetentIdentifierCustom(CGFloat height) {
    return [UISheetPresentationControllerDetentIdentifierCustomPrefix stringByAppendingString:[@(height) stringValue]];
}

@interface UISheetPresentationControllerDetent (CustomDetentPrivate)

// Private API, subject to break in future releases
+ (instancetype)_detentWithIdentifier:(UISheetPresentationControllerDetentIdentifier)identifier constant:(CGFloat)constant;

@end

@implementation UISheetPresentationControllerDetent (CustomDetent)

+ (instancetype)customDetentWithHeight:(CGFloat)height {
    if (@available(iOS 16.0, macCatalyst 16.0, *)) {
        return [UISheetPresentationControllerDetent customDetentWithIdentifier:UISheetPresentationControllerDetentIdentifierCustom(height)
                                                                      resolver:^CGFloat(id<UISheetPresentationControllerDetentResolutionContext> context) {
            return height;
        }];
    }
    // Fallback for iOS 15
    UISheetPresentationControllerDetentIdentifier identifier = UISheetPresentationControllerDetentIdentifierCustom(height);
    return [UISheetPresentationControllerDetent _detentWithIdentifier:identifier constant:height];
}

+ (instancetype)customDetentWithKey:(NSString *)key height:(CGFloat)height {
    if (@available(iOS 16.0, macCatalyst 16.0, *)) {
        return [UISheetPresentationControllerDetent customDetentWithIdentifier:key
                                                                      resolver:^CGFloat(id<UISheetPresentationControllerDetentResolutionContext> context) {
            return height;
        }];
    }
    // Fallback for iOS 15 - uses height-based identifier (private API)
    UISheetPresentationControllerDetentIdentifier identifier = UISheetPresentationControllerDetentIdentifierCustom(height);
    return [UISheetPresentationControllerDetent _detentWithIdentifier:identifier constant:height];
}

@end
