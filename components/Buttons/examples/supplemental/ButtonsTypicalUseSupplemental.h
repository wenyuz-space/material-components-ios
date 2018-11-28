// Copyright 2016-present the Material Components for iOS authors. All Rights Reserved.
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

/* IMPORTANT:
 This file contains supplemental code used to populate the demos with dummy data or instructions.
 It is not necessary to import this file to use Material Components for iOS.
 */

#import <UIKit/UIKit.h>

#import "MaterialContainerScheme.h"
#import "MaterialColorScheme.h"
#import "MaterialShapeScheme.h"
#import "MaterialTypographyScheme.h"

@interface ButtonsTypicalUseViewController : UIViewController

@property(nonatomic, strong) NSArray *buttons;
@property(nonatomic, strong) NSArray *labels;
@property(nonatomic, strong) MDCContainerScheme *containerScheme;
@property(nonatomic, strong) MDCSemanticColorScheme *colorScheme;
@property(nonatomic, strong) MDCShapeScheme *shapeScheme;
@property(nonatomic, strong) MDCTypographyScheme *typographyScheme;

- (UILabel *)addLabelWithText:(NSString *)text;

@end

@interface ButtonsTypicalUseExampleViewController : ButtonsTypicalUseViewController

@end

@interface ButtonsShapesExampleViewController : ButtonsTypicalUseViewController

@end
