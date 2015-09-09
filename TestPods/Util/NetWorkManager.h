//
//  NetWorkManager.h
//  TestPods
//
//  Created by xy on 15/9/9.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkManager : NSObject


+ (instancetype)sharedManager;

- (void)reachabilityStatusChange; 

@end
