//
//  CreditsViewController.m
//  Chaos
//
//  Created by Rayan on 15/11/14.
//  Copyright (c) 2014 FNLSpider. All rights reserved.
//

#import "CreditsViewController.h"

@interface CreditsViewController ()
@property (strong, nonatomic) IBOutletCollection(UIVisualEffectView) NSArray *blurred;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation CreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view sendSubviewToBack:self.backgroundImageView];
    
    for(UIVisualEffectView *view in self.blurred)
    {
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
}
}
- (IBAction)icons8linkTapped:(id)sender
{
    NSString* launchUrl = @"http://www.icons8.com/";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
    
}
- (IBAction)bensoundLink:(id)sender
{
    NSString* launchUrl = @"http://www.soundimage.org/";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[GameViewController class]])
    {
        
        GameViewController *gvc = segue.destinationViewController;
        
        [gvc resumeTimer];
        
    }
}@end
