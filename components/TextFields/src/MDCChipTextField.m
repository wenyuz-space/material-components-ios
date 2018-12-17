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

#import "MDCChipTextField.h"

#import "MaterialChips.h"
#import "MDCChipTextFieldScrollView.h"

/*
 in progress:
 * scroll labels/chips view to the left, when not enough room for typing
 todo:
 * change labels to buttons (verifying interactivity of individual chips)
 * "enter" to create a chip - usability issue
 * scrolling through label/chips.
 * scroll the overlay view to correct position on focus and un-focus events (textFieldDidBeginEditing: ?)
 * RTL Support
 * tap to select a chip + another tap to remove it - if in the middle of the list. required?
 * MDCTextField placeholder stays floating after adding chips, removing them, then resigning
 done:
 * backspace to select and then delete an entire label/chip
 * convert text to label when pressing enter
 */

@interface MDCChipTextField ()

@property (nonatomic, strong) MDCChipTextFieldScrollView *chipsView;
@property (nonatomic, readonly) CGFloat insetX;
@property (nonatomic) CGFloat chipViewOffset;
@property (nonatomic, strong) NSLayoutConstraint *leadingConstraint;
@property (nonatomic, strong) NSMutableArray<MDCChipView *> *chips;

@end

@implementation MDCChipTextField

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _chipsView = [[MDCChipTextFieldScrollView alloc] initWithFrame:CGRectZero];
    _chipsView.chipSpacing = 10.0f;
    _chipsView.translatesAutoresizingMaskIntoConstraints = NO;
    _chipsView.backgroundColor = [UIColor yellowColor];
    _chipsView.clipsToBounds = YES;
    _chipsView.bounces = NO;
    _chipViewOffset = 0.0f;
    self.leftView = _chipsView;
    [self addTarget:self
             action:@selector(chipTextFieldTextDidChange)
   forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self
             action:@selector(chipTextFieldDidReturn)
   forControlEvents:UIControlEventEditingDidEndOnExit];

    _chips = [NSMutableArray array];
  }
  return self;
}

- (void)appendChipWithText:(NSString *)text {
  MDCChipView *chip = [[MDCChipView alloc] init];
  chip.titleLabel.text = text;
  chip.translatesAutoresizingMaskIntoConstraints = NO;

//  [self.chipsView addSubview:chip];

  // Constraints
//  [self.chipsView addConstraints:@[
//     [NSLayoutConstraint constraintWithItem:self.chipsView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:chip attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
//     [NSLayoutConstraint constraintWithItem:self.chipsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:chip attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]
//     ]];

//  MDCChipView *lastChip = [self.chips lastObject];
//  if (lastChip == nil) {
//    self.leadingConstraint = [NSLayoutConstraint constraintWithItem:self.chipsView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:chip attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
//    [self.chipsView addConstraint:self.leadingConstraint];
//  } else {
//    [self.chipsView addConstraint:[NSLayoutConstraint constraintWithItem:lastChip attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:chip attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
//  }

  // recalculate the layout to get a correct chip frame values
//  [chip sizeToFit];
  [self.chips addObject:chip];
//  [self.chipsView reloadData];
  [self.chipsView appendChipView:chip];
  [self.chipsView layoutIfNeeded];
//  self.insetX = CGRectGetMaxX(chip.frame);
//  self.insetX = CGRectGetWidth(self.chipsView.frame);

  self.leftViewMode = UITextFieldViewModeAlways;
}


//- (void)setInsetX:(CGFloat)insetX {
//  // TODO: The value should take the right view (cancel button etc.) into consideration.
//  _insetX = MIN(insetX, CGRectGetWidth(self.frame) - 50);
//}

- (CGFloat)insetX {
  return MAX(0, CGRectGetWidth(self.chipsView.frame) - self.chipViewOffset);
}

- (void)chipTextFieldTextDidChange {
  [self deselectAllChips];
  [self setupEditingRect];
}

