//
//  ETModel.h
//  zjTestMVVMDemo
//
//  Created by MACMINI on 16/2/23.
//  Copyright © 2016年 LZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETModel : NSObject

@end

@interface goodsListsItem : NSObject

@property (strong, nonatomic) NSNumber *iGoodsId;
@property (strong, nonatomic) NSString *iGoodsImage;
@property (strong, nonatomic) NSString *iGoodsName;
@property (strong, nonatomic) NSNumber *iGoodsStorePrice;
@property (strong, nonatomic) NSNumber *iCommentnum;
@property (strong, nonatomic) NSNumber *iEvaluate;
@property (strong, nonatomic) NSString *iCityName;

- (id)initWithJson:(NSDictionary *)json;

@end


@interface getGoodsListsResult : NSObject

@property (strong, nonatomic) NSNumber *iResultCode;
@property (strong, nonatomic) NSArray *iGoodsLists;
@property (strong, nonatomic) NSNumber *iPageNo;
@property (strong, nonatomic) NSNumber *iPageSize;

- (id)initWithJson:(NSDictionary *)json;
@end