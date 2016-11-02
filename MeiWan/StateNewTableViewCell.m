//
//  StateNewTableViewCell.m
//  MeiWan
//
//  Created by user_kevin on 16/11/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "StateNewTableViewCell.h"
#import "UserInfo.h"


@interface StateNewTableViewCell ()


@property(nonatomic,strong)UIImageView * headerImageView;
@property(nonatomic,strong)UILabel * nickname;
@property(nonatomic,strong)UILabel * age;
@property(nonatomic,strong)UIImageView * sex;
@property(nonatomic,strong)UILabel * time;
@property(nonatomic,strong)UILabel * lookNum;
@property(nonatomic,strong)UILabel * content;
@property(nonatomic,strong)UIScrollView * scrollview;
@property(nonatomic,strong)UIButton * zan;
@property(nonatomic,strong)UIButton * pinglun;
@property(nonatomic,strong)UIButton * fenxiang;
@property(nonatomic,strong)UILabel * zanNum;
@property(nonatomic,strong)UILabel * pinglunNum;
@property(nonatomic,strong)UITextField * textfiled;


@end

@implementation StateNewTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        self.headerImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.headerImageView.clipsToBounds = YES;
        self.headerImageView.layer.cornerRadius = 30;
        [self addSubview:self.headerImageView];
        
        _nickname = [[UILabel alloc]init];
        [self addSubview:_nickname];
        
        
    }
    return self;
}
-(void)setUserMessage:(NSDictionary *)UserMessage
{
    NSLog(@"%@",UserMessage);
    NSURL * url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",UserMessage[@"user"][@"headUrl"]]];
    NSURL * url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",UserMessage[@"user"][@"headUrl"]]];
    [_headerImageView sd_setImageWithURL:url1 placeholderImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url2]]];
    
    UserInfo * userinfo = [[UserInfo alloc]initWithDictionary:UserMessage[@"user"]];
    _nickname.text = userinfo.nickname;
    _nickname.font = [FontOutSystem fontWithFangZhengSize:14];
    CGSize size_nickname = [_nickname.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_nickname.font,NSFontAttributeName, nil]];
    _nickname.frame = CGRectMake(_headerImageView.frame.origin.x+_headerImageView.frame.size.width+10, _headerImageView.frame.origin.y+5, size_nickname.width, size_nickname.height);
    _nickname.textColor = [UIColor blackColor];
    
    CGRect frame = self.frame;
    frame.size.height = _headerImageView.frame.size.height+20;
    self.frame = frame;
}
@end
