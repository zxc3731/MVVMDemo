//
//  ETAFNetWorkingClient.h
//  zjTestMVVMDemo
//
//  Created by MACMINI on 16/2/23.
//  Copyright © 2016年 LZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
@interface ETAFNetWorkingClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end
