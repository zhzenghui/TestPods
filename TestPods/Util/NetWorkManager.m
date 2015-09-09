//
//  NetWorkManager.m
//  TestPods
//
//  Created by xy on 15/9/9.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import "NetWorkManager.h"
#import "AFNetworking.h"


@implementation NetWorkManager

+ (instancetype)sharedManager {
    static NetWorkManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[NetWorkManager alloc] init];
    });
    
    return _sharedManager;
}




- (void)reachableViaWWAN {
    
    NSLog(@"无线网络");
}


- (void)reachableViaWiFi {
    
    NSLog(@"WiFi网络");
}


- (void)reachableNot {
    
    NSLog(@"无网络");
}



- (void)reachabilityStatusChange; {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:{
                
                [self reachableNot];
                break;
                
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                
                [self reachableViaWiFi];
                break;
                
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                
                [self reachableViaWWAN];
                break;
                
            }
                
            default:
                break;
                
        }
        
    }];
 
}

@end
