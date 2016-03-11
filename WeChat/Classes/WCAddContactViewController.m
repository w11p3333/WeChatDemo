//
//  WCAddContactViewController.m
//  WeChat
//
//  Created by 卢良潇 on 16/1/19.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

#import "WCAddContactViewController.h"
#import "WCAccount.h"

@interface WCAddContactViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)addContactBtnClick:(id)sender;

@end

@implementation WCAddContactViewController

    


#pragma mark 添加好友
- (IBAction)addContactBtnClick:(id)sender {
    //不能添加自己为好友   不能添加不存在的   不能添加已经加为好友的
    //获取用户输入的微信号
    NSString *user = self.textField.text;
    
    
    if (self.textField.text == nil) {
        [self showMessage:@"请输入微信号！"];
        return;
    }
    
   
    
    if ([user isEqualToString:[WCAccount shareAccount].loginUser]) {
        [self showMessage:@"不能添加自己为好友"];
        return;
    }
   XMPPJID *userJid = [XMPPJID jidWithUser:user domain:[WCAccount shareAccount].domain resource:nil];
    
    BOOL existUser = [[WCXMPPTool sharedWCXMPPTool].rosterStorage userExistsWithJID:userJid xmppStream:[WCXMPPTool sharedWCXMPPTool].xmppStream];

   
    if (existUser) {
        [self showMessage:@"该用户已存在"];
        return;
        
    }
    
     [[WCXMPPTool sharedWCXMPPTool].roster subscribePresenceToUser:userJid];
    
}

-(void)showMessage:(NSString *)message

{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
  
}

@end
