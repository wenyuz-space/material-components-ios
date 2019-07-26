// Copyright 2019-present the Material Components for iOS authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "UIColor+MaterialElevation.h"

#import <CoreGraphics/CoreGraphics.h>

#import "MaterialMath.h"
#import "UIColor+MaterialBlending.h"

@implementation UIColor (MaterialElevation)

- (UIColor *)mdc_resolvedColorWithTraitCollection:(UITraitCollection *)traitCollection
                                        elevation:(CGFloat)elevation {
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
  if (@available(iOS 13.0, *)) {
    UIColor *resolvedColor = [self resolvedColorWithTraitCollection:traitCollection];
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
      return [resolvedColor mdc_resolvedColorWithElevation:elevation];
    } else {
      return resolvedColor;
    }
  } else {
    return self;
  }
#else
  return self;
#endif
}

- (UIColor *)mdc_resolvedColorWithElevation:(CGFloat)elevation {
  if (CGColorGetPattern(self.CGColor)) {
    [NSException raise:NSGenericException
                format:@"Pattern-based colors are not supported by %@", NSStringFromSelector(_cmd)];
  }

  UIColor *overlayColor = UIColor.whiteColor;
  elevation = MAX(elevation, 0);
  CGFloat alphaValue = 0;
  if (!MDCCGFloatEqual(elevation, 0)) {
    // A formula is used here to simulate the alpha percentage stated on
    // https://material.io/design/color/dark-theme.html#properties
    // AlphaValue = 4.5 * ln (elevationValue + 1) + 2
    alphaValue = (CGFloat)4.5 * (CGFloat)log(elevation + 1) + 2;
  }
  // TODO (https://github.com/material-components/material-components-ios/issues/8096):
  // Grayscale color should be returned if color space is UIExtendedGrayColorSpace.
  return [UIColor mdc_blendColor:[overlayColor colorWithAlphaComponent:alphaValue * (CGFloat)0.01]
             withBackgroundColor:self];
}

@end
