//
//  WCProfileVIewController.m
//  WeChat
//
//  Created by 卢良潇 on 16/1/17.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

#import "WCProfileVIewController.h"
#import "XMPPvCardTemp.h"
#import "WCeditVCardViewController.h"

@interface WCProfileVIewController ()<WCeditVCardViewControllerDelegate,UIActionSheetDelegate,UINavigationBarDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nIcknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weChatNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;


@end

@implementation WCProfileVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WCLog(@"显示界面成功");
//    
        XMPPvCardTemp *myvCard =  [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    if (myvCard.photo) {
        self.avatarImgView.image = [UIImage imageWithData:myvCard.photo];
    }
    //获取用户名
    //self.numLabel.text = myvCard.jid.user;
    self.weChatNumLabel.text  = [WCAccount shareAccount].loginUser;
    self.nIcknameLabel.text   = myvCard.nickname;
    self.orgUnitLabel.text    = myvCard.orgName;//公司名字
    if (myvCard.orgUnits.count > 0) {
    self.departmentLabel.text = myvCard.orgUnits[0];//部门名字
    }
  
    self.titleLabel.text      = myvCard.title;
//    self.telLabel.text = myvCard.telecomsAddresses;   xmpp内部框架没有解析tel   使用note替代


    self.telLabel.text        = myvCard.note;
    self.emailLabel.text = myvCard.mailer;//用mailer充当

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //当tag为0时，跳出警示栏
    //当tag为1时，到下一个控制器 当tag为2时什么都不做
    UITableView *selectedTableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (selectedTableViewCell.tag ) {
        case 0:
            WCLog(@"换头像");
            [self chooseImage];
            
            break;
            
        case 1:
            WCLog(@"进入下个控制器");
         
            [self performSegueWithIdentifier:@"toEditSegue" sender:selectedTableViewCell];
            break;
            
        case 2:
            WCLog(@"不做任何操作");
            break;
            
        default:
            break;
    }
    
    
    
    
    
}

#pragma mark - 选择更改头像
-(void)chooseImage
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"图片库", nil];

    [sheet showInView:self.view];
}
#pragma mark -图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info

{
    WCLog(@"%@",info);
    
    //获取剪切后的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //修改图片
    self.avatarImgView.image = image;
    //移除选择控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    //将图片上传到服务器
    [self WCeditVCardViewController:nil didFinishSave:nil];
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    WCLog(@"%ld", buttonIndex);
    if (buttonIndex == 2) {//取消
        return;
    }
    //图片选择器
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
    //设置代理
    imgPicker.delegate =self;
    //允许编辑图片
    imgPicker.allowsEditing = YES;
    
    if (buttonIndex == 0) {//照相
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else {//图片库
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //显示控制器
    [self presentViewController:imgPicker animated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{

//获取目标控制器
    id destVc = segue.destinationViewController;
    //设置编辑电子名片cell的属性
    if ([destVc isKindOfClass:[WCeditVCardViewController class]]) {
        WCeditVCardViewController *editVc =destVc;
        editVc.cell =sender;
        //设置代理
        editVc.delegate =self;
        
    }
}


-(void)WCeditVCardViewController:(WCeditVCardViewController *)editVc didFinishSave:(id)sender

{
    WCLog(@"完成保存");
    
    //获取当前的电子名片
    XMPPvCardTemp *myVCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;


    //重新设置头像
    myVCard.photo = UIImageJPEGRepresentation(self.avatarImgView.image, 0.75);
    //重新设置vcard的属性

    myVCard.nickname       = self.nIcknameLabel.text;
    myVCard.orgName        = self.orgUnitLabel.text;
    if (self.departmentLabel.text != nil) {
    myVCard.orgUnits       = @[self.departmentLabel.text];
    }
    myVCard.title          = self.titleLabel.text;
    myVCard.note           = self.weChatNumLabel.text;
    myVCard.mailer         = self.emailLabel.text;


    //数据保存到服务器


    [[WCXMPPTool sharedWCXMPPTool].vCard updateMyvCardTemp:myVCard];


}

@end
