//
//  FriendListTableViewCell.h
//  MeiWan
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headIg;
@property (strong, nonatomic) IBOutlet UILabel *nickname;
@property (strong, nonatomic) IBOutlet UIView *ageAndSex;
@property (strong, nonatomic) IBOutlet UIImageView *sexImage;
@property (strong, nonatomic) IBOutlet UILabel *age;
@property (strong, nonatomic) NSDictionary *friendInfoDic;
@end
