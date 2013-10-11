//
//  FloatingCloudsViewController.m
//  FloatingClouds
//
//  Created by satgi on 13-10-11.
//  Copyright (c) 2013年 satgi.me. All rights reserved.
//

#import "FloatingCloudsViewController.h"

@interface FloatingCloudsViewController ()

@property (nonatomic, strong) FloatingCloudsView *floatingCloudsView;

@end

@implementation FloatingCloudsViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.view = scrollView;
    self.title = @"Floating Clouds";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.floatingCloudsView = [[FloatingCloudsView alloc] initWithSuperview:self.view];
    self.floatingCloudsView.delegate = self;
    
//    Customize your FloatingCloudsView
    
//    self.floatingCloudsView.floatingSpeed = FCFloatingSpeedNormal;
//    self.floatingCloudsView.rowHeight = 60.0f;
//    self.floatingCloudsView.width = [UIScreen mainScreen].bounds.size.width;
//    self.floatingCloudsView.backgroundColor = [UIColor blackColor];
//    self.floatingCloudsView.contents = @[@"Breaking Bad is the most awesome TV show.",
//                                         @"Walter White",
//                                         @"Jesse Pinkman",
//                                         @"Saul Goodman",
//                                         @"Mike Ehrmantraut",
//                                         @"Gustavo Fring",
//                                         @"Hank Schrader",
//                                         @"Walter White, Jr."];
//    self.floatingCloudsView.randomColors = @[[UIColor whiteColor],
//                                             [UIColor grayColor],
//                                             [UIColor orangeColor],
//                                             [UIColor greenColor],
//                                             [UIColor purpleColor]];
//    self.floatingCloudsView.randomFonts = @[[UIFont systemFontOfSize:12.0f],
//                                            [UIFont systemFontOfSize:14.0f],
//                                            [UIFont systemFontOfSize:16.0f],
//                                            [UIFont systemFontOfSize:18.0f]];
    
    [self.floatingCloudsView show];
    [(UIScrollView *)self.view setContentSize:self.floatingCloudsView.frame.size];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.floatingCloudsView beginAnimation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.floatingCloudsView stopAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)didTapLabel:(UILabel *)label
{
    NSLog(@"You tapped label: %@ ", label.text);
}

@end
