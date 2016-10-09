//
//  DKBaoDetailViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/6/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaoDetailViewController.h"
#import "DKBaoOrderTableViewController.h"

@interface DKBaoDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *baodanNumber;
@property (weak, nonatomic) IBOutlet UITextField *idCard;

@end

@implementation DKBaoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BGGRAYCOLOR;
    [self navBack:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button Action
- (IBAction)searchAction:(id)sender {
    
    [self.view endEditing:YES];
    
    //拿到textField的值
    NSString *number = self.baodanNumber.text;
    NSString *idCard = self.idCard.text;
    
    if (number == nil || number.length<=0) {
        NSLog(@"请输入保单号");
        [PromtView showAlert:@"请输入保单号" duration:1.5];
    } else if (idCard == nil || idCard.length!=18) { //身份证号18位
        NSLog(@"请输入正确身份证号");
        [PromtView showAlert:@"请输入正确身份证号" duration:1.5];
    } else {
        DKBaoOrderTableViewController *orderVC = [[DKBaoOrderTableViewController alloc] init];
        orderVC.type = number;
        orderVC.idCard = idCard;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}


@end
