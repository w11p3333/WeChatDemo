//
//  WCXMPPTool.h
//  WeChat
//
//  Created by 卢良潇 on 16/1/13.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPFramework.h"
#import "WCAccount.h"


typedef enum {
    XMPPResultTypeLoginSuccess,
    XMPPResultTypeLoginFaliure,
    XMPPResultTypeRegisterSuccess,
    XMPPResultTypeRegisterFailure
    
    
}XMPPResultType;
// 与服务器交互的结果
typedef void (^XMPPResultBlock)(XMPPResultType);

@interface WCXMPPTool : NSObject

singleton_interface(WCXMPPTool)
//标识连接到服务器是注册连接还是登陆连接
@property(nonatomic,assign,getter=isregisterOperation)BOOL registerOperation;
@property(nonatomic,strong,readonly)XMPPvCardAvatarModule *avatar;
@property(nonatomic,strong,readonly)XMPPvCardCoreDataStorage *vCardStorage;
@property(strong,nonatomic,readonly)XMPPvCardTempModule *vCard;//电子名片模块
@property(strong,nonatomic,readonly)XMPPRoster *roster;//花名册
@property(strong,nonatomic,readonly)XMPPRosterCoreDataStorage *rosterStorage;//花名册存储模块
@property(strong,nonatomic,readonly)XMPPStream *xmppStream;
@property(strong,nonatomic,readonly)XMPPMessageArchiving *msgArching;//消息模块
@property(strong,nonatomic,readonly)XMPPMessageArchivingCoreDataStorage *mesgStorage;






//用户登陆
-(void)xmpplogin:(XMPPResultBlock)resultBlock;
//用户注销
-(void)xmpploginout;
//用户注册
-(void)xmppRegister:(XMPPResultBlock)resultBlock;



@end
