//
//  NSObject+Utility.m
//  ProjectTools
//
//  Created by zhaoyang on 2017/11/2.
//  Copyright © 2017年 ZhaoyangLi. All rights reserved.
//

#import "NSObject+Utility.h"
#import <foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import "NetworkParseMapper.h"
#import "SearchNetResult.h"

@implementation NSObject (Utility)

//成员变量转换成字典
- (void)serializeSimpleObject:(NSMutableArray *)dictionary
{
    NSString *className = NSStringFromClass([self class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    
    //获取property
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(theClass, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t proerty = properties[i];
        NSString *propertyName = [[NSString alloc]initWithCString:property_getName(proerty) encoding:NSUTF8StringEncoding];
        //获取对象
        Ivar iVar = class_getInstanceVariable([self class], [propertyName UTF8String]);
        if (iVar == nil) {
            //用另一种方法尝试(也就是寻找有没有带下划线的property)
            iVar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@",propertyName] UTF8String]);
        }
        //赋值
        if (iVar != nil) {
            id propertyValue = object_getIvar(self, iVar);
            //插入Dictionary中
            if (propertyValue != nil) {
                [dictionary setValue:propertyValue forKey:propertyName];
            }
        }
    }
    
    free(properties);
}

//自动解析Json
- (void)parseJsonAutomatic:(NSDictionary *)dictionaryJson
{
    if (dictionaryJson == nil) {
        dictionaryJson = [[NSDictionary alloc] init];
    }
    //获取对象
    NSString *className = NSStringFromClass([self class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    
    //获取Property
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(theClass, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        //获取Var
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        //获取对象
        Ivar iVar = class_getInstanceVariable([self class], [propertyName UTF8String]);
        if (iVar == nil) {
            //用另一种方法尝试(也就是寻找有没有带下划线的property)
            iVar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@",propertyName] UTF8String]);
        }
        
        //获取Name
        if ((iVar != nil) && (![dictionaryJson isEqual:[NSNull null]])) {
            //通过propertyName去Json中寻找Value
            id jsonValue = [dictionaryJson objectForKey:propertyName];
            //dictionary对象
            if (([jsonValue isKindOfClass:[NSDictionary class]]) || ([jsonValue isKindOfClass:[NSMutableDictionary class]])) {
                //获取数据类型
                NSString *varType = [NetworkParseMapper getVarTypeByVar:propertyName formClass:className];
                if (varType != nil) {
                    //创建对象
                    Class varClass = NSClassFromString(varType);
                    id varObject = [[varClass alloc]init];
                    
                    //进行自定义解析
                    if ((varObject != nil) && ([varObject respondsToSelector:@selector(parseNetResult:)])) {
                        [varObject parseNetResult:dictionaryJson];
                        
                    }
                    //递归进行下层解析
                    else{
                        [varObject parseJsonAutomatic:jsonValue];
                    }
                    
                    //赋值
                    object_setIvar(self, iVar, varObject);
                }
            }
            //array数组
            else if ([jsonValue isKindOfClass:[NSArray class]] || ([jsonValue isKindOfClass:[NSMutableArray class]])){
                //获取数据类型
                NSString *varType = [NetworkParseMapper getVarTypeByVar:propertyName formClass:className];
                if (varType != nil) {
                    NSMutableArray *arrayDest = [[NSMutableArray alloc]init];
                    //基本数据类型
                    if (([varType isEqualToString:@"NSString"]) || ([varType isEqualToString:@"NSNumber"])) {
                        [arrayDest addObjectsFromArray:jsonValue];
                    }else{
                        Class varClass = NSClassFromString(varType);
                        //解析
                        NSInteger jsonCount = [jsonValue count];
                        for (NSInteger i = 0; i < jsonCount; i++) {
                            NSDictionary *dictionaryJson = [jsonValue objectAtIndex:i];
                            if (dictionaryJson != nil) {
                                id varObject = [[varClass alloc]init];
                                // 进行自定义解析
                                if((varObject != nil) && ([varObject respondsToSelector:@selector(parseNetResult:)]))
                                {
                                    [varObject parseNetResult:dictionaryJson];
                                }
                                // 递归进行下层解析
                                else
                                {
                                    [varObject parseJsonAutomatic:dictionaryJson];
                                }
                                // 需添加判断
                                if (varObject != nil) {
                                    
                                    [arrayDest addObject:varObject];
                                }
                            }
                        }
                        
                        
                    }
                    
                    //赋值
                    object_setIvar(self, iVar, arrayDest);
                }
            }
            // NSNULL
            else if([jsonValue isKindOfClass:[NSNull class]])
            {
                
            }
            // 其他的对象(直接赋值,!!!!!如果还有dictionary,array之类的其他特殊对象，继续在上面补充!!!!!)
            else
            {
                // 赋值
                object_setIvar(self, iVar, jsonValue);
            }
            
        }
    }
    free(properties);
    
}

@end



























