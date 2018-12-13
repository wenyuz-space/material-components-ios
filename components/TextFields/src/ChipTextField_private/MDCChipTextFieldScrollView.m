// Copyright 2018-present the Material Components for iOS authors. All Rights Reserved.
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

#import "MDCChipTextFieldScrollView.h"

@interface MDCChipTextFieldScrollView ()

@property (nonatomic, readwrite, strong) NSMutableArray<MDCChipView *> *chipViews;
@property (nonatomic, readwrite, weak) UIView *contentView;

@property (nonatomic, readwrite, weak) NSLayoutConstraint *trailingConstraint;

@end

@implementation MDCChipTextFieldScrollView
@synthesize delegate=_delegate;

- (instancetype)initWithFrame:(CGRect)frame {
  if((self = [super initWithFrame:frame])) {
    [self commonInit];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if((self = [super initWithCoder:aDecoder])) {
    [self commonInit];
  }
  return self;
}

- (void)commonInit {
  // set up content view
  UIView *contentView = [[UIView alloc] initWithFrame:self.frame];
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:contentView];
  self.contentView = contentView;

  NSLayoutConstraint *contentConstraintTop = [NSLayoutConstraint constraintWithItem:contentView
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1
                                                                        constant:0];
  NSLayoutConstraint *contentConstraintBottom = [NSLayoutConstraint constraintWithItem:contentView
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1
                                                                           constant:0];
  NSLayoutConstraint *contentConstraintLeading = [NSLayoutConstraint constraintWithItem:contentView
                                                                          attribute:NSLayoutAttributeLeading
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeLeading
                                                                         multiplier:1
                                                                           constant:0];
  NSLayoutConstraint *contentConstraintTrailing = [NSLayoutConstraint constraintWithItem:contentView
                                                                              attribute:NSLayoutAttributeTrailing
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self
                                                                              attribute:NSLayoutAttributeTrailing
                                                                             multiplier:1
                                                                               constant:0];
  NSLayoutConstraint *contentConstraintHeight = [NSLayoutConstraint constraintWithItem:contentView
                                                                               attribute:NSLayoutAttributeHeight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self
                                                                               attribute:NSLayoutAttributeHeight
                                                                              multiplier:1
                                                                                constant:0];
  NSLayoutConstraint *contentConstraintWidth = [NSLayoutConstraint constraintWithItem:contentView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:1
                                                                        constant:0];
  [NSLayoutConstraint activateConstraints:@[contentConstraintTop, contentConstraintBottom, contentConstraintLeading, contentConstraintTrailing, contentConstraintHeight, contentConstraintWidth]];
  self.trailingConstraint = contentConstraintTrailing;
  
  [self setShowsVerticalScrollIndicator:NO];
  [self setShowsHorizontalScrollIndicator:NO];

  self.chipViews = [[NSMutableArray alloc] init];
}

- (void)appendChipView:(MDCChipView *)chipView {
  self.trailingConstraint.active = NO;
  [self.contentView addSubview:chipView];
  NSLayoutConstraint *chipViewConstraintTop = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:chipView
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1
                                                                           constant:0];
  NSLayoutConstraint *chipViewConstraintBottom = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                             attribute:NSLayoutAttributeBottom
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:chipView
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1
                                                                              constant:0];
  NSLayoutConstraint *chipViewConstraintLeading = nil;
  if (self.chipViews.count == 0) {
    chipViewConstraintLeading = [NSLayoutConstraint constraintWithItem:self.contentView
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:chipView
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1
                                                         constant:0];
  } else {
    chipViewConstraintLeading = [NSLayoutConstraint constraintWithItem:chipView
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:[self.chipViews lastObject]
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1
                                                         constant:0];

  }
  NSLayoutConstraint *chipViewConstraintTrailing = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                           attribute:NSLayoutAttributeTrailing
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:chipView attribute:NSLayoutAttributeTrailing
                                                                          multiplier:1
                                                                            constant:0];
  [NSLayoutConstraint activateConstraints:@[chipViewConstraintTop, chipViewConstraintBottom, chipViewConstraintLeading, chipViewConstraintTrailing]];
  self.trailingConstraint = chipViewConstraintTrailing;
  [self.chipViews addObject:chipView];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  self.contentSize = self.contentView.frame.size;
  self.contentOffset = CGPointMake(self.contentHorizontalOffset, self.contentOffset.y);
}

@end
