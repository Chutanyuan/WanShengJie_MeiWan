//
//  StateNewTableViewCell.h
//  MeiWan
//
//  Created by user_kevin on 16/11/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StateNewTableViewCellDelegate <NSObject>

-(void)PinglunClickPushWithUserID:(double)USERID StateID:(double)STATEID Dictionary:(NSDictionary *)userStateMessage;
- (void)touchUpInsidImageView:(NSMutableArray *)photos PhotosTag:(NSInteger)PhotosTag;
- (void)headerImageViewTapGes:(NSDictionary *)UserStateMessage;

@end

@interface StateNewTableViewCell : UITableViewCell

@property(nonatomic,strong)NSDictionary * UserMessage;
@property(nonatomic,strong)UIImageView * imageview;
@property(nonatomic,strong)UIScrollView * scrollview;

@property(nonatomic,weak)id<StateNewTableViewCellDelegate>delegate;

@end
