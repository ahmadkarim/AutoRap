//
//  ViewController.m
//  AutoRap
//
//  Created by Ahmad Karim on 26/06/2014.
//  Copyright (c) 2014 Ahmad Karim. All rights reserved.
//

#import "ViewController.h"





@interface ViewController ()


@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AEAudioFilePlayer *loop1;


@end




@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
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
    _loop1.channelIsMuted = NO;
    _loop1.loop = YES;
    
    if (_loop1 == NULL) {
        NSLog(@"loop is null");
    }
    
   [_audioController addChannels:@[self.loop1]];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
