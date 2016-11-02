//
//  StateAllController.m
//  MeiWan
//
//  Created by user_kevin on 16/11/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "StateAllController.h"
#import "stateTitleView.h"
#import "StateNewTableViewCell.h"
#import "MeiWan-Swift.h"
#import "SBJsonParser.h"
#import "MJRefresh.h"
#import "LoginViewController.h"


#define limit_num 6

@interface StateAllController ()<UITableViewDelegate,UITableViewDataSource,stateTitleViewDelegate>
{
    int flag;
    int offsets;
    UITableView * tableview;
    MBProgressHUD *HUD;
}

@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation StateAllController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    flag = 1;
    offsets = 0;
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"78cdf8"]];
    self.navigationController.navigationBar.hidden = YES;

    stateTitleView * view = [[stateTitleView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, 64)];
    view.delegate = self;
    view.backgroundColor = [CorlorTransform colorWithHexString:@"78cdf8"];
    [self.view addSubview:view];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, dtScreenWidth, dtScreenHeight-64) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
    [self findStatesAroundOffset:[NSNumber numberWithInt:offsets] limit:[NSNumber numberWithInt:limit_num]];
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableview.mj_header beginRefreshing];
       
        [self findStatesAroundOffset:[NSNumber numberWithInt:offsets] limit:[NSNumber numberWithInt:limit_num]];
        
    }];
    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [tableview.mj_footer beginRefreshing];
        offsets+= limit_num;
        [self findStatesAroundOffset:[NSNumber numberWithInt:offsets] limit:[NSNumber numberWithInt:limit_num]];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StateNewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[StateNewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.UserMessage = self.dataArray[indexPath.row];
    return cell;
}

-(void)buttonclickAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"最新"]) {
        flag = 1;
    }else if ([sender.titleLabel.text isEqualToString:@"官方"]){
        flag = 0;
    }else if ([sender.titleLabel.text isEqualToString:@"约会"]){
        flag = 2;
    }
}
- (void)findStatesAroundOffset:(NSNumber *)offset limit:(NSNumber *)limit
{
    int intoffset = [offset intValue];
    if (intoffset==0) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.color = [UIColor grayColor];
        HUD.labelText = @"正在加载";
        HUD.dimBackground = NO;
    }
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector findAroundStates:session offset:offset limit:limit receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSDictionary * json = [parser objectWithData:data];
        int statues = [json[@"status"] intValue];
        if (statues==0) {
            if (intoffset==0) {
                
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:json[@"entity"]];
                [tableview.mj_header endRefreshing];
                [HUD hide:YES afterDelay:0.3];
                
            }else{
                
                [self.dataArray addObjectsFromArray:json[@"entity"]];
                [tableview.mj_footer endRefreshing];

            }
            [tableview reloadData];
        }else if (statues==1){
            [self loginPush];
        }
    }];
}
- (void)loginPush
{
    [PersistenceManager setLoginSession:@""];
    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    lv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lv animated:YES];
}
@end
