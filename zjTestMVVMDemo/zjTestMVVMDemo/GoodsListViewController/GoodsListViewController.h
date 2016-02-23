//
//  GoodsListViewController.h
//  zjTestMVVMDemo
//
//  Created by MACMINI on 16/2/23.
//  Copyright © 2016年 LZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListVM.h"
#import "MJRefresh.h"
@interface GoodsListViewController : UIViewController<MJRefreshBaseViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) GoodsListVM *vm;
@property (nonatomic, strong) MJRefreshFooterView *footer;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@end
