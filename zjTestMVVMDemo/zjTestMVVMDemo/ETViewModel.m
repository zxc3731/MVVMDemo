//
//  ETViewModel.m
//  ElectronicTradingApp
//
//  Created by LZJ on 16/1/19.
//  Copyright © 2016年 LZJ. All rights reserved.
//

#import "ETViewModel.h"

@implementation ETViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.successObject = [RACSubject subject];
        self.failureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
        self.requestBeforeObject = [RACSubject subject];
        self.vcLeftItemImage = @"backBtn.png";
    }
    return self;
}

@end
