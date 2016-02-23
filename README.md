###关于MVC和MVVM在项目实践中的理解和总结的一些经验
####首先来转载一些MVC和MVVM的一些概念，网上一大堆，就不在这里论述了

#### MVC：
>#### 模型对象
    模型对象封装了应用程序的数据，并定义操控和处理该数据的逻辑和运算。例如，模型对象可能是表示游戏中的角色或地址簿中的联系人。用户在视图层中所进行的创建或修改数据的操作，通过控制器对象传达出去，最终会创建或更新模型对象。模型对象更改时（例如通过网络连接接收到新数据），它通知控制器对象，控制器对象更新相应的视图对象。
#### 视图对象
		视图对象是应用程序中用户可以看见的对象。视图对象知道如何将自己绘制出来，并可能对用户的操作作出响应。视图对象的主要目的，就是显示来自应用程序模型对象的数据，并使该数据可被编辑。尽管如此，在 MVC 应用程序中，视图对象通常与模型对象分离。
		在iOS应用程序开发中，所有的控件、窗口等都继承自 UIView，对应MVC中的V。UIView及其子类主要负责UI的实现，而UIView所产生的事件都可以采用委托的方式，交给UIViewController实现。
#### 控制器对象
		在应用程序的一个或多个视图对象和一个或多个模型对象之间，控制器对象充当媒介。控制器对象因此是同步管道程序，通过它，视图对象了解模型对象的更改，反之亦然。控制器对象还可以为应用程序执行设置和协调任务，并管理其他对象的生命周期。
		控制器对象解释在视图对象中进行的用户操作，并将新的或更改过的数据传达给模型对象。模型对象更改时，一个控制器对象会将新的模型数据传达给视图对象，以便视图对象可以显示它。
		 [https://liuzhichao.com/p/1379.html](http://weibo.com/ihubo)
		 
####MVVM：
>#### Model层
    Model层是少不了的了，我们得有东西充当DTO(数据传输对象)，当然，用字典也是可以的，编程么，要灵活一些。Model层是比较薄的一层，如果学过Java的小伙伴的话，对JavaBean应该不陌生吧。
#### ViewModel层
    ViewModel层，就是View和Model层的粘合剂，他是一个放置用户输入验证逻辑，视图显示逻辑，发起网络请求和其他各种各样的代码的极好的地方。说白了，就是把原来ViewController层的业务逻辑和页面逻辑等剥离出来放到ViewModel层。
#### View层
    View层，就是ViewController层，他的任务就是从ViewModel层获取数据，然后显示。
    [http://www.cocoachina.com/ios/20150122/10987.html](http://www.cocoachina.com/ios/20150122/10987.html)

ok，相信很多人都对MVC和MVVM模式有个大致的理解。
对我而言，MVVM解决了我一直非常苦恼的一个问题，就是抽取viewController中的数据处理功能和网络请求功能（突然想起一句话，设计模式并没有帮我们彻底解决那一坨代码，它只是将一坨代码分成几坨放在不同的地方而已）
然后看一下MVVM在实践中是如何帮我优雅地解决“抽取viewController中的数据处理功能和网络请求功能，然代码变得小清新”的问题吧。而想要方便地以MVVM模式开发，利用ReactiveCocoa是不二之选，不然我相信你会block定义声明满天飞。假设我有这样一个页面：GoodsListViewController，需要下拉刷新数据，上拉加载更多。很简单一个页面。

```objective-C
GoodsListViewController.h 

#import <UIKit/UIKit.h>
@interface GoodsListViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSString  *keyword;//为本页接口请求数据时使用。
@property (nonatomic,strong) NSString *iSearchType;
@property (nonatomic,strong) NSString *iSortField;
@property (nonatomic,strong) NSString *iSortOrder;
@property (weak, nonatomic) IBOutlet UIButton *allBiiton;
@property (weak, nonatomic) IBOutlet UIButton *saleButton;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@property (weak, nonatomic) IBOutlet UIButton *screeningButton;

@property (nonatomic , strong) NSString *goodsTypeStr;
@property (nonatomic, strong) NSString  *goodsBrandID;

@property (nonatomic, strong) GoodsListVM *vm;
@end
```
```objective-C
GoodsListViewController.m

@interface GoodsListViewController ()<MJRefreshBaseViewDelegate>
@property (nonatomic, strong) MJRefreshFooterView *footer;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) GoodsListVC_RightBarItem *changeBtn;
@end
@implementation GoodsListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bind];
    self.vm.iPageNo = 1; // viewController中只要这样赋值就能实现数据获取和处理，这样使vc很清新，一切都交给viewModel处理.
    [self setupRefresh];
}
- (void)bind {
    @weakify(self);
    [self.vm.requestBeforeObject subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // 弹出菊花， 请求前回调
    }];
    [self.vm.successObject subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES]; // 隐藏菊花，成功回调
        [self.header endRefreshing];
        [self.footer endRefreshing];
        [self.collectionView reloadData];
    }];
    [self.vm.errorObject subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES]; // 错误回调，包括网络错误和服务器返回数据错误
        [ETPublic showHUDWithTitle:x andImage:nil andTime:1.0]; // 弹出菊花提示
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}
#pragma mark - collectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.vm.iGoodsListArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
GoodsListsCell *cell = (GoodsListsCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsListsCellID" forIndexPath:indexPath];
        cell.item1 = [self.vm.iGoodsListArr objectAtIndex:[indexPath row]];
        return cell;
}
#pragma mark  - 进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    if (_footer == refreshView) {
        self.vm.iPageNo++;
    }
    else if (_header == refreshView) {
        self.vm.iPageNo = 1;
    }
}
#pragma mark  - 设置刷新（项目用的是旧版MJRefresh）
- (void)setupRefresh {
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = _collectionView;
    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = _collectionView;
}
- (void)dealloc {
    [_footer free];
    [_header free];
}
```
####然后是viewModel层
```objective-C
#import <Foundation/Foundation.h>
@protocol ETViewModelDelegate <NSObject> // viewModel父类
@required
- (UIViewController *)returnThePushVC:(id)pushMsg; // 考虑到vc会push，这样的逻辑我在vm做了，也可以不加
@end
@interface ETViewModel : NSObject<ETViewModelDelegate>
@property (nonatomic, strong) RACSubject *requestBeforeObject; // 调用请求前的回调
@property (nonatomic, strong) RACSubject *successObject; // 调用成功回调
@property (nonatomic, strong) RACSubject *failureObject; // 服务器数据错误回调
@property (nonatomic, strong) RACSubject *errorObject; // 网络错误回调，我的做法是不管哪一种都调用用这个回调

@property (nonatomic, strong) NSString *vcTitle; 
@property (nonatomic, strong) NSString *vcLeftItemImage;
@end
```
```objective-C
GoodsListVM.h

#import "ETViewModel.h"
@interface GoodsListVM : ETViewModel
@property (nonatomic) NSInteger iPageSize;
@property (nonatomic) NSInteger iPageNo;
@property (nonatomic, strong) RACSubject *selectedSignal;

@property (strong, nonatomic) getGoodsListsResult *iResult;
@property (strong, nonatomic) NSMutableArray *iGoodsListArr;
@end
```
```objective-C
GoodsListVM.m

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
    self.iGoodsListArr = [[NSMutableArray alloc] init];
    self.iPageSize = 10;
    self.selectedSignal = [RACSubject subject];
}

- (void)getGoodsList:(NSInteger)page {
    NSDictionary *_dic = @{@"searchType":self.iSearchType,@"keyword":self.keyword,@"sortField":self.iSortField,@"sortOrder":self.iSortOrder,@"specFilter":self.goodsTypeStr.length== 0?@"":self.goodsTypeStr,@"brandId":@"",@"pageSize":[NSNumber numberWithInteger:self.iPageSize],@"pageNo":@(page)}; // 组装数据
    [self.requestBeforeObject sendNext:nil]; // 发起回调，一般用来调起等待菊花
    @weakify(self);
    [[ETAFNetWorkingClient sharedClient] POST:GOODS_LIST parameters:_dic success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        if (0 == [[responseObject valueForKey:@"result"]integerValue]) {
            [self.errorObject sendNext:@"没有找到符合的商品"]; // 发起失败回调
        }else{
            self.iResult = [[getGoodsListsResult alloc] initWithJson:responseObject];
            if (page == 1) {
                [self.iGoodsListArr removeAllObjects];
            }
            [self.iGoodsListArr addObjectsFromArray:self.iResult.iGoodsLists];
            if (self.iResult.iGoodsLists.count == 0) {
                //                self.iPageNo--;
            }
            [self.successObject sendNext:nil]; // 发起成功回调
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.errorObject sendNext:@"网络出问题了"]; // 发起失败回调
    }];
    
}
@end
```
这样一个页面就完成了，实现了将数据的获取处理抽取了出来，并且在VC中只需要实现简单的self.vm.iPageNo = 1或其他赋值操作就能实现加载刷新数据，是否很方便呢？（以上比较重要的步骤都注释了）
([可以到这里下载Demo](https://github.com/zxc3731/MVVMDemo)	)
