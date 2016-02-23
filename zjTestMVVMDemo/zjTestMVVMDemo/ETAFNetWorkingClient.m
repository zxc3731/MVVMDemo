//
//  ETAFNetWorkingClient.m
//  zjTestMVVMDemo
//
//  Created by MACMINI on 16/2/23.
//  Copyright © 2016年 LZJ. All rights reserved.
//

#import "ETAFNetWorkingClient.h"

@implementation ETAFNetWorkingClient
+ (instancetype)sharedClient
{
    static ETAFNetWorkingClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ETAFNetWorkingClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://120.24.210.76:8080/leimingtech-front/"]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer.timeoutInterval = 60;
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    });
    return _sharedClient;
}
@end
