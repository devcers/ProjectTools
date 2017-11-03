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
    NetworkParseMapper *networkParseMapper = [NetworkParseMapper getInstance];
    //加载文件
    if ([networkParseMapper dictionaryMapper] == nil) {
        @autoreleasepool
        {
            //加载文件
            NSString *mapperPath = [[NSBundle mainBundle] pathForResource:@"ParseMapper" ofType:@"dat"];
            //该文件存在
            if ([[NSFileManager defaultManager] fileExistsAtPath:mapperPath]) {
                //加载文件中的内容
                NSDictionary *dictionaryMapperFromFile = [[NSDictionary alloc] initWithContentsOfFile:mapperPath];
                [networkParseMapper setDictionaryMapper:dictionaryMapperFromFile];
            }
        }
    }
    
    //查找
    NSDictionary *dictionaryMapper = [networkParseMapper dictionaryMapper];
    if (dictionaryMapper != nil) {
        NSArray *arrayMapperPair = [dictionaryMapper objectForKey:className];
        if (arrayMapperPair != nil) {
            NSInteger pairCount = [arrayMapperPair count];
            for (NSInteger i = 0; i < pairCount; i++) {
                NSString *pairString = [arrayMapperPair objectAtIndex:i];
                //通过字符串分割key:value
                NSArray *arrayComponent = [pairString componentsSeparatedByString:@":"];
                NSInteger componetCount = [arrayComponent count];
                if (componetCount == 2) {
                    NSString *key = [arrayComponent objectAtIndex:1];
                    if ([key isEqualToString:varName]) {
                        return [arrayComponent objectAtIndex:0];
                    }
                }
            }
        }
    }
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
