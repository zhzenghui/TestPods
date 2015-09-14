//
//  WriteToDBOperation.h
//  TestPods
//
//  Created by xy on 15/9/14.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import <Foundation/Foundation.h>




@protocol WriteToDBDelegate;
@interface WriteToDBOperation : NSOperation {
    
}



@property (nonatomic, readonly, strong) NSDictionary *dict;
@property (nonatomic, assign) id <WriteToDBDelegate> delegate;

- (id)initWithRecord:(NSDictionary *)record delegate:(id<WriteToDBDelegate>) theDelegate;

@end



@protocol WriteToDBDelegate <NSObject>

- (void)writeToDbDidFinish:(NSDictionary *)downloader;
@end


