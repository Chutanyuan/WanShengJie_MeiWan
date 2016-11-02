//
//  stateTitleView.h
//  
//
//  Created by user_kevin on 16/11/1.
//
//

#import <UIKit/UIKit.h>

@protocol stateTitleViewDelegate <NSObject>

- (void)buttonclickAction:(UIButton *)sender;

@end

@interface stateTitleView : UIView

@property(nonatomic,weak)id<stateTitleViewDelegate>delegate;

@end
