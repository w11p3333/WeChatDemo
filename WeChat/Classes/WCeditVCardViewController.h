//
//  WCeditVCardViewController.h
//  WeChat
//
//  Created by 卢良潇 on 16/1/17.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCeditVCardViewController;

@protocol WCeditVCardViewControllerDelegate <NSObject>

-(void)WCeditVCardViewController:(WCeditVCardViewController *)editVc didFinishSave:(id)sender;


@end

@interface WCeditVCardViewController : UITableViewController
//传cell
@property(nonatomic,strong)UITableViewCell *cell;
@property(nonatomic,weak)id<WCeditVCardViewControllerDelegate> delegate; 

@end
