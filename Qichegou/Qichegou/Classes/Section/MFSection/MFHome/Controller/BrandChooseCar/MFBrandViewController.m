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
#import "CondationView.h"
#import "CarProView.h"

#import "DKCarListViewController.h"

#import "CarModel.h"
#import "BrandViewModel.h"

@interface MFBrandViewController ()
<CustomButtonProtocol,
UIScrollViewDelegate,
BrandClickProtocol>
{
    BOOL _index;
}
@property (nonatomic, strong) CustomButtonView *titleView;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) BrandView *brandView;
@property (nonatomic, strong) CondationView *condationView;
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
    [self blockAction];
}

/** 重写返回方法 */
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
    [self.scrollview addSubview:self.condationView];

    [self.view addSubview:self.carProView];
    [self.carProView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


- (void)setUpViewModel {
    
    //品牌
    NSDictionary *brandParams = [NSDictionary dictionaryWithObjectsAndKeys:[UserDefaults objectForKey:kLocationAction][@"cityid"], @"cityid", nil];
    RACSignal *brandSignal = [self.viewModel.brandCommand execute:brandParams];
    [brandSignal subscribeNext:^(id x) {
        self.brandView.sectionArray = x[0];
        self.brandView.sectionDic = x[1];
        [self.brandView.tableView reloadData];
    }];
    
    //热销车
    RACSignal *hotSignal = [self.viewModel.hotCommand execute:brandParams];
    [hotSignal subscribeNext:^(id x) {
        self.brandView.hotArray = x;
        [self.brandView.tableView reloadData];
    }];

}

#pragma mark - lazyloading
-(CustomButtonView *)titleView {
    if (!_titleView) {
        _titleView = [[CustomButtonView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
        _titleView.myDelegate = self;
        [_titleView createWithImgNameArr:nil selectImgNameArr:nil buttonW:kScreenWidth/2];
        NSArray *titles = @[@"品牌选车", @"条件选车"];
        _titleView.isCondationChooseCar = YES;
        [_titleView _initButtonViewWithMenuArr:titles
                                     textColor:TEXTCOLOR
                               selectTextColor:kskyBlueColor
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
        
        _scrollview.scrollEnabled = NO;
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

- (CondationView *)condationView {
    if (!_condationView) {
        _condationView = [[CondationView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-48-64)];
    }
    return _condationView;
}

-(CarProView *)carProView {
    if (!_carProView) {
        _carProView = [[CarProView alloc] init];
        _carProView.hidden = YES;
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
    
    self.viewModel.brandID = brandID;
    self.carProView.hidden = NO;
    
    RACSignal *signal = [self.viewModel.carProCommand execute:nil];
    [signal subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.carProView.dataArray = x;
            [self.carProView.tableView reloadData];
        });
    }];
}


//block
- (void)blockAction {
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
    
    self.condationView.clickNextBtn = ^ (NSDictionary *params){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@", params);
            DKCarListViewController *carListVC = [[DKCarListViewController alloc] init];
            carListVC.maxPrice = params[@"max"];
            carListVC.minPrice = params[@"min"];
            carListVC.modelID = params[@"mid"];
            [weakSelf.navigationController pushViewController:carListVC animated:YES];
        });
    };
}


@end
