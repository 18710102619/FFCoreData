//
//  FFDBContext.h
//  FFCoreData
//
//  Created by 张玲玉 on 16/7/23.
//  Copyright © 2016年 张玲玉. All rights reserved.
//  数据库上下文

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FFDBContext : NSObject

@property(nonatomic,strong)NSManagedObjectContext *companyDBContext;
@property(nonatomic,strong)NSManagedObjectContext *weiboDBContext;

+ (FFDBContext *)sharedDBContext;

@end
