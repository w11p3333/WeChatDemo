//
//  WCChatViewController.m
//  WeChat
//
//  Created by 卢良潇 on 16/1/19.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

#import "WCChatViewController.h"

@interface WCChatViewController ()<NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSFetchedResultsController *_resultContr;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WCChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //加载数据库的聊天数据
    //1.上下文
    NSManagedObjectContext *msgContext = [WCXMPPTool sharedWCXMPPTool].mesgStorage.mainThreadManagedObjectContext;
    //2.查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    //过滤条件
    NSString *loginUser = [WCXMPPTool sharedWCXMPPTool].xmppStream.myJID.bare;
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",loginUser,self.friendJid.bare];
    request.predicate = pre;
    
    //设置时间排序，时间越迟的在上面
    NSSortDescriptor *timesort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timesort];
    
    //3.执行请求
    _resultContr = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:msgContext sectionNameKeyPath:nil cacheName:nil];
    _resultContr.delegate =self;
    
    NSError *error = nil;
    [_resultContr performFetch:&error];
    WCLog(@"%@",error);
    WCLog(@"%@",_resultContr.fetchedObjects);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];


}

#pragma mark 表格数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return _resultContr.fetchedObjects.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

  static NSString *ID                                 = @"chatCell";

  UITableViewCell *cell                               = [tableView dequeueReusableCellWithIdentifier:ID];
    //获取聊天数据
  XMPPMessageArchiving_Message_CoreDataObject *msgObj = _resultContr.fetchedObjects[indexPath.row];
  cell.textLabel.text                                 = msgObj.body;
    return cell;
}

#pragma mark -键盘的通知
#pragma mark 键盘将显示
-(void)kbWillShow:(NSNotification *)noti{
    //显示的时候改变bottomContraint
    
    // 获取键盘高度
    NSLog(@"%@",noti.userInfo);
    CGFloat kbHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    
    self.bottomConstraint.constant = kbHeight;
}


#pragma mark 键盘将隐藏
-(void)kbWillHide:(NSNotification *)noti{
    self.bottomConstraint.constant = 0;
    
}

#pragma mark 表格滚动，隐藏键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
}



@end
