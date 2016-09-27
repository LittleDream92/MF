//
//  DKCarChooseTableViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/11.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKCarChooseTableViewController.h"
#import "ParamsViewController.h"
#import "ImageViewController.h"
#import "DKCarNeedsVC.h"
#import "DetailChooseCarHeader.h"

@interface DKCarChooseTableViewController ()
{
    DetailChooseCarHeader *headerView;
}

//数据源
@property (nonatomic, strong) CarModel *detailModel;

@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation DKCarChooseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选车";
//    [self setClose:YES];
    
    //初始化表视图的头尾视图
    [self createHeaderView];
    [self http_request];
}

- (void)createHeaderView {
    // 210 240 250
    CGFloat height = 0;
    if (kScreenHeight == 667) {
        height = 240;
    }else if (kScreenHeight > 667) {
        height = 250;
    }else {
        height = 210;
    }
    
    //头视图
    headerView = [[[NSBundle mainBundle] loadNibNamed:@"DetailChooseCarHeader" owner:self options:nil] lastObject];
    headerView.height = height;
    self.tableView.tableHeaderView = headerView;
    
    //尾视图
    self.tableView.tableFooterView = self.nextBtn;
}

#pragma mark - button action methods
- (void)buttonAction:(UIButton *)button {
    if (button.tag == 1212) {
        
        NSLog(@"next");
        DKCarNeedsVC *carNeedsVC = [[UIStoryboard storyboardWithName:@"Cars" bundle:nil] instantiateViewControllerWithIdentifier:@"DKCarNeedsVC"];
        carNeedsVC.chooseModel = self.detailModel;
        [self.navigationController pushViewController:carNeedsVC animated:YES];
    }
}

#pragma mark - setting and getting
-(UIButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.tag = 1212;
        [_nextBtn createButtonWithBGImgName:@"btn_nextStep1"
                         bghighlightImgName:@"btn_nextStep1.2"
                                   titleStr:@"下一步"
                                   fontSize:16];
        [_nextBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        _nextBtn.origin = CGPointMake(0, 0);
        _nextBtn.size = CGSizeMake(self.view.width, 50);
    }
    return _nextBtn;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = kScreenHeight - (44 *2 + 64+ 12 + headerView.height + 50);
    CGFloat row_H = (indexPath.row==2 ? height : 44);
    
    return row_H;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {   //参数配置
        ParamsViewController *carParamsVC = [[ParamsViewController alloc] init];
        carParamsVC.title = @"参数配置";
        carParamsVC.carID = self.detailModel.car_id;
        [self.navigationController pushViewController:carParamsVC animated:YES];
        
    }else if (indexPath.row == 1) {     //车型图片
        
        ImageViewController *imgsVC = [[ImageViewController alloc] init];
        imgsVC.title = @"车型图片";
        imgsVC.carID = self.detailModel.car_id;
        [self.navigationController pushViewController:imgsVC animated:YES];
    }
    
}


#pragma mark - 最近浏览
- (void)nearlyLookCarWithModel:(CarModel *)detailModel {
    //取出数组
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [UserDefaults objectForKey:MYLOOKCAR];
    
    if (array) {
        NSLog(@"not nil");
        
        //存在此数组
        NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:array];
        
        //保存成字典，包含CID、phono、title
        NSDictionary *carDic = [NSDictionary dictionaryWithObjectsAndKeys:self.cid,@"cid",
                                detailModel.main_photo,@"imgName",
                                detailModel.car_subject,@"title",nil];
        
        if ([mArr containsObject:carDic]) {     //包含重复元素

            //删除重复元素
            [mArr removeObject:carDic];
        }
        
        if ([mArr count] >= 3) {    //>3

            //删除第一个元素
            [mArr removeObjectAtIndex:0];
        }
        
        [mArr addObject:carDic];
        NSLog(@"这次的mArr:%@", mArr);
        
        //操作数组
        [[NSUserDefaults standardUserDefaults] setObject:mArr forKey:MYLOOKCAR];
        
    }else {
        NSLog(@"nil");
        
        //初始化mArr
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        
        //保存成字典，包含CID、phono、title
        NSDictionary *carDic = [NSDictionary dictionaryWithObjectsAndKeys:self.cid,@"cid",
                                detailModel.main_photo,@"imgName",
                                detailModel.car_subject,@"title",nil];
        
        [mArr addObject:carDic];
        [[NSUserDefaults standardUserDefaults] setObject:mArr forKey:MYLOOKCAR];
    }
    
}

#pragma mark - 网络请求
- (void)http_request {
//
//    [HttpTool requestOneCarWithCID:self.cid block:^(id json) {
//        self.detailModel = json;
//        [headerView createHeaderScrollViewWithModel:self.detailModel];
//        //最近浏览
//        [self nearlyLookCarWithModel:self.detailModel];
//    }];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.cid,@"cid", nil];
    
    [DataService http_Post:DETAIL_CAR
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"one car success：%@", responseObject);
                       
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSDictionary *jsonDic = [responseObject objectForKey:@"car"];
                           
                           CarModel *detailModel = [[CarModel alloc] initContentWithDic:jsonDic];
                           self.detailModel = detailModel;
                           //最近浏览
                           [self nearlyLookCarWithModel:self.detailModel];
                           
                       }else {
                           
                           NSLog(@"%@", [responseObject objectForKey:@"msg"]);
                           [PromtView showAlert:[responseObject objectForKey:@"msg"] duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       //
                       NSLog(@"one car errpr:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];


}

@end
