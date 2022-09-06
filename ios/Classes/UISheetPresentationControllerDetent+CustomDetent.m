//
//  UISheetPresentationControllerDetent+CustomDetent.m
//  UISheetPresentationControllerCustomDetent
//
//  Created by Alex Perez on 7/31/21.
//

#import "UISheetPresentationControllerDetent+CustomDetent.h"

static NSString *const UISheetPresentationControllerDetentIdentifierCustomPrefix = @"UISheetPresentationController.Detent.Custom";

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
    UISheetPresentationControllerDetentIdentifier identifier = UISheetPresentationControllerDetentIdentifierCustom(height);
    return [UISheetPresentationControllerDetent _detentWithIdentifier:identifier constant:height];
}

@end
