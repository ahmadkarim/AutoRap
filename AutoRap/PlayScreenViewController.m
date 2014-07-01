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

@property (nonatomic, strong) AERecorder *recorder;
@property (nonatomic, strong) AEAudioFilePlayer *player;

@property (nonatomic, strong) AEAudioUnitFilter *reverb;
@property (nonatomic, strong) AEAudioUnitFilter *delay;
@property (nonatomic, strong) AEAudioUnitFilter *reverb2;




@end

@implementation PlayScreenViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.audioController = [[AEAudioController alloc] initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription] inputEnabled:YES];
    _audioController.preferredBufferDuration = 0.005;
    _audioController.useMeasurementMode = YES;
    [_audioController start:NULL];
    
    
    // Create the first loop player
    _loop1 = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Gangster hip hop" withExtension:@"mp3"]
                                       audioController:_audioController
                                                 error:NULL];
    _loop1.volume = 1.0;
    _loop1.channelIsMuted = YES;
    _loop1.loop = YES;
    
    if (_loop1 == NULL) {
        NSLog(@"loop is null");
    }
    
    _group = [_audioController createChannelGroup];
    [_audioController addChannels:@[self.loop1]];
    
   
    
}


- (IBAction)PlayButton:(UIButton *)sender {
    
    //============================Delay==================================
    
    if(!_delay){
        self.delay = [[AEAudioUnitFilter alloc] initWithComponentDescription:AEAudioComponentDescriptionMake(kAudioUnitManufacturer_Apple, kAudioUnitType_Effect,kAudioUnitSubType_Delay) audioController:_audioController error:NULL] ;
        [_audioController addFilter:_delay toChannelGroup:_group];
    }
    checkResult( AudioUnitSetParameter(_delay.audioUnit,kDelayParam_WetDryMix, 0, kAudioUnitScope_Global,50, 0),
                "AudioUnitSetProperty(kDelayParam_WetDryMix)");
    
    NSLog(@"delay stufff called");
    //=============================Reverb======================================
    self.reverb = [[AEAudioUnitFilter alloc] initWithComponentDescription:AEAudioComponentDescriptionMake(kAudioUnitManufacturer_Apple, kAudioUnitType_Effect, kAudioUnitSubType_Reverb2) audioController:_audioController error:NULL];
    
    AudioUnitSetParameter(_reverb.audioUnit, kReverb2Param_MaxDelayTime, kAudioUnitScope_Global, 0, 1.f, 0);
    
    [_audioController addFilter:_reverb toChannelGroup:_group];
    
    self.reverb2=[[AEAudioUnitFilter alloc] initWithComponentDescription:AEAudioComponentDescriptionMake(kAudioUnitManufacturer_Apple, kAudioUnitType_Effect, kAudioUnitSubType_Reverb2)
                                                         audioController:_audioController error:NULL];
    
    
    //===================================================================
    
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
        
        if (_loop1.currentTime == 5 ) {
            NSLog(@"Played for 5 seconds %f",_loop1.currentTime);
        }
        
        NSLog(@"Played for 5 seconds %f",_loop1.currentTime);
        
        _player.removeUponFinish = YES;
      //  __weak UIViewController *weakSelf = self;
        _player.completionBlock = ^{
            //            ViewController *strongSelf = weakSelf;
            //            strongSelf->_playButton.selected = NO;
     
        };
        [_audioController addChannels:@[_player] toChannelGroup:_group ];
        _loop1.channelIsMuted = NO;
        
        
        
     //   [_loop1 setCurrentTime:5.00];
        
    }
    
    

    
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
    _loop1.channelIsMuted=YES;
}


@end
