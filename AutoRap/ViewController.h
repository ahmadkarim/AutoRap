//
//  ViewController.h
//  AutoRap
//
//  Created by Ahmad Karim on 26/06/2014.
//  Copyright (c) 2014 Ahmad Karim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheAmazingAudioEngine.h"
#import "AEPlaythroughChannel.h"
#import "AEExpanderFilter.h"
#import "AELimiterFilter.h"
#import "AERecorder.h"
#import <QuartzCore/QuartzCore.h>
#import <AEAudioController.h>

@interface ViewController : UIViewController{
    
    BOOL isRecordButtonPressed;
    __weak IBOutlet UIImageView *BlurImage;
    __weak IBOutlet UILabel *RecordingLabel;
    
    __weak IBOutlet UILabel *pressAgainLabel;
    
    IBOutlet UIImageView *MessagesImageView;
    __weak IBOutlet UILabel *countdownLabel;
    int counDownInt;
     NSTimer * timer0;
    
    __weak IBOutlet UIImageView *countDownImageView;
    
}
@property (nonatomic,strong) NSNumber * trackNumber;

@end
