//
//  CustomButtonView.m
//  DKBuyCar
//
//  Created by Song Gao on 16/1/5.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CustomButtonView.h"

@implementation CustomButtonView

- (void)createWithImgNameArr:(NSArray *)imgArr

            selectImgNameArr:(NSArray *)selectImgArr

                     buttonW:(CGFloat)buttonW
{
    
    _imgNameArray = imgArr;
    
    _selectImgNameArray = selectImgArr;
    
    btnW = buttonW;
    
}


- (void)_initButtonViewWithMenuArr:(NSArray *)menuArr

                         textColor:(UIColor *)textColor

                   selectTextColor:(UIColor *)selectTextColor

                    fontSizeNumber:(NSInteger)fontSizeNumber

                          needLine:(BOOL)needLine
{
    
    _menuArray = menuArr;
    
    _needLine = needLine;
    
//    //计算每个button的宽度
//    btnW = (kScreenWidth - 40) / [_menuArray count];
    
    btnH = self.frame.size.height;
    NSLog(@"%.2f", btnH);
    
//    NSLog(@"%d", _needLine);
//    NSLog(@"你好");
    
    for (int i = 0; i < [_menuArray count]; i++) {
        
        //创建button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
        
        btn.backgroundColor = [UIColor clearColor];
        
        
        //设置tag值
        btn.tag = 1501 + i;
        
        
        //设置默认第一个选中
        if (btn.tag == 1501) {
            
            btn.selected = YES;
            
        }
        
        
        //判断是否有背景图片
        if ([_imgNameArray count] > 0) {
            
            //设置背景图片
            [btn setBackgroundImage:[UIImage imageNamed:_imgNameArray[i]] forState:UIControlStateNormal];
            
            [btn setBackgroundImage:[UIImage imageNamed:_selectImgNameArray[i]] forState:UIControlStateSelected];
            
        }
        
        
        //设置标题
        [btn setTitleColor:textColor forState:UIControlStateNormal];
        
        [btn setTitleColor:selectTextColor forState:UIControlStateSelected];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:fontSizeNumber];
        
        [btn setTitle:_menuArray[i] forState:UIControlStateNormal];
        
        
        //添加点击事件
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
    
    
    if (_needLine) {
        
        //创建底部划线
        UIView *markLine = [[UIView alloc] initWithFrame:CGRectMake(0, btnH-2, btnW, 2)];
        
        markLine.tag = 999;
        
        markLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line_btn"]];
        
        [self addSubview:markLine];
        
    }
    
}

#pragma mark - 点击事件
/*button的点击事件*/
- (void)btnClick:(UIButton *)button
{
    
    //遍历子视图数组，把选中button的选中值设为yes，其他设为no
    for (UIView *subView in self.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            
            UIButton *subBtn = (UIButton *)subView;
            
            if (subBtn.tag == button.tag) {
                
                [subBtn setSelected:YES];
                
            }else {
                
                [subBtn setSelected:NO];
            }
        }
    }
    
    
    if (_needLine) {
        
        //动画移动底部划线（判断）
        UIView *markView = (UIView *)[self viewWithTag:999];
        
        NSInteger index = button.tag - 1501;
        
        [UIView animateWithDuration:0.2f animations:^{
            
            markView.frame = CGRectMake(index * btnW, btnH - 2, btnW, 2);
            
        }];
    }
    
    //实现代理方法
    if ([self.myDelegate respondsToSelector:@selector(getTag:)]) {
        
        [self.myDelegate getTag:button.tag];
        
    }
}


/* 对外的，滑动到那个选中button状态下 */
- (void)scrolledWithIndex:(NSInteger)index {
    NSInteger buttonTag = 1501 + index;
    UIButton *clickBtn = [self viewWithTag:buttonTag];
    [self btnClick:clickBtn];
}

@end
