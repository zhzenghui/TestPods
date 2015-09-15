//
//  XMLConvertDictOperation.h
//  TestPods
//
//  Created by xy on 15/9/15.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMLConvertDictDelegate;
@interface XMLConvertDictOperation : NSOperation {

    
}



@property(retain) NSURL *targetURL;
@property (nonatomic, readonly, strong) NSMutableDictionary *dict;
@property (nonatomic, assign) id <XMLConvertDictDelegate> delegate;

- (id)initWithRecord:(NSDictionary *)record delegate:(id<XMLConvertDictDelegate>) theDelegate;

@end



@protocol XMLConvertDictDelegate <NSObject>

- (void)xmlConvertDictDidFinish:(NSArray *)sqlArray;
@end


