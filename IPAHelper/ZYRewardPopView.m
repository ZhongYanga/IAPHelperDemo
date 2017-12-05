//
//  ZYRewardPopView.m
//  IPAHelper
//
//  Created by zhongyang on 2017/11/15.
//  Copyright © 2017年 zhongyang. All rights reserved.
//
#define COLOR(r,g,b,a) [UIColor colorWithRed:(r/(float)255) green:(g/(float)255) blue:(b/(float)255) alpha:a]
#define KButtonHeight 36
#define KPopViewWidth [UIScreen mainScreen].bounds.size.width * 0.8
#define KButtonItemSpace 10
#define KButtonRowNumber 3
#define KButtonWidth (KPopViewWidth - 2*KLeftMargin - (KButtonRowNumber - 1) * KButtonItemSpace) / KButtonRowNumber
#define KButtonLineSpace 15
#define KLeftMargin 32
#import "ZYRewardPopView.h"
#import <Masonry.h>
@interface ZYRewardPopView ()
/** popView*/
@property (nonatomic, strong) UIView *popView;
@end
@implementation ZYRewardPopView

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title subTitle:(NSString *)subTitle priceArray:(NSArray *)priceArray
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self addSubViewsWithImage:imageName title:title subTitle:subTitle priceArray:priceArray];
    }
    return self;
}
#pragma mark - Publick Method
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
#pragma mark - Private Method
- (void)addSubViewsWithImage:(NSString *)imageName title:(NSString *)title subTitle:(NSString *)subTitle priceArray:(NSArray *)priceArray
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3];
    }];
    
    self.popView = [[UIView alloc]init];
    [self addSubview:self.popView];
    self.popView.backgroundColor = [UIColor whiteColor];
    self.popView.layer.cornerRadius = 8;
    self.popView.clipsToBounds = YES;
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(KPopViewWidth);
    }];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [self.popView addSubview:closeBtn];
    [closeBtn setImage:[UIImage imageNamed:@"icon_classes_close_normal"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
    }];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    [self.popView addSubview:imageV];
    imageV.image = [UIImage imageNamed:imageName];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(53, 53));
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.popView addSubview:titleLabel];
    titleLabel.text = title;
    titleLabel.textColor = COLOR(67, 133, 245, 1);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(15);
        make.left.mas_equalTo(self.popView.mas_centerX);
//        make.height.mas_equalTo([titleLabel.font pointSize]);
    }];
    
    UILabel *subTitleLabel = [[UILabel alloc]init];
    [self.popView addSubview:subTitleLabel];
    subTitleLabel.text = subTitle;
    subTitleLabel.textColor = COLOR(191, 191, 191, 1);
    subTitleLabel.font = [UIFont systemFontOfSize:12];
    subTitleLabel.textAlignment = NSTextAlignmentRight;
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(titleLabel);
        make.right.mas_equalTo(titleLabel.mas_left).offset(-8);
    }];
    
    UIView *lineView = [UIView new];
    [self.popView addSubview:lineView];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KLeftMargin);
        make.right.mas_equalTo(-KLeftMargin);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
    }];
    
    UIView *priceView = [UIView new];
    [self.popView addSubview:priceView];
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KLeftMargin);
        make.right.mas_equalTo(-KLeftMargin);
        make.height.mas_equalTo(87);
        make.top.mas_equalTo(lineView.mas_bottom).offset(20);
    }];
    UIButton *lastBtn = nil;
    for (int i = 0; i < priceArray.count; i ++) {
        UIButton *btn = [[UIButton alloc]init];
        [priceView addSubview:btn];
        [btn setTitle:priceArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR(67, 133, 245, 1) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        btn.layer.borderColor = COLOR(67, 133, 245, 1).CGColor;
        btn.layer.borderWidth = 1;
        btn.tag = i;
        [btn addTarget:self action:@selector(priceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KButtonHeight);
            make.width.mas_equalTo(KButtonWidth);
            make.top.mas_equalTo(i / KButtonRowNumber *(KButtonLineSpace + KButtonHeight));
            if (i % KButtonRowNumber == 0) {
                make.left.mas_equalTo(0);
            }else{
                make.left.mas_equalTo(lastBtn.mas_right).offset(KButtonItemSpace);
            }
        }];
        lastBtn = btn;
    }
    
    UILabel *messageLabel = [[UILabel alloc]init];
    [self.popView addSubview:messageLabel];
    messageLabel.text = @"创作不易，为讲师鼓励一下";
    messageLabel.textColor = [UIColor lightGrayColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont systemFontOfSize:12];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceView.mas_bottom).offset(18);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.popView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(messageLabel.mas_bottom).offset(20);
    }];
    [self animationWithView:self.popView duration:0.25];
}
- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values_Arr = [NSMutableArray array];
    [values_Arr addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values_Arr addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values_Arr addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values_Arr;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    //    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [view.layer addAnimation:animation forKey:nil];
    
}
#pragma mark - Target Actions
- (void)closeButtonClick
{
    [self removeFromSuperview];
    !_closeButtonClickBlock?:_closeButtonClickBlock();
}
- (void)priceBtnClick:(UIButton *)button
{
    [self removeFromSuperview];
    !_buttonClickBlock?:_buttonClickBlock(button.tag);
}
@end
