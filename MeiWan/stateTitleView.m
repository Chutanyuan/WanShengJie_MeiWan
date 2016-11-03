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
}
@end

@implementation stateTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView * addimage = [[UIImageView alloc]initWithFrame:CGRectMake(dtScreenWidth-10-20, 32, 20, 20)];
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

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    UIImageView * imageview = (UIImageView *)[gesture view];
    static int i = 0;
    i++;
    NSLog(@"%d",i%2);
    if (i%2==1) {
        [UIView animateWithDuration:0.3 animations:^{
            imageview.transform = CGAffineTransformMakeRotation(-135*M_PI/180.0);
            
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            imageview.transform = CGAffineTransformMakeRotation(3*270*M_PI/180);
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