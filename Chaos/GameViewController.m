//
//  GameViewController.m
//  Chaos
//
//  Created by Rayan on 15/11/14.
//  Copyright (c) 2014 FNLSpider. All rights reserved.
//

#import "GameViewController.h"
#import "InstructionsViewController.h"
#import "OptionsViewController.h"
#import "PulsingHaloLayer.h"
#import <AudioToolbox/AudioToolbox.h>
@interface GameViewController ()

@property (weak, nonatomic) IBOutlet UIView *main;

@property (strong,nonatomic) NSArray *numbers;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *gameOver;

@property NSInteger points;

@property (nonatomic) NSInteger globalPoints;

@property (strong, nonatomic) IBOutlet UIImageView *life1;


@property (strong, nonatomic) IBOutlet UIImageView *life2;

@property (strong, nonatomic) IBOutlet UIImageView *life3;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewsToGetRounded;
@property (weak, nonatomic) IBOutlet UILabel *bestPoints;

@property (nonatomic) NSInteger board;

@property (nonatomic,strong) AVQueuePlayer *audio;

@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic,strong) UIGravityBehavior *grav;

@end


@implementation GameViewController

#pragma mark Variables

SystemSoundID mySound;
int boardClear = 50;
int TIME_LIMIT = 35;
int lives;
BOOL sound;

#define TIMER_INTERVAL 1
#define Y 16
#define X 16
#define AD_UNIT_ID_TEST @"ca-app-pub-3940256099942544/2934735716"
#define AD_UNIT_ID_RUN @"ca-app-pub-9056427703646491/6010658052"
#define INITIAL_TIME_LIMIT 35
// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
NSUserDefaults *prefs;
NSTimer *t;
NSMutableArray *tappedOrder;
NSMutableArray *music;

BOOL four = YES;

CGRect init1;
CGRect init2;
CGRect init3;


int lastTapped = -1;


#pragma mark VC Lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //   self.minus2.alpha = 0.0f;
    //   self.minus2.layer.cornerRadius = 5;
    //  self.minus2.layer.masksToBounds = YES;
    //   self.plus50.alpha = 0.0f;
    //   self.plus50.layer.cornerRadius = 5;
    //   self.plus50.layer.masksToBounds = YES;
    
    
    
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"GameEnded"];
    [self.main setBackgroundColor:[UIColor clearColor]];
    
    for(UIButton *button in self.buttons)
    {
        [button addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;
        
        
        
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        
        button.exclusiveTouch = YES;
        
        // [self setRoundedView:button toDiameter:button.frame.size.width];
        
    }
    
    
    count = 0;
    self.timerLabel.text = [NSString stringWithFormat:@"%i",TIME_LIMIT];
    
    self.gameOver.center = self.view.center;
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.grav = [[UIGravityBehavior alloc]init];
    lives = 3;
    self.gameOver.alpha = 0.0f;
    self.gameOver.layer.cornerRadius = 15;
    self.gameOver.layer.masksToBounds = YES;
    
    [self.life1 setImage:[UIImage imageNamed:@"Heart1.png"]];
    [self.life2 setImage:[UIImage imageNamed:@"Heart1.png"]];
    [self.life3 setImage:[UIImage imageNamed:@"Heart1.png"]];
    
    
    init1 = self.life1.frame;
    init2= self.life2.frame;
    init3 = self.life3.frame;
    
    self.board = 1;
    self.screenName = @"Game Screen";
    NSURL *mySoundNSURL = [[NSBundle mainBundle] URLForResource:@"s1" withExtension:@"mp3"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)mySoundNSURL, &mySound);
    
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    
    BOOL ads = [storage boolForKey:@"AdsDisabled"];
    NSString  *a = (ads)? @"TRUE":@"FALSE";
    NSLog(@"Ads: %@",a);
    if(ads)
    {
        [self hideAds];
        
     //   [self shiftUp];
    }
    
    else
    {
        self.bannerView.adUnitID = AD_UNIT_ID_RUN;
        self.bannerView.rootViewController = self;
        GADRequest *request = [GADRequest request];
        request.testDevices = @[ GAD_SIMULATOR_ID , @"eec8b8b6c4a3db50fe0cdca0be218dc8"];
        [self.bannerView loadRequest:request];
        
    }
    
    if(([[[NSUserDefaults standardUserDefaults] objectForKey:@"Music"] isEqualToString:@"On"]))
    {
        [self music:YES];
        sound =YES;
    }
    
    else
    {
        [self music:NO];
        sound = NO;
    }
    
    
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    //  NSLog(@"%f",iOSDeviceScreenSize.height);
    
    if (iOSDeviceScreenSize.height != 1024)
    {
        for(UIVisualEffectView *view in self.viewsToGetRounded)
        {
            view.layer.cornerRadius = 7;
            view.layer.masksToBounds = YES;
            
            view.layer.borderColor = [[UIColor blackColor] CGColor];
            view.layer.borderWidth = 2.0f;
        }
        
    }
    else
    {
        for(UIVisualEffectView *view in self.viewsToGetRounded)
        {
            view.layer.cornerRadius = 15;
            view.layer.masksToBounds = YES;
            
            view.layer.borderColor = [[UIColor blackColor] CGColor];
            view.layer.borderWidth = 3.5f;
        }
        
    }
    
    
    
    
    
    
    tappedOrder = [[NSMutableArray alloc]init];
    prefs = [NSUserDefaults standardUserDefaults];
    
    [self updateUI];
    
    
    [prefs synchronize];
    
    [self resetGame];
    
    // [self loseLife];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [prefs synchronize];
    
    
}


