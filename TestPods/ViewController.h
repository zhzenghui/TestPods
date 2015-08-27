//
//  ViewController.h
//  TestPods
//
//  Created by xy on 15/8/25.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReformerProtocol.h"


@interface ViewController : UIViewController


@property (nonatomic, strong) id<ReformerProtocol> XXXReformer;
@property (nonatomic, strong) id<ReformerProtocol> YYYReformer;


@end

