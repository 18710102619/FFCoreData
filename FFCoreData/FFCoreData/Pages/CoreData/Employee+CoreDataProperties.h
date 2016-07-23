//
//  Employee+CoreDataProperties.h
//  FFCoreData
//
//  Created by 张玲玉 on 16/7/23.
//  Copyright © 2016年 张玲玉. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Employee.h"

NS_ASSUME_NONNULL_BEGIN

@interface Employee (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *birthday;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Department *depart;

@end

NS_ASSUME_NONNULL_END
