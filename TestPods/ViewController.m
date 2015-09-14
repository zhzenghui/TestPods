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

#import "T.h"


#import "WriteToDBOperation.h"


static NSString *DownloadURLString = @"http://m2.pc6.com/mac/OmniGrafflePro.dmg";

@interface ViewController () <DownloaderDelegate, WriteToDBDelegate> {
    NSOperationQueue *queue;
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
    
    
    
    
    dbQueue = [[NSOperationQueue alloc] init];
    [dbQueue setMaxConcurrentOperationCount:6];
    
    
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self startTestConnectons];
}







- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    for (NSDictionary *dict in urlArray) {
        
        NSMutableDictionary  *mDict = [dict mutableCopy];
        PageLoadOperation *plo = [[PageLoadOperation alloc] initWithPhotoRecord:mDict delegate:self];
 
        [queue addOperation:plo];
        

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - PageLoadOperation delegate

- (void)downloaderDidFinish:(NSDictionary *)downloader; {
    
    
    uint64_t end = mach_absolute_time();
    
    NSLog(@"Time taken to doSomething %g s  index:%i complite:%d", MachTimeToSecs(end - begin), [downloader[@"index"] intValue], complite++);
    
    


    
    
    WriteToDBOperation *plo = [[WriteToDBOperation alloc] initWithRecord:downloader delegate:self];
    [dbQueue addOperation:plo];
}



#pragma mark - PageLoadOperation delegate
- (void)writeToDbDidFinish:(NSDictionary *)downloader; {
    
}



#pragma mark - APIManagerDelegate
- (void)apiManagerDidSuccess:(APIManager *)manager
{
    NSDictionary *reformedXXXData = [manager fetchDataWithReformer:self.XXXReformer];
//    [self.XXXView configWithData:reformedXXXData];
    
    NSDictionary *reformedYYYData = [manager fetchDataWithReformer:self.YYYReformer];
//    [self.YYYView configWithData:reformedYYYData];
}




@end
