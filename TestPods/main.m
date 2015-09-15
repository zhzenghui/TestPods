//
//  main.m
//  TestPods
//
//  Created by xy on 15/8/25.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import <mach/mach_time.h> // for mach_absolute_time



//double MachTimeToSecs(uint64_t time)
//{
//    mach_timebase_info_data_t timebase;
//    mach_timebase_info(&timebase);
//    return (double)time * (double)timebase.numer /  (double)timebase.denom / 1e9;
//}


int main(int argc, char * argv[]) {
    
//    关于方法执行的代码段
//    uint64_t begin = mach_absolute_time();
//    uint64_t end = mach_absolute_time();
//    
//    NSLog(@"Time taken to doSomething %g s", MachTimeToSecs(end - begin));
    
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    


}
