//
//  PropertyListReformer.m
//  TestPods
//
//  Created by xy on 15/8/27.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import "PropertyListReformer.h"
#import "APIManager.h"
#import "ZuFangListAPIManager.h"
#import "XinFangListAPIManager.h"
#import "ErShouFangListAPIManager.h"
#import <UIKit/UIKit.h>

#import "UIImage+Helper.h"

@implementation PropertyListReformer


NSString * const kPropertyListDataKeyID = @"kPropertyListDataKeyID";
NSString * const kPropertyListDataKeyName = @"kPropertyListDataKeyName";
NSString * const kPropertyListDataKeyTitle = @"kPropertyListDataKeyTitle";
NSString * const kPropertyListDataKeyImage = @"kPropertyListDataKeyImage";

- (NSDictionary *)reformData:(NSDictionary *)originData fromManager:(APIManager *)manager
{

    NSDictionary *resultData = nil;
    
    if ([manager isKindOfClass:[ZuFangListAPIManager class]]) {
        resultData = @{
                       kPropertyListDataKeyID:originData[@"id"],
                       kPropertyListDataKeyName:originData[@"name"],
                       kPropertyListDataKeyTitle:originData[@"title"],
                       kPropertyListDataKeyImage:[UIImage imageWithUrlString:originData[@"imageUrl"]]
                       };
    }
    
    if ([manager isKindOfClass:[XinFangListAPIManager class]]) {
        resultData = @{
                       kPropertyListDataKeyID:originData[@"xinfang_id"],
                       kPropertyListDataKeyName:originData[@"xinfang_name"],
                       kPropertyListDataKeyTitle:originData[@"xinfang_title"],
                       kPropertyListDataKeyImage:[UIImage imageWithUrlString:originData[@"xinfang_imageUrl"]]
                       };
    }
    
    if ([manager isKindOfClass:[ErShouFangListAPIManager class]]) {
        resultData = @{
                       kPropertyListDataKeyID:originData[@"esf_id"],
                       kPropertyListDataKeyName:originData[@"esf_name"],
                       kPropertyListDataKeyTitle:originData[@"esf_title"],
                       kPropertyListDataKeyImage:[UIImage imageWithUrlString:originData[@"esf_imageUrl"]]
                       };
    }
    
    return resultData;
}


@end
