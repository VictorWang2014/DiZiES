//
//  TestViewController.m
//  DiZiES
//
//  Created by admin on 15/5/30.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()
{
    NSMutableURLRequest *_request;
}

@end

@implementation TestViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getRootDirect];
}

- (void)getRootDirect
{
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ebsctgmgt.padccc.net/restapi/index.php/folder/1/children"]];
    [_request setHTTPMethod:@"GET"];
    [_request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection sendAsynchronousRequest:_request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"!-------%@", string);
    }];
    
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://ebsctgmgt.padccc.net/restapi/index.php/folder/1/children"] usedEncoding:nil error:nil];
    NSLog(@"!-＋＋＋＋＋%@", string);
}

@end

