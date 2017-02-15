//
// RSDFDatePickerDayCell.m
//
// Copyright (c) 2013 Evadne Wu, http://radi.ws/
// Copyright (c) 2013-2016 Ruslan Skorb, http://ruslanskorb.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "RSDFDatePickerDayCell.h"

@interface RSDFDatePickerDayCell ()

@property (weak, readwrite, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *leftShadowView;
@property (weak, nonatomic) IBOutlet UIView *rightShadowView;
@property (weak, nonatomic) IBOutlet UIView *selectedDayView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIView *markView;

@end

@implementation RSDFDatePickerDayCell

@synthesize markColor = _markColor;

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitializer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitializer];
    }
    return self;
}

- (void)commonInitializer
{
    self.backgroundColor = [self selfBackgroundColor];
    [self updateSubviews];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self updateSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.selectedDayView.layer.cornerRadius = CGRectGetWidth(self.selectedDayView.bounds) / 2.0;
    self.overlayView.layer.cornerRadius = CGRectGetWidth(self.overlayView.bounds) / 2.0;
    self.markView.layer.cornerRadius = CGRectGetWidth(self.markView.bounds) / 2.0;
}

- (void)drawRect:(CGRect)rect
{
    [self updateSubviews];
}

#pragma mark - Custom Accessors

- (UIColor *)markColor
{
    if (!_markColor) {
        _markColor = [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
    }
    return _markColor;
}

- (void)setMarkColor:(UIColor *)markColor
{
    if (![_markColor isEqual:markColor]) {
        _markColor = markColor;
        [self setNeedsDisplay];
    }
}

#pragma mark - Private

- (void)updateSubviews
{
    self.selectedDayView.hidden = !self.isSelected || self.isNotThisMonth || self.isOutOfRange;
    self.overlayView.hidden = !self.isHighlighted || self.isNotThisMonth || self.isOutOfRange;
    self.markView.hidden = !self.isMarked || self.isNotThisMonth || self.isOutOfRange;
    
    if (self.isNotThisMonth) {
        self.dateLabel.textColor = [self notThisMonthLabelTextColor];
        self.dateLabel.font = [self dayLabelFont];
    } else {
        if (self.isOutOfRange) {
            self.dateLabel.textColor = [self outOfRangeDayLabelTextColor];
            self.dateLabel.font = [self outOfRangeDayLabelFont];
        } else {
            if (!self.isSelected) {
                if (!self.isToday) {
                    self.dateLabel.font = [self dayLabelFont];
                    if (!self.dayOff) {
                        if (self.isPastDate) {
                            self.dateLabel.textColor = [self pastDayLabelTextColor];
                        } else {
                            self.dateLabel.textColor = [self dayLabelTextColor];
                        }
                    } else {
                        if (self.isPastDate) {
                            self.dateLabel.textColor = [self pastDayOffLabelTextColor];
                        } else {
                            self.dateLabel.textColor = [self dayOffLabelTextColor];
                        }
                    }
                } else {
                    self.dateLabel.font = [self todayLabelFont];
                    self.dateLabel.textColor = [self todayLabelTextColor];
                }
                self.leftShadowView.hidden = YES;
                self.rightShadowView.hidden = YES;
            } else {
                if (!self.isToday) {
                    if (self.isStartOfSelectedRange || self.isEndOfSelectedRange) {
                        self.dateLabel.font = [self selectedDayLabelFont];
                        self.dateLabel.textColor = [self selectedDayLabelTextColor];
                        self.leftShadowView.hidden = self.isStartOfSelectedRange;
                        self.rightShadowView.hidden = self.isEndOfSelectedRange;
                        self.selectedDayView.hidden = NO;
                    } else if (self.isInSelectedRange) {
                        self.dateLabel.font = [self inRangeDayLabelFont];
                        self.dateLabel.textColor = [self inRangeDayLabelTextColor];
                        self.leftShadowView.hidden = NO;
                        self.rightShadowView.hidden = NO;
                        self.selectedDayView.hidden = YES;
                    } else {
                        self.dateLabel.font = [self selectedDayLabelFont];
                        self.dateLabel.textColor = [self selectedDayLabelTextColor];
                        self.leftShadowView.hidden = YES;
                        self.rightShadowView.hidden = YES;
                        self.selectedDayView.hidden = NO;
                    }
                    self.leftShadowView.backgroundColor = [self inRangeDayColor];
                    self.rightShadowView.backgroundColor = [self inRangeDayColor];
                    self.selectedDayView.backgroundColor = [self selectedDayColor];
                } else {
                    self.dateLabel.font = [self selectedTodayLabelFont];
                    self.dateLabel.textColor = [self selectedTodayLabelTextColor];
                    self.leftShadowView.hidden = YES;
                    self.rightShadowView.hidden = YES;
                    self.selectedDayView.hidden = NO;
                    self.selectedDayView.backgroundColor = [self selectedTodayColor];
                }
            }
            if (self.isMarked) {
                self.markView.backgroundColor = self.markColor;
            }
        }
    }

}

#pragma mark - Atrributes of the View

- (UIColor *)selfBackgroundColor
{
    return [UIColor clearColor];
}

#pragma mark - Attributes of Subviews

- (UIFont *)dayLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
}

- (UIColor *)dayLabelTextColor
{
    return [UIColor blackColor];
}

- (UIColor *)dayOffLabelTextColor
{
    return [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
}

- (UIColor *)outOfRangeDayLabelTextColor
{
    return [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
}

- (UIFont *)outOfRangeDayLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
}

- (UIColor *)notThisMonthLabelTextColor
{
    return [UIColor clearColor];
}

- (UIColor *)pastDayLabelTextColor
{
    return [self dayLabelTextColor];
}

- (UIColor *)pastDayOffLabelTextColor
{
    return [self dayOffLabelTextColor];
}

- (UIFont *)todayLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
}

- (UIColor *)todayLabelTextColor
{
    return [UIColor colorWithRed:0/255.0f green:121/255.0f blue:255/255.0f alpha:1.0f];
}

- (UIFont *)selectedTodayLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:19.0f];
}

- (UIColor *)selectedTodayLabelTextColor
{
    return [UIColor whiteColor];
}

- (UIColor *)selectedTodayColor
{
    return [UIColor colorWithRed:0/255.0f green:121/255.0f blue:255/255.0f alpha:1.0f];
}

- (UIFont *)selectedDayLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:19.0f];
}

- (UIFont *)inRangeDayLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:19.0f];
}

- (UIColor *)inRangeDayLabelTextColor
{
    return [UIColor whiteColor];
}

- (UIColor *)selectedDayLabelTextColor
{
    return [UIColor whiteColor];
}

- (UIColor *)selectedDayColor
{
    return [UIColor colorWithRed:255/255.0f green:59/255.0f blue:48/255.0f alpha:1.0f];
}

- (UIColor *)inRangeDayColor
{
    return [UIColor colorWithRed:255/255.0f green:59/255.0f blue:48/255.0f alpha:0.2f];
}

- (UIColor *)overlayColor
{
    return [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
}

@end
