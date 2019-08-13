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

#import "MDCBannerView+MaterialTheming.h"

#import <MaterialComponents/MaterialButtons+Theming.h>
#import <MaterialComponents/MaterialButtons.h>

static CGFloat const kTextViewOpacityDefault = (CGFloat)0.87;
static CGFloat const kDividerOpacityDefault = (CGFloat)0.12;

@implementation MDCBannerView (MaterialTheming)

- (void)applyThemeWithScheme:(nonnull id<MDCContainerScheming>)scheme {
  // Color
  [self applyThemeWithColorScheme:scheme.colorScheme];

  // Typography
  [self applyThemeWithTypographyScheme:scheme.typographyScheme];

  // Apply Text Theme to buttons on Banner by default.
  [self.leadingButton applyTextThemeWithScheme:scheme];
  [self.trailingButton applyTextThemeWithScheme:scheme];

  self.showsDivider = YES;
}

#pragma mark - Internal Helpers

- (void)applyThemeWithColorScheme:(id<MDCColorScheming>)colorScheme {
  self.backgroundColor = colorScheme.surfaceColor;
  self.textView.textColor =
      [colorScheme.onSurfaceColor colorWithAlphaComponent:kTextViewOpacityDefault];
  self.dividerColor = [colorScheme.onSurfaceColor colorWithAlphaComponent:kDividerOpacityDefault];
}

- (void)applyThemeWithTypographyScheme:(id<MDCTypographyScheming>)typographyScheme {
  UIFont *textFont = typographyScheme.body2;
  if ([typographyScheme respondsToSelector:@selector(useCurrentContentSizeCategoryWhenApplied)]) {
    useCurrentContentSizeCategoryWhenApplied =
        typographyScheme.useCurrentContentSizeCategoryWhenApplied;
  } else {
    useCurrentContentSizeCategoryWhenApplied =
        typographyScheme.mdc_adjustsFontForContentSizeCategory;
  }

  if (useCurrentContentSizeCategoryWhenApplied) {
    textFont = [textFont mdc_scaledFontForTraitEnvironment:self];
  }
  self.textView.font = textFont;
}

@end