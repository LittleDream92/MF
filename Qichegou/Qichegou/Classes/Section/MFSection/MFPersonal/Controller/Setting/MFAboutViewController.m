//
//  MFAboutViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/9.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFAboutViewController.h"
#import "DKMainWebViewController.h"

@interface MFAboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;


@end

@implementation MFAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - setUpViews
- (void)setUpNav {
    [self navBack:YES];
    self.title = @"关于我们";
}

- (void)setUpViews {
    //获取当前版本
    self.versionLabel.text = [NSString stringWithFormat:@"V %@", APP_VERSION];
}

#pragma mark - action
- (IBAction)serviceAction:(id)sender {
    
    DKMainWebViewController *serviceVC = [[DKMainWebViewController alloc] init];
    serviceVC.title = @"服务协议";
    serviceVC.isRequest = NO;
    serviceVC.webString = PROTOCOL_QICHEGOU;
    [self.navigationController pushViewController:serviceVC animated:YES];

}


@end
