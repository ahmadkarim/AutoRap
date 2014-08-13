//
//  SplashScreenViewController.m
//  AutoRap
//
//  Created by Nauman on 09/08/2014.
//  Copyright (c) 2014 Ahmad Karim. All rights reserved.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

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
   // [self MessageChanger];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)MessageChanger{
    
    NSArray *MessageImages = [NSArray arrayWithObjects:@"msg1 31jan.png",@"msg2 31jan.png",@"msg3 31jan.png", nil];
    int index = arc4random() % [MessageImages count];
    
    UIImage *messages =[UIImage imageNamed:[MessageImages objectAtIndex:index]];
    MessagesImageView.image = messages;
    
}
@end
