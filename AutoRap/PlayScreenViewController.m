//
//  PlayScreenViewController.m
//  AutoRap
//
//  Created by Ahmad Karim on 30/06/2014.
//  Copyright (c) 2014 Ahmad Karim. All rights reserved.
//

#import "PlayScreenViewController.h"



#define checkResult(result,operation) (_checkResult((result),(operation),strrchr(__FILE__, '/')+1,__LINE__))
static inline BOOL _checkResult(OSStatus result, const char *operation, const char* file, int line) {
    if ( result != noErr ) {
        int fourCC = CFSwapInt32HostToBig(result);
        NSLog(@"%s:%d: %s result %d %08X %4.4s\n", file, line, operation, (int)result, (int)result, (char*)&fourCC);
        return NO;
    }
    return YES;
}




@interface PlayScreenViewController ()

@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AEAudioFilePlayer *loop1;
@property (nonatomic, strong) AEAudioFilePlayer *loop2;
@property (nonatomic, strong) AEAudioFilePlayer *loop3;

@property (nonatomic, strong) AERecorder *recorder;
@property (nonatomic, strong) AEAudioFilePlayer *player;

@property (nonatomic, strong) AEAudioUnitFilter *reverb;
@property (nonatomic, strong) AEAudioUnitFilter *delay;
@property (nonatomic, strong) AEAudioUnitFilter *reverb2;
@property (nonatomic, strong) AEAudioUnitFilter *timePitchFilter;
@property (nonatomic, strong) AEAudioUnitFilter *gain;




@end

@implementation PlayScreenViewController


- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(MessageChanger) userInfo:nil repeats:YES];
    
    incremetorForTimeSyncing = 0;
    
    
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
    
    
    if (_loop1 == NULL) {
        NSLog(@"loop is null");
    }
    
    _group = [_audioController createChannelGroup];
    [_audioController addChannels:@[self.loop1,self.loop2,self.loop3]];
    
   
    
        NSLog(@"%d",self.trackNumber.intValue);
    
}

-(void) sync1{
    incremetorForTimeSyncing++;
    [_player setCurrentTime:1.50];
    
   
        p*=-1;
   
    NSLog(@"%f",p);
    AudioUnitSetParameter(_timePitchFilter.audioUnit,kNewTimePitchParam_Pitch, 0, kAudioUnitScope_Global, p, 0);
    
    if (incremetorForTimeSyncing == 3) {
        [timer0 invalidate];
    }
    
}

-(void)LastMethod{
    
    BlurImage.hidden=NO;
    TapToResetLabel.hidden=NO;
    lastButton.hidden=NO;
    
    
    [self performSegueWithIdentifier:@"toLastScreen" sender:nil];
    
    _loop1.channelIsMuted=YES;
    _loop2.channelIsMuted=YES;
    _loop3.channelIsMuted=YES;
    [_audioController removeChannels:@[_loop1,_loop2   ,_loop3]];
}



