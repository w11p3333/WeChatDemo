//
//  WCRegisterViewController.m
//  WeChat
//
//  Created by 卢良潇 on 16/1/14.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

#import "WCRegisterViewController.h"

@interface WCRegisterViewController ()
- (IBAction)cancelBtnClick:(id)sender;
- (IBAction)registerBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@end

@implementation WCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelBtnClick:(id)sender {
}

- (IBAction)registerBtnClick:(id)sender {
    
    //保存账号密码
    [WCAccount shareAccount].registerUser = self.userField.text;
    [WCAccount shareAccount].registerPwd = self.pwdField.text;
    
    
    [MBProgressHUD showMessage:@"正在注册中..."];
    //设置是注册操作
    
    
    __weak typeof (self)selfVc =self;
    [WCXMPPTool sharedWCXMPPTool].registerOperation = YES;
    [[WCXMPPTool sharedWCXMPPTool] xmppRegister:^( XMPPResultType
                                                 resultType){
    
    
    
        [selfVc handleXMPPResult:resultType];
    
    }];
    
  
    //保存用户的注册名和密码
    
}

#pragma mark - 处理注册结果
-(void)handleXMPPResult:(XMPPResultType)resultType

{

//在主线程工作
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [MBProgressHUD hideHUD];
        
        
        
        if (resultType == XMPPResultTypeRegisterSuccess) {
            [MBProgressHUD showSuccess:@"注册成功"];
        }else
        {
            [MBProgressHUD showError:@"注册失败 请检查用户名和密码"];
        }
    
    });

}




@end
