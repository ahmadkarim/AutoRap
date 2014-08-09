//
//  PlayScreenViewController.h
//  AutoRap
//
//  Created by Ahmad Karim on 30/06/2014.
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

@interface PlayScreenViewController : UIViewController{
   
    AEChannelGroupRef _group;
    NSTimer * timer0;
    NSTimer * timer1;
    int incremetorForTimeSyncing;
    Float32 p;
   
    __weak IBOutlet UIButton *lastButton;
    
    __weak IBOutlet UIImageView *BlurImage;
    __weak IBOutlet UILabel *TapToResetLabel;
}
@property (nonatomic,strong) NSNumber * trackNumber;

@end
