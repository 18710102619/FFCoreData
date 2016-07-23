//
//  ViewController.m
//  FFCoreData
//
//  Created by 张玲玉 on 16/7/21.
//  Copyright © 2016年 张玲玉. All rights reserved.
//

#import "ViewController.h"
#import "FFDBContext.h"
#import "Employee.h"
#import "Department.h"

@interface ViewController ()

@property(nonatomic,strong)NSManagedObjectContext *companyDBContext;
@property(nonatomic,strong)NSManagedObjectContext *weiboDBContext;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FFDBContext *dbContext=[FFDBContext sharedDBContext];
    self.companyDBContext=dbContext.companyDBContext;
    self.weiboDBContext=dbContext.weiboDBContext;
}

#pragma mark - 基本操作

- (IBAction)addEmployee:(id)sender
{
    NSError *error;
    
    Department *ios = [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:self.companyDBContext];
    ios.name = @"ios";
    ios.departNo = @"0001";
    ios.createDate = [NSDate date];
    error = nil;
    [self.companyDBContext save:&error];
    if (error) {
        NSLog(@"添加部门失败：%@",error);
    }
    Department *android = [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:self.companyDBContext];
    android.name = @"android";
    android.departNo = @"0002";
    android.createDate = [NSDate date];
    error = nil;
    [self.companyDBContext save:&error];
    if (error) {
        NSLog(@"添加部门失败：%@",error);
    }
    
    for (int i=0; i<50; i++) {
        Employee *emp1 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.companyDBContext];
        emp1.name = [NSString stringWithFormat:@"苹果_%i", i];
        emp1.height = @1.75;
        emp1.birthday = [NSDate date];
        emp1.depart=ios;
        error = nil;
        [self.companyDBContext save:&error];
        if (error) {
            NSLog(@"添加员工失败：%@",error);
        }
        Employee *emp2 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.companyDBContext];
        emp2.name = [NSString stringWithFormat:@"安卓_%i", i];
        emp2.height = @1.82;
        emp2.birthday = [NSDate date];
        emp2.depart=android;
        error = nil;
        [self.companyDBContext save:&error];
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
    NSArray *results = [self.companyDBContext executeFetchRequest:request error:&error];
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
    NSArray *results = [self.companyDBContext executeFetchRequest:request error:&error];
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
    NSArray *results = [self.companyDBContext executeFetchRequest:request error:&error];
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
    NSArray *results = [self.companyDBContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"修改员工失败：%@",error);
    }
    
    for (Employee *emp in results) {
        emp.height = @1.82;
    }
    [self.companyDBContext save:&error];
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
    NSArray *results = [self.companyDBContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"删除员工失败：%@",error);
    }
    
    for (Employee *emp in results) {
        [self.companyDBContext deleteObject:emp];
    }
    [self.companyDBContext save:&error];
    if (error) {
        NSLog(@"删除员工失败：%@",error);
    }
}

@end
