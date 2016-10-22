//
//  InstructionsViewController.m
//  Chaos
//
//  Created by Rayan on 15/11/14.
//  Copyright (c) 2014 FNLSpider. All rights reserved.
//

#import "InstructionsViewController.h"
#import "GameViewController.h"
@interface InstructionsViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *closeBlur;

@end

@implementation InstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self performSelectorInBackground:@selector(<#selector#>) withObject:self];
    
    self.closeBlur.layer.cornerRadius = 5;
    self.closeBlur.layer.masksToBounds = YES;
    self.screenName = @"Instructions Screen";
    
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[GameViewController class]])
    {
        
        GameViewController *gvc = segue.destinationViewController;
        
        [gvc resumeTimer];
        
    }
}


@end
