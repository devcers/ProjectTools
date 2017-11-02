//
//  NetworkParseMapper.m
//  ProjectTools
//
//  Created by zhaoyang on 2017/11/2.
//  Copyright © 2017年 ZhaoyangLi. All rights reserved.
//

#import "NetworkParseMapper.h"

@implementation NetworkParseMapper

//全局解析器
static NetworkParseMapper *globalNetworkParseMapper = nil;

//根据配置文件,获取Class中某个复合变量的数据Type
+ (NSString *)getVarTypeByVar:(NSString *)varName formClass:(NSString *)className
{
    return @"";
}

// 实例化
+ (NetworkParseMapper *)getInstance
{
    @synchronized(self){
        if (globalNetworkParseMapper == nil) {
            globalNetworkParseMapper = [[super allocWithZone:NULL] init];
            
            //初始化
            [globalNetworkParseMapper setDictionaryMapper:nil];
        }
    }
    
    return globalNetworkParseMapper;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self getInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
