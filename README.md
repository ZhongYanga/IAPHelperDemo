# IAPHelperDemo
A demo to use IAPHelper framework in your app purchase

详情参考 https://github.com/saturngod/IAPHelper

```
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
     
 ```
