//
//  MFFeedBackViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/29.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFFeedBackViewController.h"


@interface MFFeedBackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIButton *submmitBtn;

@end

@implementation MFFeedBackViewController

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
    self.title = @"意见反馈";
    self.view.backgroundColor = BGGRAYCOLOR;
}

- (void)setUpViews {
    self.submmitBtn.layer.cornerRadius = 5;
    [self.submmitBtn setBackgroundColor:kskyBlueColor];
    [self.submmitBtn setTitle:@"提交" forState:UIControlStateNormal];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%ld", textView.text.length);
    if (textView.text.length > 0) {
        self.placeLabel.hidden = YES;
    }else {
        self.placeLabel.hidden = NO;
    }
}

#pragma mark - action
- (IBAction)submmitAction:(id)sender {
    NSLog(@"提交");
    
    if (self.textView.text.length > 0) {
        [self.view endEditing:YES];
        self.textView.text = nil;
        self.placeLabel.hidden = NO;
        
        [PromtView showAlert:@"您的意见我们已经收到！" duration:1.5];
    }else {
        [PromtView showAlert:@"请输入意见或者建议" duration:1.5];
    }
}


@end
