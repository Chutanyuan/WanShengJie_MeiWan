//
//  especialDateTableViewCell.m
//  MeiWan
//
//  Created by user_kevin on 16/11/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "especialDateTableViewCell.h"

@implementation especialDateTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(dtScreenWidth/2, 0, dtScreenWidth/2, 44);
        [button setTitle:@"you" forState:UIControlStateNormal];
        [self addSubview:button];
    }
    return self;
}
@end
