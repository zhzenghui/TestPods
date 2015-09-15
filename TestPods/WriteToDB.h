//
//  WriteToDB.h
//  TestPods
//
//  Created by xy on 15/9/11.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WriteToDB : NSObject {
    
}

+ (instancetype)sharedManager ;

-(void)writeDB:(NSDictionary *)xmlDict;


- (void)open;

- (void)close;


@end
