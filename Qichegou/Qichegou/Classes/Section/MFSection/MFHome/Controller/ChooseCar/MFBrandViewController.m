//
//  MFBrandViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFBrandViewController.h"
#import "CustomButtonView.h"
#import "BrandView.h"
#import "CarProView.h"
#import "CarModel.h"
#import "BrandViewModel.h"
#import "DKCarListViewController.h"

@interface MFBrandViewController ()<CustomButtonProtocol, UIScrollViewDelegate, BrandClickProtocol>
{
    BOOL _index;
}
@property (nonatomic, strong) CustomButtonView *titleView;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) BrandView *brandView;

@property (nonatomic, strong) CarProView *carProView;

@property (nonatomic, strong) BrandViewModel *viewModel;

@property (nonatomic, strong) NSArray *proArr;

@end

@implementation MFBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
    [self setUpViewModel];
}

-(void)backAction:(UIButton *)sender {
    self.carProView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpNav {
    self.title = @"选车";
    
    [self navBack:YES];
}

- (void)setUpViews {
    [self.view addSubview:self.titleView];
    
    [self.view addSubview:self.scrollview];
    [self.scrollview makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(48, 0, 0, 0));
    }];
    

    [self.scrollview addSubview:self.brandView];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-48)];
    view2.backgroundColor = [UIColor blackColor];
    [self.scrollview addSubview:view2];

    [self.view addSubview:self.carProView];
    [self.carProView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.carProView.hidden = YES;
    
}

- (void)setUpViewModel {
    
    NSDictionary *brandParams = [NSDictionary dictionaryWithObjectsAndKeys:@"6", @"cityid", nil];
    RACSignal *brandSignal = [self.viewModel.brandCommand execute:brandParams];
    [brandSignal subscribeNext:^(id x) {
//        NSLog(@"brand : %@", x);
        self.brandView.sectionArray = x[0];
        self.brandView.sectionDic = x[1];
        [self.brandView.tableView reloadData];
    }];

    RACSignal *hotSignal = [self.viewModel.hotCommand execute:brandParams];
    [hotSignal subscribeNext:^(id x) {
//        NSLog(@"hot x:%@", x);
        self.brandView.hotArray = x;
        [self.brandView.tableView reloadData];
    }];
    
    WEAKSELF
    self.carProView.tapAction = ^ {
        weakSelf.carProView.hidden = YES;
    };
    
    self.carProView.clickItemAction = ^(NSString *proID) {
        NSLog(@"pro_id:%@", proID);
        weakSelf.carProView.hidden = YES;
        
        DKCarListViewController *carListVC = [[DKCarListViewController alloc] init];
        carListVC.pid = proID;
        [weakSelf.navigationController pushViewController:carListVC animated:YES];
    };
}

#pragma mark - lazyloading
-(CustomButtonView *)titleView {
    if (!_titleView) {
        _titleView = [[CustomButtonView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
        _titleView.myDelegate = self;
        [_titleView createWithImgNameArr:nil selectImgNameArr:nil buttonW:kScreenWidth/2];
        NSArray *titles = @[@"品牌选车", @"条件选车"];
        [_titleView _initButtonViewWithMenuArr:titles
                                     textColor:TEXTCOLOR
                               selectTextColor:ITEMCOLOR
                                fontSizeNumber:16
                                      needLine:YES];
    }
    return _titleView;
}


- (UIScrollView *)scrollview{
    if (_scrollview == nil) {
        _scrollview = [[UIScrollView alloc]init];
        
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.delegate = self;
        _scrollview.pagingEnabled = YES;//分页
        _scrollview.contentSize = CGSizeMake(kScreenWidth*2, 0);
    }
    return _scrollview;
}

-(BrandView *)brandView {
    if (!_brandView) {
        _brandView = [[BrandView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-48-64)];
        _brandView.delegate = self;
    }
    return _brandView;
}

-(CarProView *)carProView {
    if (!_carProView) {
        _carProView = [[CarProView alloc] init];
    }
    return _carProView;
}

-(BrandViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[BrandViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - action
//代理协议
-(void)getTag:(NSInteger)tag {
    _index = tag - 1501;
    NSLog(@"%d", _index);
    CGPoint offset = self.scrollview.contentOffset;
    offset.x = _index * kScreenWidth;
    [self.scrollview setContentOffset:offset animated:YES];
}

//滚动减速时
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //点击titleView按钮
    NSInteger index = scrollView.contentOffset.x / self.scrollview.frame.size.width;
    [self.titleView scrolledWithIndex:index];
    
}

//BrandClickProtocol
-(void)clickBrandWithBrandID:(NSString *)brandID {
//    NSLog(@"brandID:%@", brandID);
    self.carProView.hidden = NO;
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"bid"] = brandID;
    params[@"cityid"] = [UserDefaults objectForKey:kLocationAction][@"cityid"];
    

//   /* 很郁闷为什么RAC网络请求只请求第一次，之后就不起作用了呢。。。 */
//    RACSignal *signal = [self.viewModel.carProCommand execute:params];
//    [signal subscribeNext:^(id x) {
//    
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.carProView.dataArray = x;
//            self.carProView.hidden = NO;
//            [self.carProView.tableView reloadData];
//        });
//    }];
    
    [DataService http_Post:CARPROS
                parameters:params
                   success:^(id responseObject) {
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSArray *jsonArr = [responseObject objectForKey:@"products"];
                           NSMutableArray *mArr = [NSMutableArray array];
                           for (NSDictionary *jsonDic in jsonArr) {
                               CarModel *model = [[CarModel alloc] initContentWithDic:jsonDic];
                               [mArr addObject:model];
                           }
                           self.carProView.dataArray = mArr;
                           [self.carProView.tableView reloadData];
                       }else {
                           [PromtView showMessage:responseObject[@"mag"] duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
//                       NSLog(@"pro list error:%@", error);
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];

}

@end
