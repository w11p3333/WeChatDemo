//
//  WCAccount.h
//  WeChat
//
//  Created by 卢良潇 on 16/1/13.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kUserKey @"user"
#define kpwdKey @"pwd"
#define kloginKey @"login"
static NSString *domain           = @"localhost";
static NSString *host             = @"127.0.0.1";
static int hostPort               = 5222;

@interface WCAccount : NSObject
//用户登陆信息
@property(nonatomic,copy)NSString *loginUser;
@property(nonatomic,copy)NSString *loginPwd;
@property(nonatomic,assign,getter = isLogin)BOOL login;
//用户注册信息
@property(nonatomic,copy)NSString *registerUser;
@property(nonatomic,copy)NSString *registerPwd;


+(instancetype)shareAccount;
+(instancetype)allocWithZone:(struct _NSZone *)zone;
-(void)saveToSandBox;

//服务器信息
@property(nonatomic,copy,readonly)NSString *domain;
@property(nonatomic,copy,readonly)NSString *host;
@property(nonatomic,assign,readonly)int *hostPort;

@end
