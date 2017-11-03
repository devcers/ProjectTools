//
//  NetworkParseMapper.h
//  ProjectTools
//
//  Created by zhaoyang on 2017/11/2.
//  Copyright © 2017年 ZhaoyangLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkParseMapper : NSObject

@property (nonatomic ,strong) NSDictionary *dictionaryMapper;           //对照表

//根据配置文件,获取Class中某个复合变量的数据Type
+ (NSString *)getVarTypeByVar:(NSString *)varName formClass:(NSString *)className;


@end
