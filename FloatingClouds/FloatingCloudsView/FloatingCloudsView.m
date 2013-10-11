//
//  FloatingCloudsView.m
//  FloatingClouds
//
//  Created by satgi on 13-10-11.
//  Copyright (c) 2013年 satgi.me. All rights reserved.
//

#import "FloatingCloudsView.h"

static NSString *const kAnimationName = @"moveAnimation";

@interface FloatingCloudsView ()

@property (nonatomic, assign) CGFloat extendedWidth;
@property (nonatomic, copy) NSArray *labels;
@property (nonatomic, strong) NSMutableArray *labelBlocks;
@property (nonatomic, strong) NSMutableArray *settledLabels;
@property (nonatomic, strong) UIView *superview;

- (id)initWithSuperview:(UIView *)superview;
- (void)initialize;

- (void)generateLabels;
- (void)generateLabelHolderViews;
- (void)layoutLabels;
- (void)layoutLabelsAndLabelHolderViews;
- (void)layoutSelf;

- (void)generateAnimation;
- (CGFloat)animationDurationBySpeed:(FCFloatingSpeed)speed;
- (CGPoint)randomPointWithHorizontalEdge:(CGFloat)horizontalEdge
                            verticalEdge:(CGFloat)verticalEdge
                              widthRange:(CGFloat)widthRange
                             heightRange:(CGFloat)heightRange;

- (id)randomElement:(NSArray *)array;
- (UIFont *)randomFontWithBaseSize:(CGFloat)baseSize
                             range:(NSUInteger)range;
- (NSArray *)lengthSortedLabels:(NSArray *)labels;
- (CGFloat)proportionOfFormerUIView:(UIView *)former
                       LatterUIView:(UIView *)latter;

@end

@implementation FloatingCloudsView

- (id)initWithSuperview:(UIView *)superview
{
    self = [super init];
    if (self) {
        [self initialize];
        _superview = superview;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        _width = frame.size.width;
        _height = frame.size.height;
    }
    return self;
}

