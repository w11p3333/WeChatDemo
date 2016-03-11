//
//  WCXMPPTool.m
//  WeChat
//
//  Created by 卢良潇 on 16/1/13.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

#import "WCXMPPTool.h"
#import "XMPPFramework.h"

@interface WCXMPPTool ()<XMPPStreamDelegate>
{
    XMPPResultBlock _resultBlock;
   
 
}
-(void)teardownStream;//释放资源
-(void)setupStream;   //1. 初始化xmppstream
-(void)connectToHost;  //2.连接服务器 传一个jid
-(void)sendpwdToHost;//3.发送密码
-(void)sendOnline; //4.发送一个在线请求给服务器
-(void)sendOffline;//5.发送离线消息
-(void)disconnectFromHost;//断开连接
@end

@implementation WCXMPPTool

singleton_implementation(WCXMPPTool)


#pragma mark -私有方法

#pragma mark 释放资源
-(void)teardownStream
{
     //释放代理
    [_xmppStream removeDelegate:self];
    //取消模块
    [_avatar deactivate];
    [_vCard deactivate];
    [_roster deactivate];
    [_msgArching deactivate];

    //断开连接
    [_xmppStream disconnect];
    //清空资源
    _vCardStorage  = nil;
    _vCard         = nil;
    _avatar        = nil;
    _xmppStream    = nil;
    _roster        = nil;
    _rosterStorage = nil;
    _msgArching    = nil;
    _mesgStorage   = nil;

}

-(void)setupStream

{
    //创建xmppstream对象
    _xmppStream = [[XMPPStream alloc]init];
    
    
    //添加xmpp电子名片模块
    _vCardStorage =[XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    //添加头像模块
    _avatar = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_vCard];
    //添加花名册模块
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc]init];
    _roster = [[XMPPRoster alloc]initWithRosterStorage:_rosterStorage];
   
    //添加消息模块
    _mesgStorage = [[XMPPMessageArchivingCoreDataStorage alloc]init];
    _msgArching = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_mesgStorage];
    
    
    
    
    
    //激活 
    [_vCard activate:_xmppStream];
    [_avatar activate:_xmppStream];
     [_roster activate:_xmppStream];
    [_msgArching activate:_xmppStream];
    
    //创建代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}

-(void)connectToHost
{
    if (!_xmppStream) {
        [self setupStream];
    }
    //1.设置jid
    XMPPJID *myJid = nil;
 
    
    //区分是注册登陆还是用户登陆
    WCAccount *account     = [WCAccount shareAccount];
    if (self.isregisterOperation) {
    NSString *registerUser = account.registerUser;
    myJid                  = [XMPPJID jidWithUser:registerUser domain:account.domain resource:@"nil"];
    } else {
    NSString *loginUser    = [WCAccount shareAccount].loginUser;
    myJid                  = [XMPPJID jidWithUser:loginUser domain:account.domain resource:@"nil"];
    }


    
    
    _xmppStream.myJID    = myJid;
    //2.设置主机地址
    _xmppStream.hostName = account.host;
    //3.设置主机端口号
    _xmppStream.hostPort = account.hostPort;
    
    //4.建立连接
    NSError *error = nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        WCLog(@"%@",error);
    } else {
        WCLog(@"发送连接成功");
        
        
        
    }
    
}

-(void)sendpwdToHost
{
    NSError *error = nil;
    NSString *pwd = [WCAccount shareAccount].loginPwd;
    [_xmppStream authenticateWithPassword:pwd error:&error];
    if (error) {
        WCLog(@"%@",error);
    }
    
}

-(void)sendOnline
{
    XMPPPresence *xmppPresence = [XMPPPresence presence];
    
    [_xmppStream sendElement:xmppPresence];
}

-(void)sendOffline
{
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    
    [_xmppStream sendElement:offline];
 
    
}


-(void)disconnectFromHost
{
    [_xmppStream disconnect];
 
    
}


#pragma mark - xmppstream的代理
#pragma mark - 连接建立成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    WCLog(@"连接建立成功");
    if (self.isregisterOperation) {
        
        NSError *error =nil;
        NSString *registerPwd = [WCAccount shareAccount].registerPwd;
        [_xmppStream registerWithPassword:registerPwd error:&error];
        
        if (error) {
            WCLog(@"%@", error);
        }
        
        
    } else {
          [self sendpwdToHost];
    }
    
    
    
}

#pragma mark - 登陆成功

-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    WCLog(@"登陆成功");
    [self sendOnline];
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
        
        _resultBlock = nil;
    }
}

#pragma mark -登陆失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    WCLog(@"登陆失败%@", error);
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFaliure);
    }
    
}


#pragma mark -注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    WCLog(@"注册成功");
    
    
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
}

#pragma mark -注册失败

-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{

    WCLog(@"注册失败%@",error);
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
}


#pragma mark - 公共方法
#pragma mark - 用户登陆
-(void)xmpplogin:(XMPPResultBlock)resultBlock
{
    //首先需要断开连接
    [_xmppStream disconnect];
    
    //保存resultBlock
    _resultBlock = resultBlock;
    [self connectToHost];
}


#pragma mark - 用户注销
-(void)xmpploginout
{               //发送离线消息给服务器
    
    [self sendOffline];
    //断开连接
    [self disconnectFromHost];
    
    WCLog(@"用户注销 断开连接");
    
    
}

#pragma mark - 用户注册
-(void)xmppRegister:(XMPPResultBlock)resultBlock
{
    
    
    //保存block
    _resultBlock =resultBlock;
    //先去除上次的连接
    [_xmppStream disconnect];
    //注册
    [self connectToHost];
    //1.发送注册jid给服务器请求长连接
    //2.连接成功发送密码
    
    
   

}
//程序关闭时调用
-(void)dealloc
{
    [self teardownStream];

}

@end


