//
//  GameViewController.h
//  Chaos
//
//  Created by Rayan on 15/11/14.
//  Copyright (c) 2014 FNLSpider. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSMutableArray+Shuffling.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "GAITrackedViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "OptionsViewController.h"

@interface GameViewController : GAITrackedViewController
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

//@property (weak, nonatomic) IBOutlet UILabel *minus2;

//@property (weak, nonatomic) IBOutlet UILabel *plus50;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *infoViews;


@property (nonatomic) NSDate *oldTime;
@property (weak, nonatomic) IBOutlet UILabel *bestPointsLabel;

@property BOOL first;

-(void)resumeTimer;
@property (NS_NONATOMIC_IOSONLY, getter=getTimer, readonly, strong) NSTimer *timer;
-(void)resignActive;
-(void)regainActive:(BOOL)y;
-(void)hideAds;
@end