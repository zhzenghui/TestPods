//
//  PageLoadOperation.m
//  Async Downloader
//
//  Created by Matt Long on 2/16/08.
//  Copyright 2008 Cocoa Is My Girlfriend. All rights reserved.
//

#import "PageLoadOperation.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@implementation PageLoadOperation

@synthesize targetURL;

static int down_count = 5;


- (id)initWithPhotoRecord:(NSDictionary *)record  delegate:(id<DownloaderDelegate>)theDelegate {
    
    if (self = [super init]) {
        // 2: Set the properties.
        _delegate = theDelegate;
        _dict = record;
        
        downloadResoult = false;
    }
    return self;
}



- (void)finsh:(NSData *)data content:(NSDictionary *)content
{
    
//    ZHFileCache *zfc = [[ZHFileCache alloc] init];
//    
//    [zfc saveFile:data fileName:[content objectForKey:@"name"] ];
}



- (BOOL)downLoad:(NSString *)pathUrlString
{
    
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: pathUrlString]];
    
    if (self.isCancelled) {
        
        data = nil;
        return NO;
    }
    
    if (data) {
        
        [self finsh:data content:self.dict];
        return YES;
        
    }
    else {
        data = nil;
        return NO;
    }
    
    data = nil;
    
    return NO;
}

#pragma mark -
#pragma mark - Downloading image

- (void)dowloadRecursion:(int)count
{
    
    
    NSString *pathUrlString = [NSString string];
    
    
    if (self.dict) {
        pathUrlString = [self.dict objectForKey:@"url"];
    }
    
    pathUrlString = [pathUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", pathUrlString);
    bool downloadResult= [self downLoad:pathUrlString];
    
    if ( downloadResult ) {
        
        downloadResoult = true;
        return;
    }
    else {
        downloadResoult = false;
        
        count--;
        if (count != 0) {
            [self dowloadRecursion:count];
        }
        return;
    }
}
 
- (void)main {

    @autoreleasepool {
        if (self.isCancelled)
            return;

        NSString *post = @"<root><head><signCode>5029C3055D51555112B60B33000122D5</signCode><appVersion>5.0</appVersion><coreFrameVersion>1.1.0</coreFrameVersion><timestamp>2015-09-08 14:21:37</timestamp><clientos>iPhone OS_8.4</clientos><appid>com.bitcar.DSA50</appid></head><body><Params><UserId>87d169b4-8f28-478b-bc71-a34600f9eb0d</UserId><OrganizationId>c921ce08-ea6e-406f-a263-eb94f1feb4ff</OrganizationId><BrandId>3427b247-07a2-4832-94e1-07c41c62f9bc</BrandId><ClientDataUnitVersion>0</ClientDataUnitVersion><ServerDataUnitVersion>13711451</ServerDataUnitVersion><DataUnitCode>BitCar_Permission_Brand</DataUnitCode></Params><Content></Content></body></root>";//self.dict[@"post"];
        NSData* sendData = [post dataUsingEncoding:NSUTF8StringEncoding];;

        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://dealer.chevy-ds.com/DataSyncAPI/fetchdata"] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:30.0];
        [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
        request.HTTPMethod = @"POST";
        request.HTTPBody =sendData;
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * operation, id responseObject) {
//            NSString * a= [[÷NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",a);÷
            
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(downloaderDidFinish:) withObject:self.dict waitUntilDone:NO];

            
            
            
        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"%@",error);
             //        dispatch_semaphore_signal(semaphore);
        }];
        [operation start];

//        
//        [self dowloadRecursion:down_count];
//        
//        
//        if ( ! downloadResoult) {
//            
//            NSLog(@"下载失败文件name:%@, 尝试下载%d次, url:%@", [self.dict objectForKey:@"name"], down_count,[self.dict objectForKey:@"url"]);
//        }
//        
//        
//        
//        if (self.isCancelled)
//            return;
//        
        // 5: Cast the operation to NSObject, and notify the caller on the main thread.
        
    }
}
 
@end
