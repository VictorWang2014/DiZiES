//
//  HomeDataHelper.m
//  DiZiES
//
//  Created by admin on 15/5/24.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "HomeDataHelper.h"
#import "AppDelegate.h"
#import "HomeListDataModle.h"

@interface HomeDataHelper ()

@property (nonatomic, strong) NSManagedObjectContext        *context;

@end

@implementation HomeDataHelper

+ (HomeDataHelper *)shareInstance
{
    static HomeDataHelper *dataHelper   = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        dataHelper                      = [[HomeDataHelper alloc] init];
        AppDelegate *appdelete          = AppDelegateContext;
        dataHelper.context              = appdelete.managedObjectContext;
    });
    return dataHelper;
}

- (HomeListDataModle *)newObject
{
    HomeListDataModle *model            = (HomeListDataModle *)[NSEntityDescription insertNewObjectForEntityForName:@"HomeListDataModle" inManagedObjectContext:_context];
    return model;
}

- (BOOL)save
{
    NSError *error;
    BOOL success;
    if (!(success = [_context save:&error])) {
        NSLog(@"Error saving context:%@", error.localizedFailureReason);
    }
    NSLog(@"success");
    return success;
}

- (NSArray *)fetchItemsMatching:(NSString *)searchStr forAttribute:(NSString *)attribute
{
    NSEntityDescription *entity     = [NSEntityDescription entityForName:@"HomeListDataModle" inManagedObjectContext:_context];
    NSFetchRequest *fetchRequest    = [[NSFetchRequest alloc] init];
    fetchRequest.entity             = entity;
    if (attribute.length > 0 && searchStr.length > 0)
    {
        fetchRequest.predicate          = [NSPredicate predicateWithFormat:@"%K == %@", searchStr, attribute];
    }
    fetchRequest.returnsObjectsAsFaults = NO;
    NSError *error;
    NSArray *array = [_context executeFetchRequest:fetchRequest error:&error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"搜索个数" message:[NSString stringWithFormat:@"%d", array.count] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
    return array;
}

- (void)deleteObjects
{
    NSArray *arra = [self fetchItemsMatching:nil forAttribute:nil];
    for (NSManagedObject *obj in arra) {
        [_context deleteObject:obj];
    }
}

@end
