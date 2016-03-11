//
//  WCMeViewController.m
//  WeChat
//
//  Created by 卢良潇 on 16/1/13.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

#import "WCMeViewController.h"
#import "AppDelegate.h"
#import "UIStoryboard+WF.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardAvatarCoreDataStorageObject.h"


@interface WCMeViewController ()<UIApplicationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avataImgView;//登录用户头像
@property (weak, nonatomic) IBOutlet UILabel *numLabel;//微信号


@end

@implementation WCMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //显示头像和微信号
    //从数据库里取出用户信息，使用电子名片模块
   //获取头像
    XMPPvCardTemp *myvCard =  [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    if (myvCard.photo) {
        self.avataImgView.image = [UIImage imageWithData:myvCard.photo];
        
    }
    //获取用户名
    //self.numLabel.text = myvCard.jid.user;
    self.numLabel.text = [@"微信号：" stringByAppendingString:[WCAccount shareAccount].loginUser];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginoutBtnClick:(id)sender {
    
    //注销
  
    [[WCXMPPTool sharedWCXMPPTool] xmpploginout];
    
    [WCAccount shareAccount].login = NO;
    [[WCAccount shareAccount] saveToSandBox];
    
    
    //回登录的控制器
    [UIStoryboard showInitialVCWithName:@"Login"];
    
   
    
    
}

@end
