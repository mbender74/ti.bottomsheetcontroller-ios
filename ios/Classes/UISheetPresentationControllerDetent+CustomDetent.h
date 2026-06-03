//
//  UISheetPresentationControllerDetent+CustomDetent.h
//  UISheetPresentationControllerCustomDetent
//
//  Created by Alex Perez on 7/31/21.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const UISheetPresentationControllerDetentIdentifierCustomPrefix;
FOUNDATION_EXPORT UISheetPresentationControllerDetentIdentifier UISheetPresentationControllerDetentIdentifierCustom(CGFloat height);

@interface UISheetPresentationControllerDetent (CustomDetent)

/// Creates a custom detent with the specified height (iOS 15+)
/// @param height The height of the detent
/// @note The total height of the presented sheet is the bottom safe area height + detent height
+ (instancetype)customDetentWithHeight:(CGFloat)height NS_SWIFT_NAME(custom(_:));

/// Creates a custom detent with a user-defined key and height (iOS 16+, falls back to iOS 15 private API)
/// @param key The identifier key used in detentChange events and selectedDetentIdentifier
/// @param height The height of the detent
/// @note On iOS 16+ the key is the actual identifier; on iOS 15 the identifier is height-based
+ (instancetype)customDetentWithKey:(NSString *)key height:(CGFloat)height NS_SWIFT_NAME(custom(key:height:));

@end

NS_ASSUME_NONNULL_END
