//
//  ReformerProtocol.h
//  TestPods
//
//  Created by xy on 15/8/27.
//  Copyright (c) 2015年 XY. All rights reserved.
//



@class APIManager;
@protocol ReformerProtocol <NSObject>

- (NSDictionary *)reformDataWithManager:(APIManager *)manager;


@end
