//
//  FFDBContext.m
//  FFCoreData
//
//  Created by 张玲玉 on 16/7/23.
//  Copyright © 2016年 张玲玉. All rights reserved.
//

#import "FFDBContext.h"

@implementation FFDBContext

/**
 *  1.创建模型文件 ［相当于一个数据库里的表］
 *  2.添加实体 ［一张表］
 *  3.创建实体类 [相当模型]
 *  4.生成上下文 关联模型文件生成数据库，关联的时候，如果本地没有数据库文件，Ｃoreadata自己会创建
*/
// 使用下面的方法，如果budles为nil会把budle里面的所有模型文件的表放在一个数据库
// NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];


+ (FFDBContext *)sharedDBContext
{
    static FFDBContext *shared = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (NSManagedObjectContext *)companyDBContext
{

    if (_companyDBContext==nil) {
        _companyDBContext = [[NSManagedObjectContext alloc] init];
        
        NSURL *companyURL=[[NSBundle mainBundle]URLForResource:@"Company" withExtension:@"momd"];
        NSManagedObjectModel *model=[[NSManagedObjectModel alloc]initWithContentsOfURL:companyURL];
        
        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"company.sqlite"];
        
        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:path] options:nil error:nil];
        
        _companyDBContext.persistentStoreCoordinator = store;
    }
    return _companyDBContext;
}

- (NSManagedObjectContext *)weiboDBContext
{
    if (_weiboDBContext==nil) {
        _weiboDBContext = [[NSManagedObjectContext alloc] init];

        NSURL *companyURL=[[NSBundle mainBundle]URLForResource:@"Weibo" withExtension:@"momd"];
        NSManagedObjectModel *model=[[NSManagedObjectModel alloc]initWithContentsOfURL:companyURL];
        
        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"weibo.sqlite"];
        
        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:path] options:nil error:nil];
        
        _weiboDBContext.persistentStoreCoordinator = store;
    }
    return _weiboDBContext;
}

@end
