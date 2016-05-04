//
//  ViewController.m
//  Apple pay
//
//  Created by Erwin on 16/3/30.
//  Copyright © 2016年 Erwin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)ApplePayAction:(id)sender {
    //如果设备不支持Applepay;
    if (![PKPaymentAuthorizationViewController  canMakePayments]) {
        return;
    }
    //判断设备里的银行卡是否支持；
    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay,PKPaymentNetworkDiscover]]){
        [[PKPassLibrary alloc] openPaymentSetup];
    }
    
    //创建支付请求
    PKPaymentRequest *request = [[PKPaymentRequest alloc]init];
    
    //填写商户号；
    request.merchantIdentifier = @"merchant.BDHOME.Apple-pay";
    //填写国家代号
    request.countryCode = @"CN";        //中国大陆；
    //设置支付货币
    request.currencyCode = @"CNY";      //人民币
    //设置商户支付标准
    request.merchantCapabilities = PKMerchantCapability3DS;         //必须支持3DS；
    //设置商户支持的银行卡
    /**
     *  对支付卡类别的限制
     *  PKPaymentNetworkChinaUnionPay  银联卡
     *  PKPaymentNetworkVisa  国际卡
     *  PKPaymentNetworkMasterCard 万事达卡 国际卡
     *  PKPaymentNetworkDiscover 美国流行的信用卡
     */
    request.supportedNetworks = @[PKPaymentNetworkDiscover,PKPaymentNetworkChinaUnionPay,PKPaymentNetworkVisa,PKPaymentNetworkAmex,PKPaymentNetworkMasterCard];
    
    
    //设置商品参数;
    NSDecimalNumber *product = [NSDecimalNumber decimalNumberWithString:@"0.01"];
    
    NSDecimalNumber *item = [NSDecimalNumber zero];
    item  = [item decimalNumberByAdding:product];
    
    //设置商品名称;
    PKPaymentSummaryItem *itemName = [PKPaymentSummaryItem summaryItemWithLabel:@"卫生纸:0.01元" amount:product];
    
    //添加付款项；
    request.paymentSummaryItems = @[itemName];
    
    
    //
    request.requiredBillingAddressFields = PKAddressFieldAll;
    
    request.requiredShippingAddressFields = PKAddressFieldAll;
    
    //设置配送方式；
    PKShippingMethod *freeShipping = [PKShippingMethod summaryItemWithLabel:@"包邮" amount:[NSDecimalNumber zero]];
    freeShipping.identifier = @"freeshipping";
    freeShipping.detail = @"商家包邮";
    
    PKShippingMethod *expressShipping = [PKShippingMethod summaryItemWithLabel:@"顺丰速递" amount:[NSDecimalNumber decimalNumberWithString:@"20.00"]];
    expressShipping.identifier = @"expressshipping";
    expressShipping.detail = @"次日送达";
    
    request.shippingMethods = @[freeShipping,expressShipping];
    
    //跳转付款页面
    PKPaymentAuthorizationViewController *paymentController = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:request];
    
    paymentController.delegate = self;
    
    if (!paymentController) {
        return;
    }
    
    [self presentViewController:paymentController animated:YES completion:nil];
    
}

#pragma mark - 支付结果回调；
-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion{
    completion(PKPaymentAuthorizationStatusSuccess);
    
//    PKPaymentToken *payToken = payment.token;
//    //支付凭据，发给服务端进行验证支付是否真实有效
//    PKContact *billingContact = payment.billingContact;     //账单信息
//    PKContact *shippingContact = payment.shippingContact;   //送货信息
//    PKContact *shippingMethod = payment.shippingMethod;     //送货方式
//    
//    PKContact *contact = payment.shippingContact;
//    
//    
//    
//    NSPersonNameComponents *name = contact.name;                //联系人姓名
//    
//    CNPostalAddress *postalAddress = contact.postalAddress;     //联系人地址
//    
//    NSString *emailAddress = contact.emailAddress;              //联系人邮箱
//    
//    CNPhoneNumber *phoneNumber = contact.phoneNumber;           //联系人手机
//    
//    NSString *supplementarySubLocality = contact.supplementarySubLocality;  //补充信息，地址详细描述，其他备注等等,iOS9.2及以上才有

    NSLog(@"payment-----%@",payment);
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