- (IBAction)PlayButton:(UIButton *)sender {
    
   timer0 = [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(sync1)
                                   userInfo:nil
                                    repeats:YES];
   
    
    timer1 = [NSTimer scheduledTimerWithTimeInterval:12.0
                                              target:self
                                            selector:@selector(LastMethod)
                                            userInfo:nil
                                             repeats:NO];
    
    
    
    //============================Delay==================================
    
    if(!_delay){
        self.delay = [[AEAudioUnitFilter alloc] initWithComponentDescription:AEAudioComponentDescriptionMake(kAudioUnitManufacturer_Apple, kAudioUnitType_Effect,kAudioUnitSubType_Delay) audioController:_audioController error:NULL] ;
       // [_audioController addFilter:_delay toChannelGroup:_group];
    }
    checkResult( AudioUnitSetParameter(_delay.audioUnit,kDelayParam_WetDryMix, 0, kAudioUnitScope_Global,50, 0),
                "AudioUnitSetProperty(kDelayParam_WetDryMix)");
    
    NSLog(@"delay stufff called");
    //=============================Reverb======================================
    self.reverb = [[AEAudioUnitFilter alloc] initWithComponentDescription:AEAudioComponentDescriptionMake(kAudioUnitManufacturer_Apple, kAudioUnitType_Effect, kAudioUnitSubType_Reverb2) audioController:_audioController error:NULL];
    
    AudioUnitSetParameter(_reverb.audioUnit, kReverb2Param_MaxDelayTime, kAudioUnitScope_Global, 0, 1.f, 0);
    
    [_audioController addFilter:_reverb toChannelGroup:_group];
    
//  //  self.reverb2=[[AEAudioUnitFilter alloc] initWithComponentDescription:AEAudioComponentDescriptionMake(kAudioUnitManufacturer_Apple, kAudioUnitType_Effect, kAudioUnitSubType_Reverb2)
//                                                         audioController:_audioController error:NULL];
//    
    
    //=============================TIME PITCH FILTER======================================
    
    self.timePitchFilter = [[AEAudioUnitFilter alloc] initWithComponentDescription:AEAudioComponentDescriptionMake(kAudioUnitManufacturer_Apple,
                                                                                                              kAudioUnitType_FormatConverter,
                                                                                                              kAudioUnitSubType_NewTimePitch) audioController:_audioController error:nil];
    AudioUnitSetParameter(self.timePitchFilter.audioUnit,
                          kNewTimePitchParam_Rate,
                          kAudioUnitScope_Global,
                          0,
                          3./3.,
                          0), "";
     p=-400.000002;
  //  AudioUnitSetParameter(_timePitchFilter.audioUnit,kNewTimePitchParam_Pitch, 0, kAudioUnitScope_Global, p, 0);
    
    
    [_audioController addFilter:_timePitchFilter toChannelGroup:_group];
    //====================================================================================
    

     //====================================================================================

    
    if ( _player ) {
        [_audioController removeChannels:@[_player]];
        self.player = nil;
        //        _playButton.selected = NO;
    } else {
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.aiff"];
        
        if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) return;
        
        NSError *error = nil;
        self.player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path] audioController:_audioController error:&error];
        
        
        
        if ( !_player ) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[NSString stringWithFormat:@"Couldn't start playback: %@", [error localizedDescription]]
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil] show];
            return;
        }
        

   //     NSLog(@"Played for 5 seconds %f",_loop1.currentTime);
        
        _player.removeUponFinish = YES;
      //  __weak UIViewController *weakSelf = self;
        _player.completionBlock = ^{
            //            ViewController *strongSelf = weakSelf;
            //            strongSelf->_playButton.selected = NO;
     
        };
        [_audioController addChannels:@[_player] toChannelGroup:_group ];
       
        
        if (self.trackNumber.intValue == 1) {
            // stuff
             _loop1.channelIsMuted = NO;
        }else if (self.trackNumber.intValue==2){
            
            _loop2.channelIsMuted = NO;
            
        }else if (self.trackNumber.intValue == 3){
            
            _loop3.channelIsMuted = NO;
            
        }
        
        
        
        
        NSLog(@"time of track %f ",_player.duration);
     //   [_loop1 setCurrentTime:5.00];
        
    }
    
    

    
}

-(void)MessageChanger{
    
    NSArray *MessageImages = [NSArray arrayWithObjects:@"msg1 31jan.png",@"msg2 31jan.png",@"msg3 31jan.png", nil];
    int index = arc4random() % [MessageImages count];
    
    UIImage *messages =[UIImage imageNamed:[MessageImages objectAtIndex:index]];
    MessagesImageView.image = messages;
    
}

/*
//============================DELAY BLOCK==========================
- (void)delayVolueChanged:(UISlider*)sender {
    
    if(!_delay){
        self.delay = [[AEAudioUnitFilter alloc] initWithComponentDescription:AEAudioComponentDescriptionMake(kAudioUnitManufacturer_Apple, kAudioUnitType_Effect,kAudioUnitSubType_Delay) audioController:_audioController error:NULL] ;
        [_audioController addFilter:_delay];
    }
    checkResult( AudioUnitSetParameter(_delay.audioUnit,kDelayParam_WetDryMix,
                                       0, kAudioUnitScope_Global,
                                       sender.value, 0),
                "AudioUnitSetProperty(kDelayParam_WetDryMix)");
    
    NSLog(@"delay stufff called");
    
}
//=================================================================
*/



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
    // Pass the selected object to the new view controller.

    
}


@end
