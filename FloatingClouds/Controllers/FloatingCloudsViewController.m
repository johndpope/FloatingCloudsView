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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"Floating Clouds";
    
    self.floatingCloudsView = [[FloatingCloudsView alloc] init];
    self.floatingCloudsView.delegate = self;
    self.floatingCloudsView.floatingSpeed = FCFloatingSpeedNormal;
    self.floatingCloudsView.backgroundColor = [UIColor blackColor];
//    self.floatingCloudsView.randomColors = @[[UIColor whiteColor]];
//    self.floatingCloudsView.randomFonts = @[[UIFont systemFontOfSize:12.0f]];
//    self.floatingCloudsView.contents = @[@"Breaking Bad"];
    self.floatingCloudsView.frame = self.view.bounds;
    [self.view addSubview:self.floatingCloudsView];
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
