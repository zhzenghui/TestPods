//
//  T.c
//  TestPods
//
//  Created by xy on 15/9/11.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#include "T.h"



double MachTimeToSecs(uint64_t time)
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer /  (double)timebase.denom / 1e9;
}
