//
//  ViewController.m
//  IPAHelper
//
//  Created by zhongyang on 2017/11/15.
//  Copyright © 2017年 zhongyang. All rights reserved.
//

// 内购项目的产品ID
#define ProductID_IAP0001 @"com.zyveke.ZYEducation.reward001"
#define ProductID_IAP0003 @"com.zyveke.ZYEducation.reward003"
#define ProductID_IAP0006 @"com.zyveke.ZYEducation.reward006"
#define ProductID_IAP0012 @"com.zyveke.ZYEducation.reward012"
#define ProductID_IAP0025 @"com.zyveke.ZYEducation.reward025"
#define ProductID_IAP0050 @"com.zyveke.ZYEducation.reward050"

#import "ViewController.h"
#import <Masonry.h>
#import "ZYRewardPopView.h"
#import <IAPHelper.h>
#import <IAPShare.h>
#import <SVProgressHUD.h>
@interface ViewController ()
/** 打赏*/
@property (nonatomic, strong) UIButton *rewardButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [self rewardButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)rewardButtonClick
{
    ZYRewardPopView *rewardView = [[ZYRewardPopView alloc]initWithImageName:@"icon_common_default_avatar" title:@"zhongyang" subTitle:@"讲师" priceArray:@[@"1",@"3",@"6",@"12",@"25",@"50"]];
    [rewardView show];
    __weak __typeof(self)weakSelf = self;
    __block NSString *productID = nil;
    rewardView.buttonClickBlock = ^(NSInteger index) {
        switch (index) {
            case 0:
                productID = ProductID_IAP0001;
                break;
            case 1:
                productID = ProductID_IAP0003;
                break;
            case 2:
                productID = ProductID_IAP0006;
                break;
            case 3:
                productID = ProductID_IAP0012;
                break;
            case 4:
                productID = ProductID_IAP0025;
                break;
            default:
                productID = ProductID_IAP0050;
                break;
        }
        [weakSelf buyTestWithProductID:productID];
    };
}
- (void)buyTestWithProductID:(NSString *)productID
{
    //初始化
    if(![IAPShare sharedHelper].iap) {
        NSSet* dataSet = [[NSSet alloc] initWithObjects:productID, nil];
        
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    }
    //测试环境 打包上线时改为YES
    [IAPShare sharedHelper].iap.production = NO;
    // 请求商品信息
    [SVProgressHUD showWithStatus:@"请求商品信息"];
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response.products.count > 0 ) {
             SKProduct *product = response.products[0];
             //发起购买请求
             [SVProgressHUD showWithStatus:@"正在购买..."];
             [[IAPShare sharedHelper].iap buyProduct:product
                    onCompletion:^(SKPaymentTransaction* trans){
                if(trans.error)
                {
                    NSLog(@"Fail %@",[trans.error localizedDescription]);
                    [SVProgressHUD showInfoWithStatus:@"交易失败"];
                }
                else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                    
                    // 购买验证
                    NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                    
                    //本地进行验证 推荐服务端进行验证
                    [[IAPShare sharedHelper].iap checkReceipt:receipt onCompletion:^(NSString *response, NSError *error) {
                        if (error) {
                            [SVProgressHUD showInfoWithStatus:@"交易失败"];
                            return ;
                        }
                        //Convert JSON String to NSDictionary
                        NSDictionary* rec = [IAPShare toJSON:response];
                        if([rec[@"status"] integerValue]==0)
                        {
                            //验证成功 处理购买成功后的逻辑
                            [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                            [SVProgressHUD showSuccessWithStatus:@"购买成功"];
                        }
                        else {
                            NSLog(@"Fail");
                        }
                    }];
                    
                    
                }
                else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                    NSLog(@"error%@",trans.error);
                    if (trans.error.code == SKErrorPaymentCancelled) {
                    }else if (trans.error.code == SKErrorClientInvalid) {
                    }else if (trans.error.code == SKErrorPaymentInvalid) {
                    }else if (trans.error.code == SKErrorPaymentNotAllowed) {
                    }else if (trans.error.code == SKErrorStoreProductNotAvailable) {
                    }else{
                    }
                }
            }];
         }else{
             [SVProgressHUD showInfoWithStatus:@"获取商品信息失败"];
         }
     }];
}
#pragma mark - lazyload
- (UIButton *)rewardButton
{
    if (!_rewardButton) {
        _rewardButton = [[UIButton alloc]init];
        [self.view addSubview:_rewardButton];
        [_rewardButton setTitle:@"打赏" forState:UIControlStateNormal];
        [_rewardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rewardButton setBackgroundColor:[UIColor redColor]];
        _rewardButton.layer.masksToBounds = YES;
        _rewardButton.layer.cornerRadius = 25;
        [_rewardButton addTarget:self action:@selector(rewardButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_rewardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-80);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return _rewardButton;
}

@end
