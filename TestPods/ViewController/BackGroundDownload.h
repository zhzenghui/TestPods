//
//  BackGroundDownload.h
//  TestPods
//
//  Created by xy on 15/8/27.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackGroundDownload : UIViewController



@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

- (IBAction)start:(id)sender;


@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

@end
