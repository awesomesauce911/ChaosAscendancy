//
//  InstructionsRootViewController.m
//  Chaos
//
//  Created by Rayan on 22/11/14.
//  Copyright (c) 2014 FNLSpider. All rights reserved.
//

#import "InstructionsRootViewController.h"

@interface InstructionsRootViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *toBeRounded;


@end

@implementation InstructionsRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *device = [[NSUserDefaults standardUserDefaults] objectForKey:@"Device"];
    
    if(![device isEqualToString:@"iPad"])
        _pageImages = @[@"ipg1",@"ipg2",@"ipg3",@"ipg4"];
    else
        _pageImages = @[@"pg1",@"pg2",@"pg3",@"pg4"];

    
    for(UIView *v in self.toBeRounded)
    {
        
        v.layer.cornerRadius =5;
        v.layer.masksToBounds = YES;
    }
    
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    InstructionsViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((InstructionsViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((InstructionsViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageImages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

-(InstructionsViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    InstructionsViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.pageIndex = index;
    
  
    
    return pageContentViewController;
}
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageImages count];
}
- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE
    
    for (UIView *subview in subviews) {
        
        // Do what you want to do with the subview
        subview.hidden = NO;
        
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
