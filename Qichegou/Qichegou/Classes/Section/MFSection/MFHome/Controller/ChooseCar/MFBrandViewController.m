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

#import "BrandViewModel.h"



@interface MFBrandViewController ()<CustomButtonProtocol, UIScrollViewDelegate>
{
    BOOL _index;
}
@property (nonatomic, strong) CustomButtonView *titleView;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) BrandView *brandView;

@property (nonatomic, strong) BrandViewModel *viewModel;

@end

@implementation MFBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
    [self setUpViewModel];
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
    }
    return _brandView;
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

@end