- (void)initialize
{
    _labels = [NSMutableArray array];
    _labelBlocks = [NSMutableArray array];
    _floatingSpeed = FCFloatingSpeedNormal;
    _extendedWidth = DefaultExtendedWidth;
    _rowHeight = DefaultRowHeight;
    _width = DefaultMaxVisibleWidth;
    _contents = @[@"Breaking Bad is the most awesome TV show.",
                  @"Walter White",
                  @"Jesse Pinkman",
                  @"Saul Goodman",
                  @"Mike Ehrmantraut",
                  @"Gustavo Fring",
                  @"Hank Schrader",
                  @"Walter White, Jr."];
    _randomColors = @[[UIColor colorWithRed:181.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1.0],
                      [UIColor colorWithRed:245.0/255.0 green:248.0/255.0 blue:250.0/255.0 alpha:1.0],
                      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                      [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0],
                      [UIColor colorWithRed:197.0/255.0 green:211.0/255.0 blue:227.0/255.0 alpha:1.0],
                      [UIColor colorWithRed:204.0/255.0 green:217.0/255.0 blue:230.0/255.0 alpha:1.0]];
    self.backgroundColor = [UIColor colorWithRed:143.0f/255.0f green:173.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
}

#pragma mark - Accessor Methods

- (void)setLabels:(NSArray *)labels
{
    for (UILabel *label in _labels) {
        [label.superview removeFromSuperview];
    }
    _labels = labels;
}

#pragma mark - Generate View Methods

- (void)generateLabels
{
    NSMutableArray *labels = [NSMutableArray array];
    for (NSString *task in self.contents) {
        UIFont *font;
        if (self.randomFonts == nil) {
            font = [self randomFontWithBaseSize:12.0f range:12];
        } else {
            font = [self randomElement:self.randomFonts];
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = task;
        label.font = font;
        label.textColor = [self randomElement:self.randomColors];
        
        CGSize textSize;
        if ([task respondsToSelector:@selector(sizeWithAttributes:)]) {
            textSize = [task sizeWithAttributes:@{ NSFontAttributeName : font }];
        } else {
            textSize = [task sizeWithFont:font];
        }
        
        label.frame = CGRectMake(0.0f, 0.0f,
                                 ceilf(textSize.width), ceilf(textSize.height));
        [labels addObject:label];
    }
    
    // Sort labels by label's text length
    // Longer ahead
    self.labels = [self lengthSortedLabels:labels];
}

- (void)generateLabelHolderViews
{
    NSMutableArray *settledLabels = [[NSMutableArray alloc] init];
    NSMutableArray *unsettledLabels = [self.labels mutableCopy];
    NSUInteger labelsCount = [self.labels count];
    
    // If not all the labels are settled
    while ([settledLabels count] < labelsCount && [unsettledLabels count] > 0) {
        
        // The former label in a single line
        UILabel *formerLabel = [unsettledLabels firstObject];
        CGSize formerLabelSize = formerLabel.frame.size;
        CGFloat formerLabelWidth = formerLabelSize.width;
        CGFloat totalWidth = formerLabelWidth;
        
        NSMutableDictionary *labelDict = [@{@"isNewline": @YES,
                                            @"label": formerLabel} mutableCopy];
        
        // Settle new label and delete it from the temporary label holder array: unsettledLabels
        [settledLabels addObject:labelDict];
        [unsettledLabels removeObject:formerLabel];
        
        // Check if there's space left for another label to append the current label
        if ([unsettledLabels count] > 0 && totalWidth < self.width) {
            
            // The latter label in a single line
            UILabel *latterLabel = [unsettledLabels lastObject];
            CGSize latterLabelSize = latterLabel.frame.size;
            CGFloat latterLabelWidth = latterLabelSize.width;
            totalWidth += latterLabelWidth;
            
            // Enough space for two labels to stay in a single line
            if (totalWidth + self.extendedWidth < self.width) {
                NSMutableDictionary *labelDict = [@{@"isNewline": @NO,
                                                    @"label": latterLabel} mutableCopy];
                [settledLabels addObject:labelDict];
                [unsettledLabels removeObject:latterLabel];
            } else {
                
                // The former label's width > half of the screen's width
                if (formerLabelWidth > self.width / 2.0f) {
                    
                    // The latter label's width > half of the screen's width
                    // Move it to the head of the unsettledLabels array
                    // Longer ahead
                } else if (latterLabelWidth > self.width / 2.0f) {
                    UILabel *firstLabel = [unsettledLabels firstObject];
                    [unsettledLabels replaceObjectAtIndex:0
                                               withObject:[unsettledLabels lastObject]];
                    [unsettledLabels replaceObjectAtIndex:[unsettledLabels count] - 1
                                               withObject:firstLabel];
                }
            }
        }
    }
    
    self.settledLabels = settledLabels;
}

- (void)layoutLabels;
{
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    
    for (NSMutableDictionary *labelDict in self.settledLabels) {
        UILabel *label = labelDict[@"label"];
        CGFloat height = self.rowHeight;
        CGFloat width = label.frame.size.width;
        NSUInteger index = [self.settledLabels indexOfObject:labelDict];
        
        // A new line
        BOOL singleLine = NO;
        BOOL newLine = [labelDict[@"isNewline"] boolValue];
        if (newLine) {
            if (index < [self.settledLabels count] - 1) {
                NSMutableDictionary *latterLabelDict = self.settledLabels[index + 1];
                singleLine = [latterLabelDict[@"isNewline"] boolValue];
            } else {
                singleLine = YES;
            }
            x = 0.0f;
            width = singleLine && width > self.width ? width + self.extendedWidth : self.width;
            y += index > 0 ? height : 0.0f;
            
            // New label after the former label
        } else {
            
            // Calculate the proportion of the two labels
            NSMutableDictionary *formerLabelDict = self.settledLabels[index - 1];
            UILabel *formerLabel = formerLabelDict[@"label"];
            CGFloat proportion = [self proportionOfFormerUIView:formerLabel
                                                   LatterUIView:label];
            
            // Reset the two labels frame by proportion
            CGFloat formerLabelBlockViewWidth = self.width * proportion;
            CGRect formerLabelBlockViewRect = CGRectFromString(formerLabelDict[@"rect"]);
            formerLabelBlockViewRect = CGRectMake(x, y,
                                                  formerLabelBlockViewWidth, formerLabelBlockViewRect.size.height);
            
            // Calculate the latter label's frame
            x += formerLabelBlockViewWidth;
            width = self.width - formerLabelBlockViewWidth;
            height = formerLabelBlockViewRect.size.height;
            
            // Store the former label's superview's frame
            [formerLabelDict setObject:NSStringFromCGRect(formerLabelBlockViewRect)
                                forKey:@"rect"];
        }
        
        // Store label's superview's frame
        CGRect labelBlockViewRect = CGRectMake(x, y,
                                               width, height);
        [labelDict setObject:NSStringFromCGRect(labelBlockViewRect)
                      forKey:@"rect"];
    }
    
    self.height = y + self.rowHeight;
}

- (void)layoutLabelsAndLabelHolderViews
{
    [self generateLabels];
    [self generateLabelHolderViews];
    [self layoutLabels];
    [self layoutSelf];
}

- (void)layoutSelf
{
    self.frame = CGRectMake(0.0f, 0.0f,
                            self.width, self.height);
}

- (void)show
{
    [self layoutLabelsAndLabelHolderViews];
    
    for (NSMutableDictionary *labelDict in self.settledLabels) {
        UILabel *label = labelDict[@"label"];
        UIView *labelBlockView = [[UIView alloc] init];
        labelBlockView.frame = CGRectFromString(labelDict[@"rect"]);
        [labelBlockView addSubview:label];
        [self addSubview:labelBlockView];
    }
    
    [self.superview addSubview:self];
}

#pragma mark - Generate Animation Methods

- (void)generateAnimation
{
    for (UILabel *label in self.labels) {
        CGRect superViewRect = label.superview.frame;
        CGSize labelSize = label.frame.size;
        
        CGFloat maxWidth = MAX(superViewRect.size.width, labelSize.width);
        CGFloat minWidth = MIN(superViewRect.size.width, labelSize.width);
        CGFloat widthRange = maxWidth - minWidth;
        
        CGFloat maxHeight = MAX(superViewRect.size.height, labelSize.height);
        CGFloat minHeight = MIN(superViewRect.size.height, labelSize.height);
        CGFloat heightRange = maxHeight - minHeight;
        
        // Generate path with random point
        CGPoint point = [self randomPointWithHorizontalEdge:minWidth / 2.0f
                                               verticalEdge:minHeight / 2.0f
                                                 widthRange:widthRange
                                                heightRange:heightRange];
        
        CGPoint point2 = [self randomPointWithHorizontalEdge:minWidth / 2.0f
                                                verticalEdge:minHeight / 2.0f
                                                  widthRange:widthRange
                                                 heightRange:heightRange];
        
        // Moving path
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:point];
        [path addLineToPoint:point2];
        [path closePath];
        
        // Animation Settings
        CGFloat randomDuration = [self animationDurationBySpeed:self.floatingSpeed];
        CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnimation.path = path.CGPath;
        moveAnimation.duration = randomDuration;
        moveAnimation.repeatCount = MAXFLOAT;
        [label.layer addAnimation:moveAnimation forKey:kAnimationName];
    }
}

- (CGFloat)animationDurationBySpeed:(FCFloatingSpeed)speed
{
    CGFloat duration;
    switch (speed) {
        case FCFloatingSpeedDrag:
            duration = 14.0f + arc4random_uniform(9);
            break;
        case FCFloatingSpeedSlow:
            duration = 10.5f + arc4random_uniform(8);
            break;
        case FCFloatingSpeedNormal:
            duration = 7.0f + arc4random_uniform(8);
            break;
        case FCFloatingSpeedFast:
            duration = 3.0f + arc4random_uniform(5);
            break;
        case FCFloatingSpeedSupersonic:
            duration = 0.5f + arc4random_uniform(3);
            break;
    }
    
    return duration;
}

- (CGPoint)randomPointWithHorizontalEdge:(CGFloat)horizontalEdge
                            verticalEdge:(CGFloat)verticalEdge
                              widthRange:(CGFloat)widthRange
                             heightRange:(CGFloat)heightRange
{
    CGFloat randomX = horizontalEdge + arc4random_uniform(widthRange);
    CGFloat randomY = verticalEdge + arc4random_uniform(heightRange);
    CGPoint point = CGPointMake(randomX, randomY);
    return point;
}

#pragma mark - Helper Methods

- (id)randomElement:(NSArray *)array
{
    return array[arc4random_uniform([array count])];
}

- (UIFont *)randomFontWithBaseSize:(CGFloat)baseSize
                             range:(NSUInteger)range
{
    return [UIFont systemFontOfSize:(baseSize + arc4random_uniform(range))];
}

- (CGFloat)proportionOfFormerUIView:(UIView *)former
                       LatterUIView:(UIView *)latter
{
    CGFloat formerWidth = former.frame.size.width;
    CGFloat latterWidth = latter.frame.size.width;
    return formerWidth / (formerWidth + latterWidth);
}

- (NSArray *)lengthSortedLabels:(NSArray *)labels
{
    NSArray *sortedLabels = [labels sortedArrayUsingComparator: ^(id label1, id label2) {
        
        CGFloat width1 = [(UILabel *)label1 frame].size.width;
        CGFloat width2 = [(UILabel *)label2 frame].size.width;
        
        if (width1 < width2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (width2 > width1) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortedLabels;
}


#pragma mark - FloatingCloudsView Delegate Methods

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    for (UILabel *label in self.labels) {
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:label];
        if ([label.layer.presentationLayer hitTest:touchLocation])
        {
            [_delegate didTapLabel:label];
        }
    }
}

#pragma mark - Animation Control Methods

- (void)beginAnimation
{
    [self stopAnimation];
    [self generateAnimation];
}

- (void)stopAnimation
{
    for (UILabel *label in self.labels) {
        [label.layer removeAllAnimations];
    }
}

@end
