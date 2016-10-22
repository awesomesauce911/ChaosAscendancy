//
//  InstructionsRootViewController.h
//  Chaos
//
//  Created by Rayan on 22/11/14.
//  Copyright (c) 2014 FNLSpider. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstructionsViewController.h"
@interface InstructionsRootViewController : UIViewController <UIPageViewControllerDataSource>


@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;

@end
