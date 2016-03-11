//
//  WCLoginViewController.m
//  WeChat
//
//  Created by 卢良潇 on 16/1/13.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

#import "WCLoginViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+NJ.h"


@interface WCLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@end

@implementation WCLoginViewController

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

- (IBAction)loginBtnClick:(id)sender {
    
    //1.判断有无用户名和密码
    if (self.userField.text == 0 || self.pwdField.text == 0) {
        WCLog(@"请输入用户名和密码");
        
         return;
    }
    
    
    //给用户提示
    [MBProgressHUD showMessage:@"正在登录..."];
    
    //2.登陆服务器
    //3.将用户名和密码保存到沙盒
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:self.userField.text forKey:@"user"];
//    [defaults setObject:self.pwdField.text forKey:@"pwd"];
//    [defaults synchronize];
    
    //将用户名和密码保存到单例里面去
    [WCAccount shareAccount].loginUser = self.userField.text;
    [WCAccount shareAccount].loginPwd = self.pwdField.text;
    
    
    
    //4.调用appdelegate中的xmpplogin方法
    
    
    //block会对self强引用
    __weak typeof(self) selfVc =self;
    
   AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    
    //设置标示符  代表是登陆操作
    [WCXMPPTool sharedWCXMPPTool].registerOperation = NO;
    
    [[WCXMPPTool sharedWCXMPPTool] xmpplogin:^(XMPPResultType resultType){
        [selfVc handlXMPPResultType:resultType];
     
    }];
   
    
    
  
}

#pragma mark - 处理结果
-(void)handlXMPPResultType:(XMPPResultType)resultType{
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUD];
        
        if (resultType == XMPPResultTypeLoginSuccess) {
            WCLog(@"登陆成功");
            
            
            
            
            
            
            //5.登陆成功 切换到主页面
            
//            [self changeToMain];
            
            [UIStoryboard showInitialVCWithName:@"Main"];
//            
            
            //设置登陆状态并保存到沙盒
            [WCAccount shareAccount].login = YES;
           [[WCAccount shareAccount] saveToSandBox];
            
            
          
            
            
        } else {
            WCLog(@"登陆失败");
            [MBProgressHUD showError:@"用户名或密码错误"];
        }

        
    });
 

}



-(void)changeToMain{
    
  
 
//    //1.获取main.storyboard的第一个控制器
//    id vc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
//    
//    //2.切换window的根控制器
//    
//    [UIApplication sharedApplication ].keyWindow.rootViewController =vc;
 
}



@end
