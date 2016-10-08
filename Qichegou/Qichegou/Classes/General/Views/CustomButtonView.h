//
//  CustomButtonView.h
//  DKBuyCar
//
//  Created by Song Gao on 16/1/5.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//
/*用button自定义类似于segmentContrl的控件*/
#import <UIKit/UIKit.h>

//协议
@protocol CustomButtonProtocol <NSObject>

@optional //可选的

@required //必选的

- (void)getTag:(NSInteger)tag;//获取当前选中下标

@end

/*
 
 遗留问题，横屏与竖屏时每个button的宽度怎么确定
 解决：一期 -> 先不让横屏
 
 */

@interface CustomButtonView : UIView
{
    NSArray *_menuArray;//标题数组
    
    NSArray *_imgNameArray;
    
    NSArray *_selectImgNameArray;
    
    
    //是否需要底部划线
    BOOL _needLine;
    
    CGFloat btnW;
    
    CGFloat btnH;
}

@property (nonatomic, assign) BOOL isCondationChooseCar;

//delegate
@property (nonatomic, strong)id <CustomButtonProtocol> myDelegate;

#pragma mark - init methods
/*
 * imgArr         普通状态下button图片名数组
 * selectImgArr   选中时button的图片名数组
 * btnW           button的宽
 */
- (void)createWithImgNameArr:(NSArray *)imgArr

            selectImgNameArr:(NSArray *)selectImgArr

                     buttonW:(CGFloat)buttonW;

/*
 *  自定义button视图的样式
 *  menuArr       button的title数组
 *  textColor     字体颜色
 *  selectTextColor  选中字体颜色
 * fontSizeNumber 字体大小
 * needLine       是否需要下划线
 */

- (void)_initButtonViewWithMenuArr:(NSArray *)menuArr

                         textColor:(UIColor *)textColor

                   selectTextColor:(UIColor *)selectTextColor

                    fontSizeNumber:(NSInteger)fontSizeNumber

                          needLine:(BOOL)needLine;

/* 对外的，滑动到那个选中button状态下 */
- (void)scrolledWithIndex:(NSInteger)index;

@end
