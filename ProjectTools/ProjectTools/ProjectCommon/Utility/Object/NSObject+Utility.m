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
        
    }
}

@end



























