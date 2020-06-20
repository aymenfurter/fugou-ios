//
//  ViewController.m
//  Fugou
//
//  Created by Aymen Furter on 17.06.20.
//  Copyright © 2020 Aymen Furter. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "AudioToolbox/AudioServices.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIImageView *fish;
@property (weak, nonatomic) IBOutlet UILabel *textTitle;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@end

Boolean lastStatus = NO;


@implementation ViewController

- (void)viewDidLoad {
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Launched"]) {
      
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Welcome to Fugou"
                                   message:@"Hello and welcome to Fugou. As long as you keep this app open, Fugou will continously monitor for nearby devices. In case a certain threshold is reached, it will alert you by vibration. You can't use any other bluetooth based peripherals with Fugou (e.g. bluetooth headset) "
                                   preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {}];

        [alert addAction:defaultAction];
        NSLog(@"showing alert");
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alert animated:YES completion:nil];
        });

       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Launched"];
       [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    }

    - (void)timer:(NSTimer *)timer
    {
       AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if ([appDelegate isSafe]){
            lastStatus = YES;
            [_textTitle setText:@"You are fine!"];
            [_desc setText: @"There are no people around you."];
            [_fish setImage:[UIImage imageNamed:@"ok"]];
            [_background setImage:[UIImage imageNamed:@"bg"]];
            [self.view setNeedsDisplay];
        } else {
            if (lastStatus == YES) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                lastStatus = NO;
            }

            [_background setImage:[UIImage imageNamed:@"bg.bad"]];
            [_fish setImage:[UIImage imageNamed:@"fugou"]];
            [_textTitle setText:@"Danger"];
            [_desc setText: @"Too many people around you"];
            [self.view setNeedsDisplay];
        }
    }



@end