-(void)resumeTimer
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"GameEnded"])
    {
        [t invalidate];
        t = nil;
        
        NSDate *startNewCapture = [NSDate date];
        t = [[NSTimer alloc]initWithFireDate:startNewCapture
                                    interval:TIMER_INTERVAL
                                      target:self
                                    selector:@selector(fired:)
                                    userInfo:nil
                                     repeats:YES];
        NSRunLoop *runLoop = [NSRunLoop mainRunLoop];
        [runLoop addTimer:t forMode:NSDefaultRunLoopMode];
        
        //  NSLog(@"New timer");
        
    }
}




#pragma mark Game Methods
NSMutableArray *buttonArray;
-(void)resetGame
{
    //PRESENT NEXT GAME
    tappedOrder = nil;
    
    tappedOrder = [[NSMutableArray alloc]init];
    
    
    [self resumeTimer];
    
    buttonArray = [NSMutableArray arrayWithArray:self.buttons];
    
    [buttonArray shuffle];
    
    
    
    int limit = (four)? 16 : 25;
    //int limit = [[self.numbers lastObject   ] intValue];
    // int c = 0;
    for(int i = 0; i<limit; i++)
        //for(NSNumber *x in self.numbers)
    {
        
        UIButton *button = buttonArray[i];
        
        [button setTitle:[NSString stringWithFormat:@"%i",i+1] forState:UIControlStateNormal];
        button.tag =i+1;
        [button addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor whiteColor]];
        //    c++;
        button.enabled = YES;
    }
    
    
    
    
    
    
}
int count;

-(void)fired:(NSTimer *)t
{
    
    count++;
    
    if(count!=TIME_LIMIT)
        self.timerLabel.text = [NSString stringWithFormat:@"%i",(TIME_LIMIT-count)];
    else
    {
        self.timerLabel.text = [NSString stringWithFormat:@"%i",TIME_LIMIT];
        count = 0;
        [self tappedWrongButton:nil];
    }
    
}

-(void)hideAds
{
    [self.bannerView setHidden:YES];
    self.bannerView = nil;
    
    
    // NSLog(@"Hiding ads");
}



