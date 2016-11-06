//
//  stateTitleView.m
//  
//
//  Created by user_kevin on 16/11/1.
//
//

#import "stateTitleView.h"

@interface stateTitleView ()
{
    UIImageView * redLine;
    UIButton * button;
    UIButton * button1;
    UIButton * button2;
    
    UIView * grayview;
    UIView * showlabel;
    UIImageView * addimage;
    int flag;
}
@end

@implementation stateTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        flag = 1;
        addimage = [[UIImageView alloc]initWithFrame:CGRectMake(dtScreenWidth-10-20, 32, 20, 20)];
        addimage.image = [UIImage imageNamed:@"photoAdd"];
        
        [self addSubview:addimage];
        addimage.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [addimage addGestureRecognizer:tapGesture];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.center = CGPointMake(self.center.x, self.center.y+10);
        button.bounds = CGRectMake(0, 0, 80, 44);
        [button setTitle:@"最新" forState:UIControlStateNormal];
        button.titleLabel.font = [FontOutSystem fontWithFangZhengSize:17.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(button.frame.origin.x-80, button.frame.origin.y, 80, 44);
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button1 setTitle:@"官方" forState:UIControlStateNormal];
        button1.titleLabel.font = [FontOutSystem fontWithFangZhengSize:15.0];
        [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button1];
        
        button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(button.frame.origin.x+80, button.frame.origin.y, 80, 44);
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button2 setTitle:@"约会" forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button2.titleLabel.font = [FontOutSystem fontWithFangZhengSize:15.0];
        [self addSubview:button2];
        
        redLine = [[UIImageView alloc]initWithFrame:CGRectMake(button.frame.origin.x, 63, 80, 1)];
        redLine.backgroundColor = [UIColor redColor];
        [self addSubview:redLine];
        [self redLineFrameANDButtonTitleFont];
    }
    return self;
}

+ (UIWindow *)lastWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    return app.windows.lastObject;
}
- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    UIImageView * imageview = (UIImageView *)[gesture view];
    if (flag==1) {
        [UIView animateWithDuration:0.3 animations:^{
            imageview.transform = CGAffineTransformMakeRotation(-135*M_PI/180.0);
            
        } completion:^(BOOL finished) {
            UIApplication * app = [UIApplication sharedApplication];
            UIWindow * window = app.windows.lastObject;
            grayview = [[UIView alloc]initWithFrame:window.frame];
            grayview.backgroundColor = [UIColor blackColor];
            grayview.alpha = 0.5;
            [window addSubview:grayview];
            
            showlabel = [[UIView alloc]initWithFrame:CGRectMake(60, 104, dtScreenWidth-120, 200)];
            showlabel.userInteractionEnabled = YES;
            showlabel.backgroundColor = [UIColor whiteColor];
            showlabel.layer.cornerRadius = 10;
            showlabel.clipsToBounds = YES;
            [window addSubview:showlabel];

            UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, showlabel.frame.size.width, 44)];
            title.text = @"发布类型";
            title.textColor = [CorlorTransform colorWithHexString:@"#0D8FA4"];
            title.font = [FontOutSystem fontWithFangZhengSize:20];
            title.textAlignment = NSTextAlignmentCenter;
            [showlabel addSubview:title];
            
            UIButton * Yue = [UIButton buttonWithType:UIButtonTypeCustom];
            Yue.backgroundColor = [CorlorTransform colorWithHexString:@"#0D8FA4"];
            [Yue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [Yue setTitle:@"约会" forState:UIControlStateNormal];
            Yue.frame = CGRectMake(0, 44, showlabel.frame.size.width/2, showlabel.frame.size.height-44);
            [Yue addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [showlabel addSubview:Yue];
            
            
            UIButton * state = [UIButton buttonWithType:UIButtonTypeCustom];
            state.backgroundColor = [UIColor whiteColor];
            [state setTitleColor:[CorlorTransform colorWithHexString:@"#0D8FA4"] forState:UIControlStateNormal];

            [state setTitle:@"动态" forState:UIControlStateNormal];
            state.frame = CGRectMake(showlabel.frame.size.width/2, 44, showlabel.frame.size.width/2, showlabel.frame.size.height-44);
            [state addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [showlabel addSubview:state];
            
            UILabel * colorLine = [[UILabel alloc]initWithFrame:CGRectMake(5, 44, showlabel.frame.size.width-10, 1)];
            colorLine.backgroundColor = title.textColor;
            [showlabel addSubview:colorLine];
            
            flag = 0;

        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            imageview.transform = CGAffineTransformMakeRotation(3*270*M_PI/180);
            
        } completion:^(BOOL finished) {
            grayview.hidden = YES;
            showlabel.hidden = YES;
            
            flag = 1;

        }];
    }
}
- (void)buttonClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        redLine.frame = CGRectMake(sender.frame.origin.x, 63, 80, 1);
    }];
    [self redLineFrameANDButtonTitleFont];
   
    [self.delegate buttonclickAction:sender];

}
- (void)chooseButtonClick:(UIButton *)sender
{
    grayview.hidden = YES;
    showlabel.hidden = YES;
    
    if ([sender.titleLabel.text isEqualToString:@"约会"]) {
        [self.delegate AddYueHui];
    }
    if ([sender.titleLabel.text isEqualToString:@"动态"]) {
        [self.delegate AddState];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        addimage.transform = CGAffineTransformMakeRotation(3*270*M_PI/180);
        
    } completion:^(BOOL finished) {
        flag = 1;
    }];
}
- (void)redLineFrameANDButtonTitleFont
{
    if (redLine.frame.origin.x==button.frame.origin.x) {
        button.titleLabel.font = [FontOutSystem fontWithFangZhengSize:17.0];
    }else{
        button.titleLabel.font = [FontOutSystem fontWithFangZhengSize:15.0];
    }
    if (redLine.frame.origin.x==button1.frame.origin.x) {
        button1.titleLabel.font = [FontOutSystem fontWithFangZhengSize:17.0];
    }else{
        button1.titleLabel.font = [FontOutSystem fontWithFangZhengSize:15.0];
    }
    if (redLine.frame.origin.x==button2.frame.origin.x) {
        button2.titleLabel.font = [FontOutSystem fontWithFangZhengSize:17.0];
    }else{
        button2.titleLabel.font = [FontOutSystem fontWithFangZhengSize:15.0];
    }

}
@end
