//
//  NSMutableDictionary+Extention.m
//  Demo0824
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "NSMutableDictionary+Extention.h"

@implementation NSMutableDictionary (Extention)

+ (void)load
{
    Method originalMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:));
    Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(exchange_setObject:forKey:));
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void)exchange_setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject != nil) {
        [self exchange_setObject:anObject forKey:aKey];
    }
}

@end
