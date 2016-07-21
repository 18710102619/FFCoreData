//
//  ViewController.m
//  FFCoreData
//
//  Created by 张玲玉 on 16/7/21.
//  Copyright © 2016年 张玲玉. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Employee.h"

@interface ViewController ()

@property(nonatomic,strong)NSManagedObjectContext *context;

@end

@implementation ViewController

/*
 * 关联的时候，如果本地没有数据库文件，Ｃoreadata自己会创建
 */
- (NSManagedObjectContext *)context
{
    //    1.创建模型文件 ［相当于一个数据库里的表］
    //    2.添加实体 ［一张表］
    //    3.创建实体类 [相当模型]
    //    4.生成上下文 关联模型文件生成数据库
    
    if (_context==nil) {
        _context = [[NSManagedObjectContext alloc] init];

        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];

        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"company.sqlite"];

        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:path] options:nil error:nil];
        
        _context.persistentStoreCoordinator = store;
    }
    return _context;
}

#pragma mark - 基本操作

- (IBAction)addEmployee:(id)sender
{
    Employee *emp = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.context];
    emp.name = @"张三";
    emp.height = @1.75;
    emp.birthday = [NSDate date];
    
    NSError *error = nil;
    [self.context save:&error];
    if (error) {
        NSLog(@"添加员工失败：%@",error);
    }
}

- (IBAction)readEmployee:(id)sender
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name=%@",@"张三"];
    request.predicate = pred;
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
    request.sortDescriptors = @[sort];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"读取员工失败：%@",error);
    }
    for (Employee *emp in results) {
        NSLog(@"名字 %@ 身高 %@ 生日 %@",emp.name,emp.height,emp.birthday);
    }
}

- (IBAction)updateEmployee:(id)sender
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name=%@",@"张三"];
    request.predicate = pred;
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"修改员工失败：%@",error);
    }
    
    for (Employee *emp in results) {
        emp.height = @1.82;
    }
    [self.context save:&error];
    if (error) {
        NSLog(@"修改员工失败：%@",error);
    }
}

- (IBAction)deleteEmployee:(id)sender
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"height=%@",@1.75];
    request.predicate = pred;
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"删除员工失败：%@",error);
    }
    
    for (Employee *emp in results) {
        [self.context deleteObject:emp];
    }
    [self.context save:&error];
    if (error) {
        NSLog(@"删除员工失败：%@",error);
    }
}

@end
