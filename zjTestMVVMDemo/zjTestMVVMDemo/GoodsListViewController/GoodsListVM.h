//
//  GoodsListVM.h
//  ElectronicTradingApp
//
//  Created by LZJ on 16/1/22.
//  Copyright © 2016年 LZJ. All rights reserved.
//

#import "ETViewModel.h"
@interface GoodsListVM : ETViewModel
@property (nonatomic , strong) NSString *goodsTypeStr;
@property (nonatomic, strong) NSString  *goodsBrandID;
@property (nonatomic, strong) NSString  *keyword;
@property (nonatomic,strong) NSString *iSearchType;
@property (nonatomic,strong) NSString *iSortField;
@property (nonatomic,strong) NSString *iSortOrder;
@property (nonatomic) NSInteger saleOrder;
@property (nonatomic) NSInteger listOrder;
@property (nonatomic) NSInteger iPageSize;
@property (nonatomic) NSInteger iPageNo;
@property (nonatomic, strong) RACSubject *selectedSignal;

@property (strong, nonatomic) NSArray *iGoodsListArr;
@end
