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

#import <mach/mach_time.h> // for mach_absolute_time



static NSString *DownloadURLString = @"http://m2.pc6.com/mac/OmniGrafflePro.dmg";

@interface ViewController () <DownloaderDelegate> {
    NSOperationQueue *queue;
    NSArray *urlArray;
    
    uint64_t begin;

}
@end

@implementation ViewController





- (void)viewDidLoad {
    [super viewDidLoad];

    
    [queue setMaxConcurrentOperationCount:2];
    queue = [[NSOperationQueue alloc] init];

    
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:@{@"url": @"http://www.apple.com"}];
    [array addObject:@{@"url": @"http://www.yahoo.com"}];
    [array addObject:@{@"url": @"http://www.zarrastudios.com"}];
    urlArray = array;

    
    
    
    
    __weak NSString *st1 = @"sunny".lowercaseString;
    __weak NSString *st2;
    st2 = @"suny".lowercaseString;
    
    NSLog(@"%@, %@", st1, st2);
    
    begin = mach_absolute_time();

}







- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    for (NSDictionary *dict in urlArray) {
        
         PageLoadOperation *plo = [[PageLoadOperation alloc] initWithPhotoRecord:dict delegate:self];
        [queue addOperation:plo];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MachTime

double MachTimeToSecs(uint64_t time)
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer /  (double)timebase.denom / 1e9;
}


#pragma mark - PageLoadOperation delegate

- (void)downloaderDidFinish:(NSDictionary *)downloader; {
    
    
    uint64_t end = mach_absolute_time();
    
    NSLog(@"Time taken to doSomething %g s", MachTimeToSecs(end - begin));
    
 
    
    
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