- (void)chipTextFieldDidReturn {
  [self deselectAllChips];

  if (self.text.length) {
    [self appendChipWithText:[self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    self.text = @"";
  }

  // TODO: This is needed to maintain focus but is causing wonky behavior
  dispatch_async(dispatch_get_main_queue(), ^{
    [self becomeFirstResponder];
  });
}

- (void)setupEditingRect {
  CGRect textRect = [self textRectForBounds:self.bounds];
  UITextRange *textRange = [self textRangeFromPosition:self.beginningOfDocument
                                              toPosition:self.endOfDocument];
  CGRect inputRect = [self firstRectForRange:textRange];

  CGFloat space = textRect.size.width - inputRect.size.width;
  if (space < 0) {
    self.chipViewOffset -= space;
//    self.chipsView.offset = self.chipViewOffset;
  } else {
    self.chipViewOffset = MAX(self.chipViewOffset - space, 0);
//    self.chipsView.offset = self.chipViewOffset;
  }
}

#pragma mark - UITextField overrides

- (BOOL)shouldChangeTextInRange:(UITextRange *)range replacementText:(NSString *)text {
  NSLog(@"should change");
  return [super shouldChangeTextInRange:range replacementText:text];
}

- (void)deleteBackward {
  NSInteger cursorPosition = [self offsetFromPosition:self.beginningOfDocument
                                           toPosition:self.selectedTextRange.start];
  if (cursorPosition == 0) {
    [self respondToDeleteBackward];
  }
  [super deleteBackward];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
  CGRect textRect = [super textRectForBounds:bounds];
  textRect.origin.x = MAX(self.insetX, textRect.origin.x);
  //  editingRect.origin.x = self.insetX;
  return textRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
  CGRect editingRect = [super editingRectForBounds:bounds];
  editingRect.origin.x = MAX(self.insetX, editingRect.origin.x);
  // editingRect.origin.x = self.insetX;
  return editingRect;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
  CGRect leftViewRect = [super leftViewRectForBounds:bounds];
  leftViewRect.size.width = self.insetX;
  // TODO: take margin into consideration
  leftViewRect.size.width = MIN(CGRectGetWidth(self.frame), leftViewRect.size.width);
  return leftViewRect;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
  CGRect viewRect = [super rightViewRectForBounds:bounds];
  viewRect.size.width = MAX(self.insetX, viewRect.size.width);
  //viewRect.size.width = self.insetX;
  return viewRect;
}

#pragma mark - Deletion

- (void)deselectAllChipsExceptChip:(MDCChipView *)chip {
  for (MDCChipView *otherChip in self.chips) {
    if (chip != otherChip) {
      otherChip.selected = NO;
    }
  }
}

- (void)selectLastChip {
  MDCChipView *lastChip = self.chips.lastObject;
  [self deselectAllChipsExceptChip:lastChip];
  lastChip.selected = YES;
  UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification,
                                  [lastChip accessibilityLabel]);
}

- (void)deselectAllChips {
  [self deselectAllChipsExceptChip:nil];
}

- (void)removeChip:(MDCChipView *)chip {
//  [self.chips removeObject:chip];
//  [chip removeFromSuperview];
//
//  MDCChipView *lastChip = [self.chips lastObject];
////  self.insetX = CGRectGetMaxX(lastChip.frame) + 10;
//
//  CGFloat textFieldWidth = CGRectGetWidth([self textRectForBounds:self.bounds]);
//  if (self.leadingConstraint.constant > 0 &&  textFieldWidth > 0 ) {
////    self.insetX += textFieldWidth;
//    self.leadingConstraint.constant -= textFieldWidth;
//  }
//
//  [self invalidateIntrinsicContentSize];
//  [self setNeedsLayout];
//
//  if (self.chips.count == 0) {
//    self.leftViewMode = UITextFieldViewModeNever;
//  }
}

- (void)removeSelectedChips {
  NSMutableArray *chipsToRemove = [NSMutableArray array];
  for (MDCChipView *chip in self.chips) {
    if (chip.isSelected) {
      [chipsToRemove addObject:chip];
    }
  }
  for (MDCChipView *chip in chipsToRemove) {
    [self removeChip:chip];
  }
}

- (BOOL)isAnyChipSelected {
  for (MDCChipView *chip in self.chips) {
    if (chip.isSelected) {
      return YES;
    }
  }
  return NO;
}

- (void)respondToDeleteBackward {
  if ([self isAnyChipSelected]) {
    [self removeSelectedChips];
    [self deselectAllChips];
  } else {
    [self selectLastChip];
  }
}

@end
