//
//  GoodsListViewController.m
//  zjTestMVVMDemo
//
//  Created by MACMINI on 16/2/23.
//  Copyright © 2016年 LZJ. All rights reserved.
//

#import "GoodsListViewController.h"

@interface GoodsListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tbv;
@end

@implementation GoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tbv.delegate = self;
    self.tbv.dataSource = self;
    [self setupRefresh];
    [self bind];
    self.title = self.vm.vcTitle;
    self.vm.iPageNo = 1;
}
- (void)bind {
    @weakify(self);
    self.vm = [[GoodsListVM alloc] init];
    [self.vm.requestBeforeObject subscribeNext:^(id x) {
        @strongify(self);
        /*弹出等待菊花*/
    }];
    [self.vm.successObject subscribeNext:^(id x) {
        @strongify(self);
        /*隐藏菊花*/
        [self.header endRefreshing];
        [self.footer endRefreshing];
        [self.tbv reloadData];
    }];
    [self.vm.errorObject subscribeNext:^(id x) {
        @strongify(self);
        /*隐藏菊花,并且弹出错误信息*/
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vm.iGoodsListArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    if (self.vm.iGoodsListArr.count > indexPath.row) {
        [cell.textLabel setText:self.vm.iGoodsListArr[indexPath.row]];
    }
    return cell;
}
#pragma mark  - 进入刷新状态就会调用

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_footer == refreshView)
    {
        self.vm.iPageNo++;
    }
    if (_header == refreshView) {
        self.vm.iPageNo = 1;
    }
}

- (void)setupRefresh
{
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tbv;
    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tbv;
}

- (void)dealloc
{
    [_footer free];
    [_header free];
}
@end
