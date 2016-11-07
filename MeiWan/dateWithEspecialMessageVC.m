//
//  dateWithEspecialMessageVC.m
//  MeiWan
//
//  Created by user_kevin on 16/11/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "dateWithEspecialMessageVC.h"
#import "especialDateTableViewCell.h"
@interface dateWithEspecialMessageVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * sectionOneTitle;
    NSArray * sectionTwoTitle;
    NSArray * sectionThreeTitle;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation dateWithEspecialMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    sectionOneTitle = @[@"主题",@"时间",@"地点"];
    sectionTwoTitle = @[@"约Ta",@"买单",@""];
    sectionThreeTitle = @[@"类型",@"想要美玩币"];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [FontOutSystem fontWithFangZhengSize:17.0];
    cell.textLabel.textColor = [CorlorTransform colorWithHexString:@"#848484"];
    if (indexPath.section==0) {
        
        cell = [[especialDateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = sectionOneTitle[indexPath.row];

    }else if (indexPath.section==1){
        cell.textLabel.text = sectionTwoTitle[indexPath.row];
    }else{
        cell.textLabel.text = sectionThreeTitle[indexPath.row];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return sectionOneTitle.count;
    }else if (section==1){
        return sectionTwoTitle.count;
    }else{
        return sectionThreeTitle.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
