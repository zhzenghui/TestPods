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
#import "DAPXMLParser.h"
#import "WriteToDB.h"


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






#pragma mark -
#pragma mark - Downloading image


 
- (void)main {

    @autoreleasepool {
        if (self.isCancelled)
            return;

        NSString *post = self.dict[@"post"];
        NSData* sendData = [post dataUsingEncoding:NSUTF8StringEncoding];;

        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://dealer.chevy-ds.com/DataSyncAPI/fetchdata"] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:120.0];
        [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
        request.HTTPMethod = @"POST";
        request.HTTPBody =sendData;
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * operation, id responseObject) {

//            缓存文件
            NSString * a= [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSString * path=[ NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex : 0 ];
//            path=[[ NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex : 0 ] stringByAppendingPathComponent :[NSString stringWithFormat:@"%i", [self.dict[@"index"] intValue]] ];
////
//            NSError *error = nil;
//            [a writeToFile:path   atomically:YES encoding:NSUTF8StringEncoding error:&error];
//            
//            if (error) {
//                NSLog(@"%@", error);
//            }
            
            DAPXMLParser* pars = [[DAPXMLParser alloc] init];
            NSInteger err = [pars parse:responseObject];
            if (err == 0)
            {
               NSDictionary *parserDic = pars.dic_result;
//                NSLog(@"xml pars: %i", self.dict[@"index"]);
                WriteToDB *rtb = [WriteToDB sharedManager];
                [rtb writeDB:parserDic];
                
            }
            
            
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(downloaderDidFinish:) withObject:self.dict waitUntilDone:NO];

            
            
            
        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"%@",error);
            
            NSLog(@"Time   index:%i  ",   [self.dict[@"index"] intValue] );

        }];
        
        [[NSOperationQueue currentQueue] addOperation:operation];

   
        if (self.isCancelled)
            return;

        
    }
}
 
@end
