//
//  ViewController.m
//  AutoRap
//
//  Created by Ahmad Karim on 26/06/2014.
//  Copyright (c) 2014 Ahmad Karim. All rights reserved.
//

#import "ViewController.h"
#import "PlayScreenViewController.h"





@interface ViewController ()


@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AEAudioFilePlayer *loop1;

@property (nonatomic, strong) AERecorder *recorder;
@property (nonatomic, strong) AEAudioFilePlayer *player;

//@property (nonatomic,strong) NSNumber * trackNumber;


@end




@implementation ViewController


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    counDownInt=5;
    countdownLabel.font=[countdownLabel.font fontWithSize:25];
    [countdownLabel sizeToFit];
    
 //   [countdownLabel setFont:[UIFont fontWithName:@"Chalkduster" size:46]];
    
    
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(MessageChanger) userInfo:nil repeats:YES];
    
    isRecordButtonPressed=NO;

    
	// Do any additional setup after loading the view, typically from a nib.
    
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
    
   [_audioController addChannels:@[self.loop1]];
    
    NSLog(@"%d",self.trackNumber.intValue);

}

-(void)CountDown{
    counDownInt--;
    countdownLabel.text=[NSString stringWithFormat:@"%d",counDownInt];
    UIImage * image=[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",counDownInt]];
    countDownImageView.image=image;
    
    
    
    if (counDownInt < 0) {
        
        [timer0 invalidate];
        
        [_recorder finishRecording];
        [_audioController removeOutputReceiver:_recorder];
        [_audioController removeInputReceiver:_recorder];
        self.recorder = nil;
        NSLog(@"recorder ended");
        //_recordButton.selected = NO;
        
         [self performSegueWithIdentifier:@"toPlayScreen" sender:nil];
        
    }
    
}


- (IBAction)RecordButton:(UIButton *)sender {
    
    timer0 = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(CountDown)
                                            userInfo:nil
                                             repeats:YES];

    isRecordButtonPressed=!isRecordButtonPressed;
    
    if ( _recorder ) {
        [_recorder finishRecording];
        [_audioController removeOutputReceiver:_recorder];
        [_audioController removeInputReceiver:_recorder];
        self.recorder = nil;
        NSLog(@"recorder ended");
        //_recordButton.selected = NO;
    } else {
        self.recorder = [[AERecorder alloc] initWithAudioController:_audioController];
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.aiff"];
        NSError *error = nil;
        if ( ![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileAIFFType error:&error] ) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[NSString stringWithFormat:@"Couldn't start recording: %@", [error localizedDescription]]
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil] show];
            self.recorder = nil;
            return;
        }
        
       // _recordButton.selected = YES;
        
        [_audioController addOutputReceiver:_recorder];
        [_audioController addInputReceiver:_recorder];
         NSLog(@"recorder created");
    }
    
   
    if (isRecordButtonPressed) {
        
        BlurImage.hidden=NO;
        RecordingLabel.hidden=NO;
        pressAgainLabel.hidden=NO;
        countdownLabel.hidden=NO;
        countDownImageView.hidden=NO;
    }else{
        BlurImage.hidden=YES;
        RecordingLabel.hidden=YES;
        pressAgainLabel.hidden=YES;
        countdownLabel.hidden=YES;
        countDownImageView.hidden=YES;

        
       
    }
    
    
    
}

- (IBAction)PlayButton:(UIButton *)sender {
    
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
        __weak ViewController *weakSelf = self;
        _player.completionBlock = ^{
//            ViewController *strongSelf = weakSelf;
//            strongSelf->_playButton.selected = NO;
            weakSelf.player = nil;
        };
        [_audioController addChannels:@[_player]];
        
       
        
        [_loop1 setCurrentTime:5.00];
        
    }

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
    
    PlayScreenViewController * Pvc = [segue destinationViewController];
    Pvc.trackNumber=self.trackNumber;
    
    // Pass the selected object to the new view controller.
}

@end
