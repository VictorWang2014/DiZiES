//
//  DataRequest.m
//  DiZiES
//
//  Created by admin on 15/5/31.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "DataRequest.h"
#import "DataResponseParser.h"


@implementation DataRequest

+ (void)requestSyncUrl:(NSString *)url responseClass:(Class)responseClass
{
    [[self class] requestSyncUrl:url responseClass:responseClass success:nil failure:nil];
}

+ (void)requestSyncUrl:(NSString *)url responseClass:(Class)responseClass success:(CallBack)success failure:(CallBack)failure
{
    if (url == nil || url.length == 0)
        failure(@"failure");

    NSError *error;
    NSString *responseString            = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] usedEncoding:nil error:&error];
    if (error)
    {
        NSLog(@"request failed:%@", [error localizedDescription]);
        failure(responseString);
        return;
    }
    
    DataResponseParser *responseParser  = [[responseClass alloc] init];
    [responseParser parserFromData:responseString];
    success(responseParser);
}

+ (void)requestAsyncUrl:(NSString *)url responseClass:(Class)responseClass
{
    [[self class] requestAsyncUrl:url responseClass:responseClass success:nil failure:nil];
}

+ (void)requestAsyncUrl:(NSString *)url responseClass:(Class)responseClass success:(CallBack)success failure:(CallBack)failure
{
    if (url == nil || url.length == 0)
        failure(@"failure");

    dispatch_queue_t queue = dispatch_queue_create("com.DiZiForiPad.DiZiES", NULL);
    dispatch_async(queue, ^{
        NSError *error;
        NSString *responseString            = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] usedEncoding:nil error:&error];
        NSLog(@"%@", responseString);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
            {
                NSLog(@"request failed:%@", [error localizedDescription]);
                failure(responseString);
                return;
            }
            
            DataResponseParser *responseParser  = [[responseClass alloc] init];
            [responseParser parserFromData:responseString];
            success(responseParser);
        });
    });
}




+ (void)requestSyncUrl:(NSString *)url queryString:(NSString *)queryString responseClass:(Class)responseClass
{
    [[self class] requestSyncUrl:url queryString:queryString responseClass:responseClass success:nil failure:nil];
}

+ (void)requestSyncUrl:(NSString *)url queryString:(NSString *)queryString responseClass:(Class)responseClass success:(CallBack)success failure:(CallBack)failure
{
    NSMutableURLRequest *request            = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[queryString dataUsingEncoding:NSASCIIStringEncoding]];
    NSError *error                          = nil;
    NSData *responseData                    = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *responseString                = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if (error)
    {
        NSLog(@"request failed:%@", [error localizedDescription]);
        failure(responseString);
        return;
    }
    DataResponseParser *responseParser      = [[responseClass alloc] init];
    [responseParser parserFromData:responseString];
    success(responseParser);
}

+ (void)requestAsyncUrl:(NSString *)url queryString:(NSString *)queryString responseClass:(Class)responseClass
{
    [[self class] requestAsyncUrl:url queryString:queryString responseClass:responseClass success:nil failure:nil];
}

+ (void)requestAsyncUrl:(NSString *)url queryString:(NSString *)queryString responseClass:(Class)responseClass success:(CallBack)success failure:(CallBack)failure
{
    NSMutableURLRequest *request            = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[queryString dataUsingEncoding:NSASCIIStringEncoding]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *responseString            = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (connectionError)
        {
            NSLog(@"request failed:%@", [connectionError localizedDescription]);
            failure(responseString);
            return;
        }
        DataResponseParser *responseParser  = [[responseClass alloc] init];
        [responseParser parserFromData:responseString];
        success(responseParser);
    }];
}


@end
