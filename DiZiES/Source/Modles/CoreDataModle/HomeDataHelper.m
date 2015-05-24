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
    HomeListDataModle *model        = (HomeListDataModle *)[NSEntityDescription insertNewObjectForEntityForName:@"HomeListDataModle" inManagedObjectContext:_context];
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
    fetchRequest.predicate          = [NSPredicate predicateWithFormat:@"fatherNode == %@", attribute];
    NSError *error;
    NSArray *array = [_context executeFetchRequest:fetchRequest error:&error];
//    if () {
//        
//    }
    return array;
}

@end
