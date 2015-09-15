//
//  XMLConvertDictOperation.m
//  TestPods
//
//  Created by xy on 15/9/15.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import "XMLConvertDictOperation.h"
#import "DAPXMLParser.h"
#import "T.h"

#import "NSString+Eccape.h"



@implementation XMLConvertDictOperation


#pragma mark -
#pragma mark - Downloading image


- (id)initWithRecord:(NSMutableDictionary *)record  delegate:(id<XMLConvertDictDelegate>)theDelegate {
    
    if (self = [super init]) {
        // 2: Set the properties.
        _delegate = theDelegate;
        _dict = record;
        
    }
    return self;
}

- (NSArray *)sqlArray :(NSDictionary *)xmlDict {
    
    
    NSMutableArray *sArray = [NSMutableArray array];
    NSString *table = xmlDict[@"root"][@"body"][@"Content"][@"DataUnit"][@"DataUnitCode"];
    NSArray *rowList = xmlDict[@"root"][@"body"][@"Content"][@"DataUnit"][@"RowList"][@"Row"];
    
    
    if ([rowList isKindOfClass:[NSDictionary class]]) {
        
        
        rowList = @[rowList];
    }
    
    
    
    for (NSDictionary *sqlDict in rowList) {
        NSMutableString *sqlMString = [NSMutableString string];
        
        
        [sqlMString appendFormat:@"REPLACE INTO %@ ", table];
        [sqlMString appendString:@"("];
        {
            NSMutableString *cs = [NSMutableString string];
            for (NSString *coulmnName in sqlDict.allKeys) {
                [cs appendFormat:@"'%@',", coulmnName];
            }
            
            [sqlMString appendString:[cs substringWithRange:NSMakeRange(0, cs.length -1)]];
            
        }
        
        [sqlMString appendString:@")"];
        [sqlMString appendString:@"VALUES"];
        [sqlMString appendString:@"("];
        
        {
            NSMutableString *cs = [NSMutableString string];
            for (NSString *coulmnName in sqlDict.allValues) {
                [cs appendFormat:@"'%@',", [coulmnName sqliteEscape]];
            }
            
            [sqlMString appendString:[cs substringWithRange:NSMakeRange(0, cs.length -1)]];
        }
        [sqlMString appendString:@");"];
        
        [sArray addObject:sqlMString];
    }
    
    
    
    
    return sArray;
}



- (void)main {
    
    @autoreleasepool {
        if (self.isCancelled)
            return;
        
        DAPXMLParser* pars = [[DAPXMLParser alloc] init];
        
        
        
        
        NSInteger err = [pars parse:self.dict[@"dataDict"]];
        if (err == 0)
        {
            
            [self.dict setValue:nil  forKey:@"dataDict"];
            NSDictionary *parserDic = pars.dic_result;
            
            
            NSArray *array = [self sqlArray:parserDic];
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(xmlConvertDictDidFinish:) withObject:array waitUntilDone:NO];
            
        }
        
        
        
        
        
        
        
        
        
        
        if (self.isCancelled)
            return;
        
        
    }
}

@end
