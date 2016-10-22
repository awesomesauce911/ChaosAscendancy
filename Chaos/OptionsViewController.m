//
//  OptionsViewController.m
//  Chaos
//
//  Created by Rayan on 15/11/14.
//  Copyright (c) 2014 FNLSpider. All rights reserved.
//

#import "OptionsViewController.h"
#import "GameViewController.h"
@interface OptionsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *musicButton;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blur;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *closeBlur;
@property (weak, nonatomic) IBOutlet UIButton *disableAdsButton;

@property (strong,nonatomic) NSArray *products;
@end

@implementation OptionsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
    self.disableAdsButton.enabled = NO;
    self.restore.enabled = NO;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    self.cash.alpha = 0.0f;
    self.activity.hidesWhenStopped = YES;
    [self validateProductIdentifiers:@[@"chaos.noads"]];

    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    
    if(![storage boolForKey:@"AdsDisabled"])
        self.notAvailable.alpha = 1.0f;
    else{
        self.notAvailable.hidden = YES;
        
    }
    self.blur.layer.cornerRadius = 5;
    self.blur.layer.masksToBounds = YES;
    self.closeBlur.layer.cornerRadius = 5;
    self.closeBlur.layer.masksToBounds = YES;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *music = [prefs objectForKey:@"Music"];
    
    if([music isEqualToString:@"On"])
    {
        [self.musicButton setBackgroundImage:[UIImage imageNamed:@"SpeakerOn.png"] forState:UIControlStateNormal];
        self.musicButton.tag = 0;
        
        if(!(self.audio.rate > 0  && !self.audio.error))
        {
            [self.audio play];
            
        }
        
    }
    else
    {
        
        [self.musicButton setBackgroundImage:[UIImage imageNamed:@"SpeakerOff.png"] forState:UIControlStateNormal];
        self.musicButton.tag = 1;
        
    
        if((self.audio.rate > 0  && !self.audio.error))
        {
            [self.audio pause];
            
        }
        
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"AdsDisabled"] == YES)
    {
        [self disabled];
        self.restore.hidden = YES;
        
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)musicToggled:(id)sender
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if(self.musicButton.tag ==0)
    {
        [self.musicButton setBackgroundImage:[UIImage imageNamed:@"SpeakerOff.png"] forState:UIControlStateNormal];
        
        [prefs setObject:@"Off" forKey:@"Music"];
        
        self.musicButton.tag= 1;
        
        [self.audio pause];
        
        //write music off
        
    }
    else
    {
        
        [self.musicButton setBackgroundImage:[UIImage imageNamed:@"SpeakerOn.png"] forState:UIControlStateNormal];
        
        [prefs setObject:@"On" forKey:@"Music"];
        
        self.musicButton.tag= 0;

        
        [self.audio play];
        
        
    }

    
    
}
- (IBAction)restorePurchases:(id)sender
{
 
    [UIView animateWithDuration:1.0
                     animations:^
     {
         self.cash.alpha = 1.0;
         
     }
                     completion:nil];
    [self.activity startAnimating];
    
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
}

- (IBAction)disableAds:(id)sender
{
    [UIView animateWithDuration:1.0
                     animations:^
    {
        self.cash.alpha = 1.0;
    
    }
                     completion:nil];
    [self.activity startAnimating];
    
    if(self.products[0])
    {
    SKProduct *product = self.products[0];
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
}

-(void)disabled
{
    self.disableAdsButton.enabled = NO;
    self.restore.enabled = NO;

    [self.disableAdsButton setTitle:@"No More Ads :)" forState:UIControlStateNormal];
    [self.disableAdsButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AdsDisabled"];
    self.restore.hidden = YES;
    
    
    
    
    [self hideCash];
}

-(void)hideCash
{
    
    [UIView animateWithDuration:1.0
                     animations:^
     {
         self.cash.alpha = 0.0;
         
     }
                     completion:nil];
    [self.activity stopAnimating];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[GameViewController class]])
    {
        
        GameViewController *gvc = segue.destinationViewController;
        
        [gvc resumeTimer];
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"AdsDisabled"] )
        {
            [gvc hideAds];
        }
        
    }
}
-(void)hideAds
{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setBool:YES forKey:@"AdsDisabled"];
    
    [storage synchronize];
    
    
    
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    [store setBool:YES forKey:@"AdsDisabled"];
    [store synchronize];
    
    
    [self disabled];
    if([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[GameViewController class]])
    {
        GameViewController *gvc = (GameViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [gvc hideAds];
        
    }
}

#pragma mark In App Purchases

// Custom method
- (void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        NSLog(@"Invalid identifier: %@",invalidIdentifier);
    }
    

    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];

    
    BOOL ads = [storage boolForKey:@"AdsDisabled"];
    if(!ads)
    {
        self.disableAdsButton.enabled = YES;
        self.restore.enabled = YES;

        [UIView animateWithDuration:1.0 animations:^{ self.notAvailable.alpha = 0.0f; }];
        

    SKProduct *product = response.products[0];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
    
    
    if(![[NSString stringWithFormat:@"Disable Ads (%@)",formattedPrice] isEqualToString:self.disableAdsButton.titleLabel.text])
    {
        [UIView animateWithDuration:1.0 animations:^{
            [self.disableAdsButton setTitle:[NSString stringWithFormat:@"Disable Ads (%@)",formattedPrice] forState:UIControlStateNormal];
        
        }];
    }
    }
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue
 updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing:
                [self showTransactionAsInProgress:transaction deferred:NO];
                break;
            case SKPaymentTransactionStateDeferred:
                [self showTransactionAsInProgress:transaction deferred:YES];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                // For debugging
                NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
                break;
        }
    }
}

-(void)showTransactionAsInProgress:(SKPaymentTransaction *)transaction deferred:(BOOL)deferred
{
    
    if(!self.activity.isAnimating)
       [self.activity startAnimating];
}

-(void)failedTransaction: (SKPaymentTransaction *)transaction
{
    [[[UIAlertView alloc] initWithTitle:@"Failed" message:@"Your transaction has failed. Please check your account details, account balance, and internet connection" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self hideCash];
    

}

-(void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

    [[[UIAlertView alloc] initWithTitle:@"Successful Purchase" message:@"Thank you for your purchase :)" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
    
    

    [self hideAds];
    [self hideCash];

}
-(void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    if(transaction)
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

    [[[UIAlertView alloc] initWithTitle:@"Successful Restore" message:@"Your purchase has been restored successfully" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
    
    [self hideAds];
    [self hideCash];

    
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"Error restoring: %@",error);
    [self hideCash];
    
    [[[UIAlertView alloc] initWithTitle:@"Failed Restore" message:@"Sorry, your purchase could not be restored" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
    
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [self restoreTransaction:nil];
    [self hideCash];

    
}



@end
