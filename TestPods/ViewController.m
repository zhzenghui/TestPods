//
//  ViewController.m
//  TestPods
//
//  Created by xy on 15/8/25.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

#import "AppDelegate.h"

#import "SCVideoPlayerView.h"


#import "SCPlayer.h"
#import "SCImageView.h"


static NSString *DownloadURLString = @"http://m2.pc6.com/mac/OmniGrafflePro.dmg";

@interface ViewController () < NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate>
{
}

@end

@implementation ViewController




-(void)presentNotification{
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        
    }
    
    
    
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"Download Complete!";
    localNotification.alertAction = @"Background Transfer Download!";
    
    //On sound
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //increase the badge number of application plus 1
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    
    
    
    SCPlayer *player = [SCPlayer player];
    
    [player setItemByUrl:[NSURL URLWithString:@"http://pl.youku.com/playlist/m3u8?vid=193000335&type=flv&ts=1441868958&keyframe=0&ep=dyaQG0GLXscF7SPXiz8bYSzjdnZZXP8D9R%2BFgdFhBdQiTuC8&sid=54418689580831260121f&token=6683&ctype=12&ev=1&oip=1981419708"]];
    
    
    // Set the current playerItem using an asset representing the segments
    // of an SCRecordSession
//    [player setItemByAsset:recordSession.assetRepresentingSegments];
//    
    UIView *view = self.view ;//... // Some view that will get the video
    
    // Create and add an AVPlayerLayer
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = view.bounds;

    [view.layer addSublayer:playerLayer];
    
    // Start playing the asset and render it into the view
    [player play];
    
    // Render the video directly through a filter
//    SCImageView *sciv = [[SCImageView alloc] initWithFrame:view.bounds];
//    
//    sciv.filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"];
//    
//    player.CIImageRenderer = sciv;
//    sciv.alpha = .5;
//    
//    [view addSubview:sciv];
    
    //    [self start:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
