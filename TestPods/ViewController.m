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
#import "ReformerProtocol.h"

#import "APIManager.h"

#import "PageLoadOperation.h"
#import "SDPieLoopProgressView.h"

#import "T.h"
//#import "T.c"

#import "WriteToDBOperation.h"
#import "XMLConvertDictOperation.h"

static NSString *DownloadURLString = @"http://m2.pc6.com/mac/OmniGrafflePro.dmg";

@interface ViewController () <DownloaderDelegate, XMLConvertDictDelegate, WriteToDBDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate> {
    NSOperationQueue *queue;
    NSOperationQueue *xmlQueue;
    NSOperationQueue *dbQueue;

    NSArray *urlArray;
    
    uint64_t begin;

}
@end

@implementation ViewController



static int complite = 0;


- (void)startTestConnectons {
    
    queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:6];
    
    
    
    xmlQueue = [[NSOperationQueue alloc] init];
    [xmlQueue setMaxConcurrentOperationCount:6];
    
    dbQueue = [[NSOperationQueue alloc] init];
    [dbQueue setMaxConcurrentOperationCount:1];
    
    
    NSArray *a = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"plsqldev714" ofType:@"plist"]];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    for (int i = 0 ; i< a.count; i++) {
        [array addObject:@{@"url": @"", @"post": a[i],@"index": [NSNumber numberWithInt:i]}];
    }
    
    urlArray = array;
    
    
    
    
    
    //    __weak NSString *st1 = @"sunny".lowercaseString;
    //    __weak NSString *st2;
    //    st2 = @"suny".lowercaseString;
    //
    //    NSLog(@"%@, %@", st1, st2);
    
    begin = mach_absolute_time();
    
    
    for (NSDictionary *dict in urlArray) {
        
        NSMutableDictionary  *mDict = [dict mutableCopy];
        PageLoadOperation *plo = [[PageLoadOperation alloc] initWithPhotoRecord:mDict delegate:self];
        [queue addOperation:plo];
    }
}


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
    
    
    SDPieLoopProgressView *loop = [SDPieLoopProgressView progressView];
    loop.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    loop.progress = 0.08;
    [self.view addSubview:loop];
    
//    [self startTestConnectons];
    
//    self.session = [self backgroundSession];
//    
//    self.progressView.progress = 0;
//    self.progressView.hidden = YES;
//    
//    
//    
//    AFHTTPSessionManager *sm = [AFHTTPSessionManager manager];
//    
//    
//    [self start:nil];

}







- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - PageLoadOperation delegate

- (void)downloaderDidFinish:(NSDictionary *)downloader; {
    
    
    uint64_t end = mach_absolute_time();
    
    NSLog(@"Time taken to doSomething %g s  index:%i complite:%d", MachTimeToSecs(end - begin), [downloader[@"index"] intValue], complite++);
    
    

    
    
    XMLConvertDictOperation *plo = [[XMLConvertDictOperation alloc] initWithRecord:downloader delegate:self];
    [xmlQueue addOperation:plo];
    
    


}

#pragma mark - xml  convert dict delegate
- (void)xmlConvertDictDidFinish:(NSArray *)sqlArray; {
    
    
    uint64_t end = mach_absolute_time();
    
    NSLog(@"Time taken to doSomething %g s,  sql count: %i个", MachTimeToSecs(end - begin), sqlArray.count);
    
    WriteToDBOperation *plo = [[WriteToDBOperation alloc] initWithRecord:sqlArray delegate:self];
    [dbQueue addOperation:plo];

}

#pragma mark - WriteToDB delegate
- (void)writeToDbDidFinish:(NSDictionary *)downloader; {
    
    
    uint64_t end = mach_absolute_time();
    
    NSLog(@"all time %g s  index:%i ", MachTimeToSecs(end - begin), [downloader[@"index"] intValue]);
    
}



#pragma mark - APIManagerDelegate
- (void)apiManagerDidSuccess:(APIManager *)manager
{
//    NSDictionary *reformedXXXData = [manager fetchDataWithReformer:self.XXXReformer];
////    [self.XXXView configWithData:reformedXXXData];
//    
//    NSDictionary *reformedYYYData = [manager fetchDataWithReformer:self.YYYReformer];
////    [self.YYYView configWithData:reformedYYYData];
}




@end
