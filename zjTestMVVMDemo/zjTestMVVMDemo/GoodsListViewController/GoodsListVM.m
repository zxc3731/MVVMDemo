//
//  GoodsListVM.m
//  ElectronicTradingApp
//
//  Created by LZJ on 16/1/22.
//  Copyright © 2016年 LZJ. All rights reserved.
//

#import "GoodsListVM.h"

@implementation GoodsListVM
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
    [[RACObserve(self, iPageNo) filter:^BOOL(NSNumber *value) {
        return value.integerValue!=0;
    }] subscribeNext:^(id x) {
        [self getGoodsList:[x integerValue]];
    }];
    self.vcTitle = @"商品列表";
    self.iSearchType = @"gcIdSearch";
    self.keyword = @"200";
    self.listOrder = 1;
    self.iSortField = @"";
    self.iSortOrder = @"";
    self.iGoodsListArr = [[NSMutableArray alloc] init];
    self.iPageSize = 10;
    self.selectedSignal = [RACSubject subject];
}

- (void)getGoodsList:(NSInteger)page {
    //    self.goodsBrandID.length == 0?@"":self.goodsBrandID
    NSDictionary *_dic = @{@"searchType":self.iSearchType,@"keyword":self.keyword,@"sortField":self.iSortField,@"sortOrder":self.iSortOrder,@"specFilter":self.goodsTypeStr.length== 0?@"":self.goodsTypeStr,@"brandId":@"",@"pageSize":[NSNumber numberWithInteger:self.iPageSize],@"pageNo":@(page)};
    [self.requestBeforeObject sendNext:nil];
    @weakify(self);
    [[ETAFNetWorkingClient sharedClient] POST:@"goods/api/goodslist" parameters:_dic success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        if (0 == [[responseObject valueForKey:@"result"] integerValue]) {
            [self.errorObject sendNext:@"没有找到符合的商品"];
        }else{
            if (page == 1) {
                NSMutableArray *muarr = @[].mutableCopy;
                for (NSDictionary *temdict in responseObject[@"data"]) {
                    [muarr addObject:temdict[@"goodsName"]];
                }
                self.iGoodsListArr = muarr.copy;
            }
            else if (page > 1) {
                NSMutableArray *muarr = @[].mutableCopy;
                for (NSDictionary *temdict in responseObject[@"data"]) {
                    [muarr addObject:temdict[@"goodsName"]];
                }
                self.iGoodsListArr = [self.iGoodsListArr arrayByAddingObjectsFromArray:muarr.copy];
            }
            [self.successObject sendNext:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.errorObject sendNext:@"网络出问题了"];
    }];
    
}
@end
