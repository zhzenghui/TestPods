//
//  T.h
//  TestPods
//
//  Created by xy on 15/9/11.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#ifndef TestPods_T_h
#define TestPods_T_h
#import <mach/mach_time.h> // for mach_absolute_time




#define GetDATABASE  [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/DSADB.db"]]


#define DATABASE_NAME_PREFIX @"DSADB"




double MachTimeToSecs(uint64_t time);


#endif