-(IBAction)tappedButton:(id)sender
{
    
    BOOL m = [[NSUserDefaults standardUserDefaults] boolForKey:@"GameEnded"];
    
    if(!m)
    {
        
        if([sender isKindOfClass:[UIButton class]])
        {
            [self playButtonSound];
            
            [self updateBest];
            
            UIButton *s = (UIButton *)sender;
            
            
            
            
            
            
            
            //   if(s.tag > lastTapped)
            //    {
            //        lastTapped = s.tag;
            //        [UIView animateWithDuration:0.3
            //                         animations:^
            //        {
            //            [s setBackgroundColor:[UIColor greenColor]];
            //        }];
            //
            //        s.enabled = NO;
            //
            //       if(s.tag != [[self.numbers lastObject] intValue])
            //        {
            ////            [self tappedRightButton:NO];
            //       }
            //
            //       else
            //      {
            //           [self tappedRightButton:YES];
            //         [UIView animateWithDuration:0.3
            //                        animations:^
            //      {
            //        [s setBackgroundColor:[UIColor redColor]];
            //            }];
            //      }
            
            
            //     }
            
            //  else
            //      {
            //           [self tappedWrongButton:s];
            //         lastTapped = -1;
            //     }
            
            
            
            
            [tappedOrder addObject:@(s.tag)];
            
            // NSLog(@"Tapped order: %@",tappedOrder);
            if([tappedOrder isEqualToArray:[self.numbers subarrayWithRange:NSMakeRange(0, s.tag)]])
            {
                
                [UIView animateWithDuration:0.3 animations:^{
                    [(UIButton *)(buttonArray[s.tag-1]) setBackgroundColor:[UIColor greenColor]];
                }];
                
                s.enabled = NO;
                
                if([[tappedOrder lastObject] intValue] != [[self.numbers lastObject] intValue])
                {
                    [self tappedRightButton:NO];
                }
                
                else
                {
                    [self tappedRightButton:YES];
                }
            }
            
            else
            {
                [self tappedWrongButton:s];
            }
        }
        
    }
    
    
}
PulsingHaloLayer *halo;
-(void)tappedRightButton:(BOOL)last
{
    if(!last)
    {
        self.points+=5;
        self.pointsLabel.text = [NSString stringWithFormat:@"%li",(long)self.points];
        [prefs setObject:@(self.globalPoints+self.points) forKey:@"ChaosPoints"];
        
        
    }
    
    else
    {
        [t invalidate];
        t= nil;
        //UIButton *temp = [self.buttons lastObject];
        
        //NSLog(@"Last");
        //[temp setBackgroundColor:[UIColor greenColor]];
        halo = nil;
        halo = [PulsingHaloLayer layer];
        count = 0;
        
        
        halo.position = self.main.center;
        halo.radius = 500;
        
        halo.backgroundColor = [UIColor blueColor].CGColor;
        
        halo.pulseInterval = 0.05;
        
        [self.view.layer addSublayer:halo];
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(goToNext) userInfo:nil repeats:NO];
        
    }
    
}

-(void)goToNext
{
    
    self.points+=boardClear;
    
    //  [UIView animateWithDuration:1.0
    //                   animations:^
    //  {
    
    //       self.plus50.text = [NSString stringWithFormat:@"%i",boardClear];
    //     self.plus50.alpha = 1.0f;
    //    self.plus50.center = CGPointMake(self.plus50.center.x,self.plus50.center.y+20);
    
    //  }
    //                   completion:^(BOOL finished)
    //  {
    //      self.plus50.alpha = 0.0f;
    //       self.plus50.center = CGPointMake(self.plus50.center.x,self.plus50.center.y-20);
    //  }];
    
    
    boardClear+=50;
    self.board++;
    
    
    TIME_LIMIT-=2;
    //PRESENT RIGHT ANSWER
    
    self.timerLabel.text = [NSString stringWithFormat:@"%i",TIME_LIMIT];
    
    //  [/UIView animateWithDuration:1.0
    //              animations:^
    //   {
    //       self.minus2.alpha = 1.0f;
    //       self.minus2.center = CGPointMake(self.minus2.center.x, /self.minus2.center.y+20);
    //
    //   }
    //                    completion:^(BOOL finished)
    //   {
    
    //       self.minus2.alpha = 0.0f;
    //       self.minus2.center = CGPointMake(self.minus2.center.x, //self.minus2.center.y-20);
    //  }];
    
    
    halo.radius = 0.0f;
    
    halo = nil;
    
    //  [UIView animateWithDuration:2.0 animations:^{
    [self resetGame];
    //}];
    
    
    self.pointsLabel.text = [NSString stringWithFormat:@"%li",(long)self.points];
    /// [prefs setObject:[NSNumber numberWithInteger:(self.globalPoints+self.points)] forKey:@"ChaosPoints"];
    
}


