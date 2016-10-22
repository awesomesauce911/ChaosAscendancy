//
//  OptionsViewController.h
//  Chaos
//
//  Created by Rayan on 15/11/14.
//  Copyright (c) 2014 FNLSpider. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <StoreKit/StoreKit.h>
#import <AVFoundation/AVFoundation.h>
@interface OptionsViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (strong,nonatomic) AVQueuePlayer *audio;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UIImageView *cash;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *restore;
@property (weak, nonatomic) IBOutlet UIImageView *notAvailable;

@end
