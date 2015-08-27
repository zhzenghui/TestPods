//
//  PropertyListReformer.h
//  TestPods
//
//  Created by xy on 15/8/27.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PropertyListReformerKeys.h"

@class APIManager;
@interface PropertyListReformer : NSObject

- (NSDictionary *)reformData:(NSDictionary *)originData fromManager:(APIManager *)manager;

@end
