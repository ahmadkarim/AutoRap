//
//  FirstScreenViewController.m
//  AutoRap
//
//  Created by Ahmad Karim on 25/07/2014.
//  Copyright (c) 2014 Ahmad Karim. All rights reserved.
//

#import "FirstScreenViewController.h"
#import "ViewController.h"


@interface FirstScreenViewController ()

@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AEAudioFilePlayer *player;
@property (nonatomic, strong) AEAudioFilePlayer *loop1;
@property (nonatomic, strong) AEAudioFilePlayer *loop2;
@property (nonatomic, strong) AEAudioFilePlayer *loop3;
@property (nonatomic,strong) NSNumber * trackNumber;


@end

@implementation FirstScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(MessageChanger) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
    self.audioController = [[AEAudioController alloc] initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription] inputEnabled:YES];
    _audioController.preferredBufferDuration = 0.005;
    _audioController.useMeasurementMode = YES;
    [_audioController start:NULL];
    
    
    // Create the first loop player
    _loop1 = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Gangster Hip Hop Loop" withExtension:@"mp3"]
                                       audioController:_audioController
                                                 error:NULL];
    _loop1.volume = 1.0;
    _loop1.channelIsMuted = YES;
    _loop1.loop = YES;
    
    
    // Create the second loop player
    _loop2 = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Grind n Teeth" withExtension:@"mp3"]
                                       audioController:_audioController
                                                 error:NULL];
    _loop2.volume = 1.0;
    _loop2.channelIsMuted = YES;
    _loop2.loop = YES;
    
    
    // Create the third loop player
    _loop3 = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"CHeer ful hip hop" withExtension:@"wav"]
                                       audioController:_audioController
                                                 error:NULL];
    _loop3.volume = 1.0;
    _loop3.channelIsMuted = YES;
    _loop3.loop = YES;
    
     [_audioController addChannels:@[self.loop1,self.loop2 ,self.loop3]];
    
    
    
    
}

- (IBAction)Song1:(id)sender {
       NSLog(@"B1");
    
    if (!_loop1.channelIsMuted) {
        _loop1.channelIsMuted=YES;
        UIImage *PlayButton1 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonOne setImage:PlayButton1 forState:UIControlStateNormal];
        UIImage *PlayButton2 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonTwo setImage:PlayButton2 forState:UIControlStateNormal];
        UIImage *PlayButton3 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonThree setImage:PlayButton3 forState:UIControlStateNormal];
        
    }else{
        UIImage *pauseButton2 = [UIImage imageNamed:@"button-02 9Aug.png"];
        [PlayButtonOne setImage:pauseButton2 forState:UIControlStateNormal];
        UIImage *PlayButton2 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonTwo setImage:PlayButton2 forState:UIControlStateNormal];
        UIImage *PlayButton3 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonThree setImage:PlayButton3 forState:UIControlStateNormal];
        _loop1.channelIsMuted=NO;
        _loop2.channelIsMuted=YES;
        _loop3.channelIsMuted=YES;
        
    }
    
    
}

- (IBAction)Song2:(id)sender {
       NSLog(@"B2");
    
    if (!_loop2.channelIsMuted) {
        _loop2.channelIsMuted=YES;
        UIImage *PlayButton2 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonTwo setImage:PlayButton2 forState:UIControlStateNormal];
        UIImage *PlayButton1 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonOne setImage:PlayButton1 forState:UIControlStateNormal];
        UIImage *PlayButton3 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonThree setImage:PlayButton3 forState:UIControlStateNormal];
    }else{
        UIImage *pauseButton2 = [UIImage imageNamed:@"button-02 9Aug.png"];
        [PlayButtonTwo setImage:pauseButton2 forState:UIControlStateNormal];
        UIImage *PlayButton1 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonOne setImage:PlayButton1 forState:UIControlStateNormal];
        UIImage *PlayButton3 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonThree setImage:PlayButton3 forState:UIControlStateNormal];
        _loop1.channelIsMuted=YES;
        _loop2.channelIsMuted=NO;
        _loop3.channelIsMuted=YES;
        
    }
    
    
    
}


- (IBAction)Song3:(id)sender {
    
    NSLog(@"B3");
    
    if (!_loop3.channelIsMuted) {
        _loop3.channelIsMuted=YES;
        UIImage *PlayButton3 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonThree setImage:PlayButton3 forState:UIControlStateNormal];
        UIImage *PlayButton2 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonTwo setImage:PlayButton2 forState:UIControlStateNormal];
        UIImage *PlayButton1 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonOne setImage:PlayButton1 forState:UIControlStateNormal];
    }else{
        UIImage *pauseButton2 = [UIImage imageNamed:@"button-02 9Aug.png"];
        [PlayButtonThree setImage:pauseButton2 forState:UIControlStateNormal];
        UIImage *PlayButton2 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonTwo setImage:PlayButton2 forState:UIControlStateNormal];
        UIImage *PlayButton1 = [UIImage imageNamed:@"play n preview.png"];
        [PlayButtonOne setImage:PlayButton1 forState:UIControlStateNormal];
        _loop1.channelIsMuted=YES;
        _loop2.channelIsMuted=YES;
        _loop3.channelIsMuted=NO;
        
    }
    
    
    
}
- (IBAction)CallSegue:(id)sender {
    
    self.trackNumber=[NSNumber numberWithInt:1];
    [self performSegueWithIdentifier: @"segue1" sender: self];
    _loop1.channelIsMuted=YES;
    _loop2.channelIsMuted=YES;
    _loop3.channelIsMuted=YES;

    
}
- (IBAction)CallSegue2:(id)sender {
     self.trackNumber=[NSNumber numberWithInt:2];
    [self performSegueWithIdentifier: @"segue1" sender: self];
    _loop1.channelIsMuted=YES;
    _loop2.channelIsMuted=YES;
    _loop3.channelIsMuted=YES;

}
- (IBAction)CallSegue3:(id)sender {
    
    _loop1.channelIsMuted=YES;
    _loop2.channelIsMuted=YES;
    _loop3.channelIsMuted=YES;
    
    self.trackNumber=[NSNumber numberWithInt:3];
    [self performSegueWithIdentifier: @"segue1" sender: self];

    

}

-(void)MessageChanger{
    
    NSArray *MessageImages = [NSArray arrayWithObjects:@"msg1 31jan.png",@"msg2 31jan.png",@"msg3 31jan.png", nil];
    int index = arc4random() % [MessageImages count];
    
    UIImage *messages =[UIImage imageNamed:[MessageImages objectAtIndex:index]];
    MessagesImageView.image = messages;
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    
    ViewController * vc = [segue destinationViewController];
    vc.trackNumber=[NSNumber numberWithInt:self.trackNumber.intValue];
    
    _loop1.channelIsMuted=YES;
    _loop2.channelIsMuted=YES;
    _loop3.channelIsMuted=YES;
    
    // Pass the selected object to the new view controller.
}


@end
