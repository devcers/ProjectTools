//
//  SearchNetResult.h
//  ProjectTools
//
//  Created by zhaoyang on 2017/11/3.
//  Copyright © 2017年 ZhaoyangLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchNetResult : NSObject

// 解析所有数据
- (void)parseAllNetResult:(NSDictionary *)jsonDictionary;

// 解析业务数据
- (void)parseNetResult:(NSDictionary *)jsonDictionary;

@end
