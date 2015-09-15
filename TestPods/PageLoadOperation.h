//
//  PageLoadOperation.h
//  Async Downloader
//
//  Created by Matt Long on 2/16/08.
//  Copyright 2008 Cocoa Is My Girlfriend. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloaderDelegate;
@interface PageLoadOperation : NSOperation {
	NSURL *targetURL;
    bool downloadResoult;

}



@property(retain) NSURL *targetURL;
@property (nonatomic, readonly, strong) NSMutableDictionary *dict;
@property (nonatomic, assign) id <DownloaderDelegate> delegate;

- (id)initWithPhotoRecord:(NSDictionary *)record delegate:(id<DownloaderDelegate>) theDelegate;

@end



@protocol DownloaderDelegate <NSObject>

- (void)downloaderDidFinish:(NSDictionary *)downloader;
@end
