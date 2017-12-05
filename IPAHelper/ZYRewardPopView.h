//
//  ZYRewardPopView.h
//  IPAHelper
//
//  Created by zhongyang on 2017/11/15.
//  Copyright © 2017年 zhongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYRewardPopView : UIView
- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title subTitle:(NSString *)subTitle priceArray:(NSArray *)priceArray;
- (void)show;
/** 按钮点击回调*/
@property (nonatomic, copy) void (^buttonClickBlock)(NSInteger index);
/** dissmiss*/
@property (nonatomic, copy) void (^closeButtonClickBlock)(void);
@end
