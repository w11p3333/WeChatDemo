//
//  WCeditVCardViewController.m
//  WeChat
//
//  Created by 卢良潇 on 16/1/17.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

#import "WCeditVCardViewController.h"

@interface WCeditVCardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end



@implementation WCeditVCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置标题
    self.title =self.cell.textLabel.text;
    
    self.textField.text = self.cell.detailTextLabel.text;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)saveBtn:(id)sender {
    //1.改变cell中detaillabel的值
    self.cell.detailTextLabel.text = self.textField.text;
    
    [self.cell layoutSubviews];//cell重新布局 刷新
    //2.销毁当前控制器
    [self.navigationController popViewControllerAnimated:YES];
    //3.把数据传到上个控制器
    if ([self.delegate respondsToSelector:@selector(WCeditVCardViewController:didFinishSave:)]) {
        [self.delegate WCeditVCardViewController:self didFinishSave:sender];
    }
    
}



@end
