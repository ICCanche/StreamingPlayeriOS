//
//  ViewController.m
//  radio_player
//
//  Created by Irvin Geovani Chan Canché on 09/09/16.
//  Copyright © 2016 iccanche. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "AVFoundation/AVFoundation.h"
@import MediaPlayer;

@interface ViewController ()
- (IBAction)playButton:(id)sender;
- (IBAction)stopButton:(id)sender;
- (IBAction)secondViewButton:(id)sender;

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
    MPNowPlayingInfoCenter* mpic = [MPNowPlayingInfoCenter defaultCenter];
    mpic.nowPlayingInfo = @{
                            MPMediaItemPropertyTitle:@"Radio",
                            MPMediaItemPropertyArtist:@"Streaming"
                            };
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];

}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (IBAction)playButton:(id)sender {
    if (![self isPlaying]) {
        [self playAudio];
    }
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            if (![self isPlaying]) {
             [self playAudio];
            } else {
             [self stopAudio];
            }
            NSLog(@"El audio se esta reproduciendo");
            break;
        case UIEventSubtypeRemoteControlPause:
            NSLog(@"Se ha detenido el audio");
            [self stopAudio];
            break;
        default:
            break;
    }
}

- (IBAction)stopButton:(id)sender {
    [self stopAudio];
}

- (IBAction)secondViewButton:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SecondViewController *secondVC = [storyboard instantiateViewControllerWithIdentifier:@"secondVC"];
    [self presentViewController:secondVC animated:YES completion:nil];
}
-(void) playAudio {
    NSString *urlRadio = @"http://demo.castdemo.centova.com:25000/stream";
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:urlRadio]];
    
    AVPlayerItem *playerItem1 = [AVPlayerItem playerItemWithAsset:asset];
    _player = [AVPlayer playerWithPlayerItem:playerItem1];
 
    
    [self setAudioSession];
    
    [_player play];

}

-(void) stopAudio {
    [_player setRate:0.0];
}

-(BOOL)isPlaying {
    if ([_player rate] != 0.0)
        return YES;
    else
        return NO;
}

-(void) setAudioSession {
    
    NSError *categoryError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                           error:&categoryError];
    
    if (categoryError!=nil) {
        NSLog(@"%@",categoryError.description);
    }
    
    NSError *activateError = nil;
    
    [[AVAudioSession sharedInstance] setActive:TRUE error:&activateError];
    
    if (activateError!=nil){
        NSLog(@"%@",activateError.description);
    }

}

@end
