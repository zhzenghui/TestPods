//
//  PageLoadOperation.m
//  Async Downloader
//
//  Created by Matt Long on 2/16/08.
//  Copyright 2008 Cocoa Is My Girlfriend. All rights reserved.
//

#import "PageLoadOperation.h"
#import "AppDelegate.h"

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
        
        
        [self dowloadRecursion:down_count];
        
        
        if ( ! downloadResoult) {
            
            NSLog(@"下载失败文件name:%@, 尝试下载%d次, url:%@", [self.dict objectForKey:@"name"], down_count,[self.dict objectForKey:@"url"]);
        }
        
        
        
        if (self.isCancelled)
            return;
        
        // 5: Cast the operation to NSObject, and notify the caller on the main thread.
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(downloaderDidFinish:) withObject:self waitUntilDone:NO];
        
    }
}
 
@end
