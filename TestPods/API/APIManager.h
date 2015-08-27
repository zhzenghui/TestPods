//
//  APIManager.h
//  TestPods
//
//  Created by xy on 15/8/27.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReformerProtocol.h"


@interface APIManager : NSObject

- (NSDictionary *)fetchDataWithReformer:(id<ReformerProtocol>)reformer;

@end