-(void)tappedWrongButton:(UIButton *)last
{
    [t invalidate];
    t=nil;
    
    for(UIButton *x in self.buttons)
        x.enabled = NO;
    
    
    [self loseLife];
    if(last!=nil)
    {
        [UIView animateWithDuration:1.0
                         animations:^
         {
             
             [last setBackgroundColor:[UIColor redColor]];
             
         }
                         completion:^(BOOL finished)
         {
             self.timerLabel.text = [NSString stringWithFormat:@"%i",TIME_LIMIT];
             [self updateUI];
             
             [self resetGame];
             
         }];
        
        
        
        
    }
    
    else
        
    {
        // TIMER ENDED SCREEN
        self.timerLabel.text = [NSString stringWithFormat:@"%i",TIME_LIMIT];
        
        
        
        
        //    [self resumeTimer];
        
        self.points = 0;
        self.pointsLabel.text = @"0";
        
        self.board = 1;
        //DISPLAY IMAGE VIEW
        
        //      [t invalidate];
        //     t = nil;
        //
        boardClear = 50;
        
        //PRESENT WRONG ANSWER
        
        [self updateUI];
        
        [self resetGame];
        
        
        
    }
    
    
}



- (IBAction)settingsTapped:(id)sender
{
    
   // [self performSegueWithIdentifier:@"segueToOptions" sender:sender];
    
    
    [t invalidate];
    t=nil;
    
    
}
- (IBAction)helpTapped:(id)sender
{
    [self performSegueWithIdentifier:@"segueToInstructions" sender:sender];
    
    [t invalidate];
    t=nil;
    
    
    
}

- (IBAction)aboutTapped:(id)sender
{
    [self performSegueWithIdentifier:@"segueToAbout" sender:sender];
    [t invalidate];
    t=nil;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.destinationViewController isKindOfClass:[OptionsViewController class]])
    {
        
        OptionsViewController *ovc = (OptionsViewController *)segue.destinationViewController;
        
        ovc.audio = self.audio;
        
        
    }
    
    
}

#pragma mark Instantiators

-(NSArray *)numbers
{
    
    if(four)
        _numbers = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16];
    else
        _numbers = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25];
    
    
    //     NSMutableArray *n = [[NSMutableArray alloc]init];
    //     for (int i = 1; i<100; i++) {
    //       NSNumber* t = [NSNumber numberWithInt:i];
    //            [n addObject:t];
    //      }
    //    [n shuffle];
    //  _numbers = [n subarrayWithRange:NSMakeRange(0, 16)];
    
    //  NSArray *sortedArray;
    //sortedArray = [_numbers sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
    //         NSNumber *f = a;
    //          NSNumber *s = b;
    
    //          return [f compare:s];
    //      }];
    
    //      _numbers = sortedArray;
    
    //og(@"%@",_numbers);
    return _numbers;
}

-(NSInteger)globalPoints
{
    
    
    if(!_globalPoints)
    {
        _globalPoints = [[prefs objectForKey:@"ChaosPoints"] intValue];
        
    }
    
    return _globalPoints;
    
}


-(void)updateUI
{
    
    self.bestPointsLabel.text = [NSString stringWithFormat:@"%li",(long)[prefs integerForKey:@"BestPoints"]];
    self.pointsLabel.text = [NSString stringWithFormat:@"%li",(long)self.points];
    
    
}

-(void)updateBest
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSInteger bestPoints = [prefs integerForKey:@"BestPoints"];
    
    if(self.points>bestPoints)
        [prefs setInteger:self.points forKey:@"BestPoints"];
    
    NSInteger bestBoard = [prefs integerForKey:@"BestBoard"];
    
    if(self.board>bestBoard)
        [prefs setInteger:self.board forKey:@"BestBoard"];
    
    
    [self updateUI];
}


-(void)resignActive
{
    [self.audio pause];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ResignedActive"];
    [t invalidate];
    t = nil;
}


-(void)regainActive:(BOOL)y
{
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ResignedActive"])
    {
        [self resumeTimer];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ResignedActive"];
        if(y)
            [self.audio play];
    }
    
    
    
}


-(void)playButtonSound
{
    if(sound)
        AudioServicesPlaySystemSound(mySound);
    
}

