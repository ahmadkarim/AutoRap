//
//  FirstScreenViewController.h
//  AutoRap
//
//  Created by Ahmad Karim on 25/07/2014.
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

@interface FirstScreenViewController : UIViewController{
    
    IBOutlet UIButton *PlayButtonOne;
    IBOutlet UIButton *PlayButtonTwo;
    IBOutlet UIButton *PlayButtonThree;
    IBOutlet UIImageView *MessagesImageView;
}

@end
