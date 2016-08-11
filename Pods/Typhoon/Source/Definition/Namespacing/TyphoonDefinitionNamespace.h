////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface TyphoonDefinitionNamespace : NSObject

+ (instancetype)namespaceWithKey:(NSString *)key;
+ (instancetype)globalNamespace;

@property (strong, nonatomic, readonly) NSString *key;

- (BOOL)isGlobalNamespace;

@end