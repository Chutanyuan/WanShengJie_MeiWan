//
//  StateNewTableViewCell.m
//  MeiWan
//
//  Created by user_kevin on 16/11/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "StateNewTableViewCell.h"
#import "UserInfo.h"
#import "MeiWan-Swift.h"

@interface StateNewTableViewCell ()

@property(nonatomic,strong)NSMutableArray * statePhotots;
@property(nonatomic,strong)UIImageView * headerImageView;
@property(nonatomic,strong)UILabel * nickname;
@property(nonatomic,strong)UILabel * age;
@property(nonatomic,strong)UIImageView * sex;
@property(nonatomic,strong)UILabel * time;
@property(nonatomic,strong)UILabel * lookNum;
@property(nonatomic,strong)UILabel * content;
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
        
        _statePhotots = [[NSMutableArray alloc]initWithCapacity:0];
        
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        self.headerImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.headerImageView.clipsToBounds = YES;
        self.headerImageView.layer.cornerRadius = 30;
        [self addSubview:self.headerImageView];
        
        _nickname = [[UILabel alloc]init];
        [self addSubview:_nickname];
        
        _age = [[UILabel alloc]init];
        [self addSubview:_age];
        
        _sex = [[UIImageView alloc]init];
        [self addSubview:_sex];
        
        _time = [[UILabel alloc]init];
        [self addSubview:_time];
        
        _lookNum = [[UILabel alloc]init];
        [self addSubview:_lookNum];
        
        _content = [[UILabel alloc]init];
        [self addSubview:_content];
        
        _zan = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_zan];
        
        _zanNum = [[UILabel alloc]init];
        [self addSubview:_zanNum];
        
        _pinglun = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_pinglun];
        
        _pinglunNum = [[UILabel alloc]init];
        [self addSubview:_pinglunNum];
        
        _fenxiang = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_fenxiang];
        
        _textfiled = [[UITextField alloc]init];
        [self addSubview:_textfiled];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            _scrollview = [[UIScrollView alloc]init];
            _scrollview.showsHorizontalScrollIndicator = NO;
            [self addSubview:_scrollview];

        });
        
    }
    return self;
}
-(void)setUserMessage:(NSDictionary *)UserMessage
{
    NSLog(@"%@",UserMessage);

    NSURL * url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",UserMessage[@"user"][@"headUrl"]]];
    [_headerImageView sd_setImageWithURL:url2 placeholderImage:nil];
    UserInfo * userinfo = [[UserInfo alloc]initWithDictionary:UserMessage[@"user"]];
    _nickname.text = userinfo.nickname;
    _nickname.font = [FontOutSystem fontWithFangZhengSize:14];
    CGSize size_nickname = [_nickname.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_nickname.font,NSFontAttributeName, nil]];
    _nickname.frame = CGRectMake(_headerImageView.frame.origin.x+_headerImageView.frame.size.width+10, _headerImageView.frame.origin.y+5, size_nickname.width, size_nickname.height);
    _nickname.textColor = [UIColor blackColor];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int birthyear = userinfo.year;
    int age = yearnow - birthyear;
    self.age.text = [NSString stringWithFormat:@"%d",age];
    _age.font = [FontOutSystem fontWithFangZhengSize:14];
    _age.textColor = [CorlorTransform colorWithHexString:@"#B7B7B7"];
    CGSize size_age = [self.age.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.age.font,NSFontAttributeName, nil]];
    self.age.frame = CGRectMake(_nickname.frame.origin.x+_nickname.frame.size.width+5, _nickname.frame.origin.y+_nickname.frame.size.height-size_age.height, size_age.width, size_age.height);
    
    self.sex.frame = CGRectMake(self.age.frame.origin.x+5+self.age.frame.size.width, self.age.frame.origin.y, size_age.height, size_age.height);
    if (userinfo.gender==0) {
        self.sex.image = [UIImage imageNamed:@"nansheng_logo"];
    }else{
        self.sex.image = [UIImage imageNamed:@"nvsheng_logo"];
    }
    
   
    _lookNum.font = [FontOutSystem fontWithFangZhengSize:14.0];
    if ([UserMessage objectForKey:@"user"][@"unionLevel"]!=nil) {
        _lookNum.text = [NSString stringWithFormat:@"%@级公会会长",UserMessage[@"user"][@"unionLevel"]];
        _lookNum.textColor = [CorlorTransform colorWithHexString:@"#FF3102"];
    }else{
        if (userinfo.isAudit==1) {
            if (userinfo.level==0) {
                userinfo.level=1;
            }
            _lookNum.text = [NSString stringWithFormat:@"%d级达人",userinfo.level];
            _lookNum.textColor = [CorlorTransform colorWithHexString:@"#F8C027"];
        }else{
            _lookNum.text = @"普通用户";
            _lookNum.textColor = [CorlorTransform colorWithHexString:@"#5E7F99"];
        }

    }
    
    CGSize size_lookNum = [self.lookNum.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.lookNum.font,NSFontAttributeName, nil]];
    self.lookNum.frame = CGRectMake(_nickname.frame.origin.x, _nickname.frame.origin.y+size_nickname.height+5, size_lookNum.width, size_lookNum.height);

    _time.text = [DateTool getTimeDescription:[UserMessage[@"createTime"] doubleValue]];
    _time.font = [FontOutSystem fontWithFangZhengSize:12.0];

    CGSize size_timelabel = [_time.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_time.font,NSFontAttributeName, nil]];
    _time.frame = CGRectMake(dtScreenWidth-10-size_timelabel.width, _nickname.frame.size.height+_nickname.frame.origin.y-size_timelabel.height, size_timelabel.width, size_timelabel.height);
    _content.text = UserMessage[@"content"];
    _content.font = [FontOutSystem fontWithFangZhengSize:15.0];
    _content.textColor = [CorlorTransform colorWithHexString:@"#717171"];
    _content.numberOfLines = 0;
    CGSize size = CGSizeMake(dtScreenWidth-_nickname.frame.origin.x-10, 1000);
    CGSize labelsize = [self.content.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_content.font,NSFontAttributeName, nil] context:nil].size;
    _content.frame = CGRectMake(_nickname.frame.origin.x, _lookNum.frame.origin.y+_lookNum.frame.size.height+10, labelsize.width, labelsize.height);
    
    self.statePhotots = UserMessage[@"statePhotos"];
    [self.statePhotots removeObject:[NSNull null]];
    
    CGRect frame = self.frame;
    
    if (_content.frame.size.height+_content.frame.origin.y>_headerImageView.frame.origin.y+_headerImageView.frame.size.height) {
        
        if (_statePhotots.count>0) {
            _scrollview.contentSize = CGSizeMake(_scrollview.frame.size.height*_statePhotots.count, 0);

            _scrollview.frame = CGRectMake(_headerImageView.frame.origin.x, _content.frame.origin.y+_content.frame.size.height+10, dtScreenWidth-_headerImageView.frame.origin.x*2, (dtScreenWidth-_headerImageView.frame.origin.x*2)/2);
            
            frame.size.height = _scrollview.frame.origin.y+_scrollview.frame.size.height+20;
        }else{
            frame.size.height = _content.frame.origin.y+_content.frame.size.height+20;
        }
        
    }else{
        
        if (_statePhotots.count>0) {
            _scrollview.frame = CGRectMake(_headerImageView.frame.origin.x, _headerImageView.frame.origin.y+_headerImageView.frame.size.height+10, dtScreenWidth-_headerImageView.frame.origin.x*2, (dtScreenWidth-_headerImageView.frame.origin.x*2)/2);
            _scrollview.contentSize = CGSizeMake(_scrollview.frame.size.height*_statePhotots.count, 0);
            
            frame.size.height = _scrollview.frame.origin.y+_scrollview.frame.size.height+20;
            
        }else{
            frame.size.height = _headerImageView.frame.size.height+20;
        }
        
    }
    
    
    [_statePhotots enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(_scrollview.frame.size.height*idx, 0, _scrollview.frame.size.height-2.5, _scrollview.frame.size.height)];
        _imageview.contentMode = UIViewContentModeScaleAspectFill;
        _imageview.clipsToBounds = YES;
        [_imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1",obj]]];

        [_scrollview addSubview:_imageview];
        
    }];
    
    frame.size.height = frame.size.height+30;
    self.frame = frame;

    _pinglun.frame = CGRectMake(dtScreenWidth-10-20-5-10, frame.size.height-30, 20, 20);
    [_pinglun setImage:[UIImage imageNamed:@"peiwan_discuss"] forState:UIControlStateNormal];
    [_pinglun addTarget:self action:@selector(pinglunClick:) forControlEvents:UIControlEventTouchUpInside];
    _pinglunNum.frame = CGRectMake(_pinglun.frame.origin.x+20+5, _pinglun.frame.origin.y, 10, 20);
    _pinglunNum.text = [NSString stringWithFormat:@"%@",UserMessage[@"count"]];
    _pinglunNum.textColor = [CorlorTransform colorWithHexString:@"#AEBFBE"];
    _pinglunNum.font = [FontOutSystem fontWithFangZhengSize:12.0];
    _zan.frame = CGRectMake(_pinglun.frame.origin.x-45, _pinglun.frame.origin.y, 20, 20);
    int isLike = [UserMessage[@"isLike"] intValue];
    if (isLike == 0) {
        [_zan setImage:[UIImage imageNamed:@"peiwan_praise"] forState:UIControlStateNormal];
        _zan.tag = 0;
        _zanNum.textColor = [CorlorTransform colorWithHexString:@"#AEBFBE"];
    }else{
        [_zan setImage:[UIImage imageNamed:@"peiwan_praise1"] forState:UIControlStateNormal];
        _zan.tag = 1;
        _zanNum.textColor = [CorlorTransform colorWithHexString:@"#26A3E5"];
    }
    _zanNum.text = [NSString stringWithFormat:@"%@",UserMessage[@"likes"]];
    _zanNum.font = [FontOutSystem fontWithFangZhengSize:12.0];
    _zanNum.frame = CGRectMake(_zan.frame.origin.x+_zan.frame.size.width+5, _zan.frame.origin.y, 10, 20);
    [_zan addTarget:self action:@selector(zanClike:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)pinglunClick:(UIButton *)sender
{
    
}
- (void)zanClike:(UIButton *)sender
{
    
}
@end