int origH;
int origW ;
-(void)loseLife
{
    UIView *life;
    switch(lives)
    {
        case 1:
            life = self.life1;
            break;
        case 2:
            life = self.life2;
            break;
        case 3:
            life = self.life3;
            break;
        default:
            life = nil;
            break;
            
    }
    //NSLog(@"View: %@",life);
    
    [self.grav addItem:life];
    
    [t invalidate];
    t= nil;
    self.timerLabel.text = [NSString stringWithFormat:@"%i",TIME_LIMIT];
    
    count = 0;
    
    [_grav setMagnitude:0.5];
    [self.animator addBehavior:self.grav];
    
    // NSLog(@"Animaor %@ Grav %@",self.animator,self.grav);
    
    // NSLog(@"Animated");
    lives--;
    if(lives==0)
    {
        for(UIButton *b in self.buttons)
            b.enabled = NO;
        [self endGame];
        
    }
    
}


-(void)endGame
{
    
    
    
    //NSLog(@"BUtton %@", self.buttons[0]);
    
    for(UIButton *b in self.buttons)
        b.enabled = NO;
    
    lives = 3;
    [self.view bringSubviewToFront:self.gameOver];
    [t invalidate];
    t = nil;
    
    // NSLog(@"Timer 1 %@",t);
    
    [UIView animateWithDuration:1.0 animations:^
     {
         self.gameOver.alpha = 1.0;
         
         self.points = 0;
         self.pointsLabel.text = @"0";
         
         boardClear = 50;
         self.board = 1;
         
         
     }];
    
    // NSLog(@"Timer 2 %@",t);
    [t invalidate];
    t = nil;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GameEnded"];
    
}
- (IBAction)continueGame:(id)sender
{
    
    //  if(((UIButton *)self.buttons[0]).enabled == YES)
    //      NSLog(@"ENABLED");
    //  else
    //      NSLog(@"BUTTON NOT ENABLED");
    [self.grav removeItem:self.life1];
    [self.grav removeItem:self.life2];
    [self.grav removeItem:self.life3];
    [UIView animateWithDuration:1.5 animations:^{
        self.gameOver.alpha = 0.0;
        
        self.life1.hidden = YES;
        self.life1 = nil;
        
        UIImageView *l1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Heart1.png"]];
        l1.frame = init1;
        [self.view addSubview:l1];
        self.life1 = l1;
        
        self.life2.hidden = YES;
        self.life2 = nil;
        
        
        UIImageView *l2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Heart1.png"]];
        l2.frame = init2;
        [self.view addSubview:l2];
        self.life2 = l2;
        
        self.life3.hidden = YES;
        self.life3 = nil;
        
        UIImageView *l3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Heart1.png"]];
        l3.frame = init3;
        [self.view addSubview:l3];
        self.life3 = l3;
        
        
    }];
    [t invalidate];
    t= nil;
    self.timerLabel.text = [NSString stringWithFormat:@"%i",TIME_LIMIT];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"GameEnded"];
    
    
    count = 0;
    
    TIME_LIMIT = INITIAL_TIME_LIMIT;
    
    [self resetGame];
    
    
}

#pragma mark Music


- (void)music:(BOOL)on
{
    
    
    music = [[NSMutableArray alloc] initWithObjects:
             [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:@"BM1" withExtension:@"mp3"]],
             [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:@"BM2" withExtension:@"mp3"]],
             [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:@"BM3" withExtension:@"mp3"]],
             [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:@"BM4" withExtension:@"mp3"]],
             [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:@"BM5" withExtension:@"mp3"]],
             [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:@"BM6" withExtension:@"mp3"]],
             [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:@"BM7" withExtension:@"mp3"]],
             [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:@"BM8" withExtension:@"mp3"]],

             nil];
    
    
    for(AVPlayerItem *a in music)
    {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:a];
        
    }
    
    [music shuffle];
    
    self.audio  = [[AVQueuePlayer alloc]initWithItems:music];
    
    if(on)
        [self.audio play];
    
    
    
    
    //   NSLog(@"Now playing%@",[self.audio currentItem]);
    
    //   NSLog(@"%@",self.audio);
    
    
    
    
    
    
    
    
    
}
-(void)playerItemFinished:(NSNotification *)notification
{
    if([[self.audio currentItem] isEqual:[music lastObject]])
    {
        
        self.audio = nil;
        
        [music shuffle];
        
        self.audio = [[AVQueuePlayer alloc]initWithItems:music];
        
        
        [self.audio play];
        
    }
    
}

#pragma mark Utility

-(NSTimer *)getTimer
{
    return t;
    
    
    
}

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (IBAction)unwindToGameViewController:(UIStoryboardSegue *)unwindSegue
{
}
@end
