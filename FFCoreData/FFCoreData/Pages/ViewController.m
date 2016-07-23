//
//  ViewController.m
//  FFCoreData
//
//  Created by 张玲玉 on 16/7/21.
//  Copyright © 2016年 张玲玉. All rights reserved.
//

#import "ViewController.h"
#import "Employee.h"
#import "Department.h"

@interface ViewController ()

@property(nonatomic,strong)NSManagedObjectContext *dbContext;

@end

@implementation ViewController

/*
 * 关联的时候，如果本地没有数据库文件，Ｃoreadata自己会创建
 */
- (NSManagedObjectContext *)dbContext
{
    //    1.创建模型文件 ［相当于一个数据库里的表］
    //    2.添加实体 ［一张表］
    //    3.创建实体类 [相当模型]
    //    4.生成上下文 关联模型文件生成数据库
    
    if (_dbContext==nil) {
        _dbContext = [[NSManagedObjectContext alloc] init];

        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];

        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"company.sqlite"];

        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:path] options:nil error:nil];
        
        _dbContext.persistentStoreCoordinator = store;
    }
    return _dbContext;
}

#pragma mark - 基本操作

- (IBAction)addEmployee:(id)sender
{
    NSError *error;
    
    Department *ios = [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:self.dbContext];
    ios.name = @"ios";
    ios.departNo = @"0001";
    ios.createDate = [NSDate date];
    error = nil;
    [self.dbContext save:&error];
    if (error) {
        NSLog(@"添加部门失败：%@",error);
    }
    Department *android = [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:self.dbContext];
    android.name = @"android";
    android.departNo = @"0002";
    android.createDate = [NSDate date];
    error = nil;
    [self.dbContext save:&error];
    if (error) {
        NSLog(@"添加部门失败：%@",error);
    }
    
    for (int i=0; i<50; i++) {
        Employee *emp1 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.dbContext];
        emp1.name = [NSString stringWithFormat:@"苹果_%i", i];
        emp1.height = @1.75;
        emp1.birthday = [NSDate date];
        emp1.depart=ios;
        error = nil;
        [self.dbContext save:&error];
        if (error) {
            NSLog(@"添加员工失败：%@",error);
        }
        Employee *emp2 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.dbContext];
        emp2.name = [NSString stringWithFormat:@"安卓_%i", i];
        emp2.height = @1.82;
        emp2.birthday = [NSDate date];
        emp2.depart=android;
        error = nil;
        [self.dbContext save:&error];
        if (error) {
            NSLog(@"添加员工失败：%@",error);
        }
    }
}

static int _currPage=0;      //第几页
static int _fetchOffset=0;   //起始索引
static int _fetchLimit=10;   //一页的条数

- (IBAction)readEmployee:(id)sender
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    // 表关联查询
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"depart.name=%@",@"ios"];
    request.predicate = pred;
    // 排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
    request.sortDescriptors = @[sort];
    
    NSError *error = nil;
    NSArray *results = [self.dbContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"读取员工失败：%@",error);
    }
    for (Employee *emp in results) {
        NSLog(@"名字 %@ 部门 %@",emp.name,emp.depart.name);
    }
}

- (IBAction)pageSearch:(id)sender
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    // 分页查询
    request.fetchLimit=_fetchLimit;
    request.fetchOffset=_fetchOffset+_fetchLimit*_currPage++;
    
    NSError *error = nil;
    NSArray *results = [self.dbContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"读取员工失败：%@",error);
    }
    for (Employee *emp in results) {
        NSLog(@"名字 %@ 部门 %@",emp.name,emp.depart.name);
    }
}

- (IBAction)fuzzySearch:(id)sender
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    // 模糊查询
    // 开头
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name BEGINSWITH %@",@"安"];
//    request.predicate = pred;
    // 结尾
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name ENDSWITH %@",@"0"];
//    request.predicate = pred;
    // 包含
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name CONTAINS %@",@"_"];
//    request.predicate = pred;
    // like
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name like %@",@"苹果"];
    request.predicate = pred;
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
    request.sortDescriptors = @[sort];
    
    NSError *error = nil;
    NSArray *results = [self.dbContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"读取员工失败：%@",error);
    }
    for (Employee *emp in results) {
        NSLog(@"名字 %@ 部门 %@",emp.name,emp.depart.name);
    }
}

- (IBAction)updateEmployee:(id)sender
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name=%@",@"张三"];
    request.predicate = pred;
    
    NSError *error = nil;
    NSArray *results = [self.dbContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"修改员工失败：%@",error);
    }
    
    for (Employee *emp in results) {
        emp.height = @1.82;
    }
    [self.dbContext save:&error];
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
    NSArray *results = [self.dbContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"删除员工失败：%@",error);
    }
    
    for (Employee *emp in results) {
        [self.dbContext deleteObject:emp];
    }
    [self.dbContext save:&error];
    if (error) {
        NSLog(@"删除员工失败：%@",error);
    }
}

@end
