//
//  NSString+Eccape.m
//  TestPods
//
//  Created by xy on 15/9/14.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import "NSString+Eccape.h"

@implementation NSString(Eccape)


- (NSString *)sqliteEscape; {

    NSString *escapeString = [self stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    return escapeString;
}

@end
