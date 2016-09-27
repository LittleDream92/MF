//
//  ImageViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/22.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ImageViewController.h"
#import "CustomButtonView.h"
#import "MJRefresh.h"
#import "OtherModel.h"
#import "UIImageView+WebCache.h"
#import "BigCarImgVC.h"

#define IMG_CELL_W ((kScreenWidth - 15*2  - 8) / 2)
#define IMG_CELL_H (110)

static NSString *const cellID = @"imagesCollectionViewCell";
@interface ImageViewController ()<CustomButtonProtocol, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    CustomButtonView *_controlView;
    
    NSArray *titleArr;
    NSArray *imgNameArr;
    NSArray *selectImgNameArr;
    
    NSInteger index;
}

@property (nonatomic, strong) UICollectionView *imagesCollection;

//数据源
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpData];
    [self setUpViews];
    [self setUpRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpData {
    titleArr = @[@"外观",@"内饰",@"空间",@"官方图"];
    imgNameArr = @[@"btn_look",@"btn_color",@"btn_room",@"btn_img"];
    selectImgNameArr = @[@"外观按钮-点击状态.png",@"内饰按钮-点击状态.png",@"空间按钮-点击状态.png",@"官方图按钮-点击状态.png"];
}

- (void)setUpViews {
    
    //初始化控制视图
    _controlView = [[CustomButtonView alloc] initWithFrame:CGRectMake(15, 8, kScreenWidth-30, 30)];
    _controlView.myDelegate = self;
    
    CGFloat buttonW = _controlView.width / [titleArr count];
    [_controlView createWithImgNameArr:imgNameArr selectImgNameArr:selectImgNameArr buttonW:buttonW];
    [_controlView _initButtonViewWithMenuArr:titleArr
                                   textColor:RGB(27, 140, 227)
                             selectTextColor:[UIColor whiteColor]
                              fontSizeNumber:14
                                    needLine:NO];
    [self.view addSubview:_controlView];
    
    //初始化collection View
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0;
    
    self.imagesCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _controlView.bottom + 8, kScreenWidth, kScreenHeight - 64 - 8*2 - _controlView.height) collectionViewLayout:flowLayout];
    self.imagesCollection.showsVerticalScrollIndicator = NO;
    self.imagesCollection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imagesCollection];
    
    self.imagesCollection.delegate = self;
    self.imagesCollection.dataSource = self;
    
    //注册单元格
    [self.imagesCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
}

- (void)setUpRefresh {
    self.imagesCollection.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNewData)];
    //进来就开始刷新
    [self.imagesCollection.mj_header beginRefreshing];
}

#pragma mark - delegate
-(void)getTag:(NSInteger)tag {
    index = (NSInteger)tag - 1500;

    [self.imagesCollection.mj_header beginRefreshing];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:111];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMG_CELL_W, IMG_CELL_H)];
        imgView.tag = 111;
        [cell.contentView addSubview:imgView];
    }else {
        imgView.image = nil;
    }
    
    OtherModel *model = self.dataArray[indexPath.row];
//    NSLog(@"%@", [NSString stringWithFormat:@"%@%@", URL_String, model.thumb_sm]);
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, model.thumb_sm]] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(IMG_CELL_W, IMG_CELL_H);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 15, 8, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"正在点击单元格");
    //点击单元格 push
    BigCarImgVC *bigImgVC = [[BigCarImgVC alloc] init];
    
    bigImgVC.data = self.dataArray;
    bigImgVC.index = indexPath.row;
    bigImgVC.title = titleArr[index - 1];
    [self.navigationController pushViewController:bigImgVC animated:NO];
}


#pragma mark - requestData
- (void)requestNewData {
    if (!index) {
        index = 1;
    }
    
    //    NSLog(@"%ld", index);
    NSString *typeStr = [NSString stringWithFormat:@"%ld", (long)index];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.carID ,@"cid",
                            typeStr ,@"type", nil];//type 1－4，不能为空，默认为1
    
    [DataService http_Post:IMGS
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"car images :%@", responseObject);
                       
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSArray *jsonArr = [responseObject objectForKey:@"images"];
                           if ([jsonArr isKindOfClass:[NSArray class]] && jsonArr.count > 0) {
                               NSMutableArray *mArr = [NSMutableArray array];
                               for (NSDictionary *jsonDic in jsonArr) {
                                   
                                   OtherModel *model = [[OtherModel alloc] initContentWithDic:jsonDic];
                                   [mArr addObject:model];
                               }
                               if (YES) {
                                   self.dataArray = mArr;
                                   [self.imagesCollection reloadData];
                               }
                               //关闭刷新控件
                               [self.imagesCollection.mj_header endRefreshing];
                           }else {
                               [PromtView showAlert:@"暂无图片" duration:1.5];
                           }
                       }else {
                           [PromtView showAlert:@"加载图片失败" duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       NSLog(@"car images error:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];

}

@end
