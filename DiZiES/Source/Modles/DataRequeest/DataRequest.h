//
//  DataRequest.h
//  DiZiES
//
//  Created by admin on 15/5/31.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CallBack) (id data);

@interface DataRequest : NSObject

+ (void)requestSyncUrl:(NSString *)url responseClass:(Class)responseClass;

+ (void)requestSyncUrl:(NSString *)url responseClass:(Class)responseClass success:(CallBack)success failure:(CallBack)failure;

+ (void)requestAsyncUrl:(NSString *)url responseClass:(Class)responseClass;

+ (void)requestAsyncUrl:(NSString *)url responseClass:(Class)responseClass success:(CallBack)success failure:(CallBack)failure;




+ (void)requestSyncUrl:(NSString *)url queryString:(NSString *)queryString responseClass:(Class)responseClass;

+ (void)requestSyncUrl:(NSString *)url queryString:(NSString *)queryString responseClass:(Class)responseClass success:(CallBack)success failure:(CallBack)failure;

+ (void)requestAsyncUrl:(NSString *)url queryString:(NSString *)queryString responseClass:(Class)responseClass;

+ (void)requestAsyncUrl:(NSString *)url queryString:(NSString *)queryString responseClass:(Class)responseClass success:(CallBack)success failure:(CallBack)failure;

@end
