//
//  ETModel.m
//  zjTestMVVMDemo
//
//  Created by MACMINI on 16/2/23.
//  Copyright © 2016年 LZJ. All rights reserved.
//

#import "ETModel.h"

@implementation ETModel

@end

@implementation goodsListsItem
- (id)initWithJson:(NSDictionary *)json {
    self  = [super init];
    if (self) {
        self.iGoodsId = [json objectForKey:@"goodsId"];
        self.iGoodsImage = [json objectForKey:@"goodsImage"];
        self.iGoodsName = [json objectForKey:@"goodsName"];
        self.iGoodsStorePrice = [json objectForKey:@"goodsStorePrice"];
        self.iCommentnum = [json objectForKey:@"salenum"];
        self.iEvaluate = [json objectForKey:@"evaluate"];
        self.iCityName = [json objectForKey:@"cityName"];
    }
    return self;
}
@end

@implementation getGoodsListsResult
- (id)initWithJson:(NSDictionary *)json
{
    self  = [super init];
    if (self) {
        self.iResultCode = [json objectForKey:@"result"];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in [json objectForKey:@"data"])
        {
            goodsListsItem *item = [[goodsListsItem alloc] initWithJson:dic];
            [arr addObject:item];
        }
        self.iGoodsLists = [[NSArray alloc] initWithArray:arr];
    }
    return self;
}
@end
