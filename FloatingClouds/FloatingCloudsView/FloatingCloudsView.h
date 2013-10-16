//
//  FloatingCloudsView.h
//  FloatingClouds
//
//  Created by satgi on 13-10-11.
//  Copyright (c) 2013年 satgi.me. All rights reserved.
//

#define FCMaxVisibleWidth [[UIScreen mainScreen] bounds].size.width
#define FCExtendedWidth 80.0f
#define FCRowHeight 60.0f
#define FCLabelAnimationName @"moveAnimation"

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class FloatingCloudsView;

typedef NS_ENUM(NSUInteger, FCFloatingSpeed){
    FCFloatingSpeedDrag = 0,
    FCFloatingSpeedSlow,
    FCFloatingSpeedNormal,
    FCFloatingSpeedFast,
    FCFloatingSpeedSupersonic
};

@protocol FloatingCloudsViewDelegate <NSObject>

@optional

// Label has been tapped
- (void)didTapLabel:(UILabel *)label;

@end

@interface FloatingCloudsView : UIView

@property (nonatomic, assign) FCFloatingSpeed floatingSpeed;            // Animation Speed Of labels
@property (nonatomic, copy) NSArray *contents;                          // Contents array that holds labels' text
@property (nonatomic, copy) NSArray *randomColors;                      // Random colors array
@property (nonatomic, copy) NSArray *randomFonts;                       // Random fonts array
@property (nonatomic, assign) CGFloat rowHeight;                        // Height of label's superview
@property (nonatomic, assign) CGFloat width;                            // Width of FloatingCloudsView
@property (nonatomic, assign) CGFloat height;                           // Height of FloatingCloudsView

@property (nonatomic, assign) id<FloatingCloudsViewDelegate> delegate;  // FloatingCloudsView's delegate

- (id)initWithSuperview:(UIView *)superview;
- (void)show;
- (void)beginAnimation;
- (void)stopAnimation;

@end
