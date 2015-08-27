//
//  APIManager.m
//  TestPods
//
//  Created by xy on 15/8/27.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import "APIManager.h"
#import "ReformerProtocol.h"


@implementation APIManager



//在APIManager里面，fetchDataWithReformer是这样：
- (NSDictionary *)fetchDataWithReformer:(id<ReformerProtocol>)reformer
{
    if (reformer == nil) {
        return nil;
    } else {
        return [reformer reformDataWithManager:self];
    }
}
@end
