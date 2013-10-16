FloatingCloudsView
==================

A collection view of labels with random animation, like the floating clouds.

## Usage

#### Initialize

```objective-c
FloatingCloudsView *floatingCloudsView = [[FloatingCloudsView alloc] initWithSuperview:yourSuperview];
```

#### Customize
```objective-c
floatingCloudsView.floatingSpeed = FCFloatingSpeedNormal;
floatingCloudsView.rowHeight = 60.0f;
floatingCloudsView.width = [UIScreen mainScreen].bounds.size.width;
floatingCloudsView.backgroundColor = [UIColor blackColor];
floatingCloudsView.contents = @[@"Breaking Bad is the most awesome TV show.",
                                @"Walter White",
                                @"Jesse Pinkman",
                                @"Saul Goodman",
                                @"Mike Ehrmantraut",
                                @"Gustavo Fring",
                                @"Hank Schrader",
                                @"Walter White, Jr."];
floatingCloudsView.randomColors = @[[UIColor whiteColor],
                                    [UIColor grayColor],
                                    [UIColor orangeColor],
                                    [UIColor greenColor],
                                    [UIColor purpleColor]];
floatingCloudsView.randomFonts = @[[UIFont systemFontOfSize:12.0f],
                                   [UIFont systemFontOfSize:14.0f],
                                   [UIFont systemFontOfSize:16.0f],
                                   [UIFont systemFontOfSize:18.0f]];
```

#### Call the show method to show the FloatingCloudsView

```objective-c
[floatingCloudsView show];
```

#### Begin animation

```objective-c
[floatingCloudsView beginAnimation];
```

#### Stop animation

```objective-c
[floatingCloudsView stopAnimation];
```

## To do
- Height automated
- Multilined labels
- Optimize the algorithm of labels' layouts
- More animation types

## Licence
MIT license.
