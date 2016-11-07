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
#import "StateOneViewController.h"
#import "showImageController.h"
#import "PlagerinfoViewController.h"
#import "MoveActionViewController.h"
#import "dateWithEspecialMessageVC.h"

#define limit_num 6

@interface StateAllController ()<UITableViewDelegate,UITableViewDataSource,stateTitleViewDelegate,StateNewTableViewCellDelegate,moveAction>
{
    int flag;
    int offsets;
    int officialOffset;
    UITableView * tableview;
    MBProgressHUD *HUD;
    MBProgressHUD *officialHUD;
    UIView * clearView;
    
    UIView * showAlphaView;
    UIView * showView;
}

@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * officialDataArray;

@end

@implementation StateAllController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    flag = 1;
    offsets = 0;
    officialOffset = 0;
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.officialDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"78cdf8"]];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];

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
    [self findOfficialStateOffset:officialOffset limit:limit_num];
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableview.mj_header beginRefreshing];
        if (flag==1) {
            offsets = 0;
            [self.dataArray removeAllObjects];
            [self findStatesAroundOffset:[NSNumber numberWithInt:offsets] limit:[NSNumber numberWithInt:limit_num]];
        }else if (flag==0){
            officialOffset = 0;
            [self.officialDataArray removeAllObjects];
            [self findOfficialStateOffset:officialOffset limit:limit_num];
        }else{
            [tableview.mj_header endRefreshing];
        }
        
    }];
    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [tableview.mj_footer beginRefreshing];
        
        if (flag==1) {
            offsets+= limit_num;
            [self findStatesAroundOffset:[NSNumber numberWithInt:offsets] limit:[NSNumber numberWithInt:limit_num]];
        }else if (flag==0){
            officialOffset += limit_num;
            [self findOfficialStateOffset:officialOffset limit:limit_num];
        }else{
            [tableview.mj_footer endRefreshing];
        }
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (flag==0) {
        return self.officialDataArray.count;
    }else if (flag==1){
        return self.dataArray.count;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier%ld",(long)indexPath.row];
    StateNewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[StateNewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.scrollview.delegate = self;
    [cell.imageview removeFromSuperview];
    if (flag==1) {
        cell.UserMessage = self.dataArray[indexPath.row];
    }else if (flag==0){
        cell.UserMessage = self.officialDataArray[indexPath.row];
    }else if (flag==2){
        
    }
    cell.delegate = self;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StateOneViewController * oneMessage = [[StateOneViewController alloc]init];
    oneMessage.stateMessage = self.dataArray[indexPath.row];;
    oneMessage.title = @"动态详情";
    oneMessage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:oneMessage animated:YES];
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
    [tableview reloadData];
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
                
                self.dataArray = json[@"entity"];
                [tableview reloadData];
                [tableview.mj_header endRefreshing];
                [HUD hide:YES afterDelay:0.3];
                
            }else{
                
                [self.dataArray addObjectsFromArray:json[@"entity"]];
                [tableview reloadData];
                [tableview.mj_footer endRefreshing];

            }

        }else if (statues==1){
            [self loginPush];
        }
    }];
}
/** 官方动态 */
- (void)findOfficialStateOffset:(int)offset limit:(int)limit
{
    if (offset==0) {
        officialHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        officialHUD.color = [UIColor grayColor];
        officialHUD.labelText = @"正在加载";
        officialHUD.dimBackground = NO;
    }
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector findStates:session userId:[NSNumber numberWithInt:100000] offset:[NSNumber numberWithInt:offset] limit:[NSNumber numberWithInt:limit] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSDictionary * json = [parser objectWithData:data];
        int status = [json[@"status"] intValue];
        if (status == 0) {
            
            if (offset==0) {
                
                self.officialDataArray = json[@"entity"];
                [tableview reloadData];
                [tableview.mj_header endRefreshing];
                [officialHUD hide:YES afterDelay:0.3];
                
            }else{
                
                [self.officialDataArray addObjectsFromArray:json[@"entity"]];
                [tableview reloadData];
                [tableview.mj_footer endRefreshing];
                
            }
            
        }else if (status==1){
            [self loginPush];
        }else{
            
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

-(void)PinglunClickPushWithUserID:(double)USERID StateID:(double)STATEID Dictionary:(NSDictionary *)userStateMessage
{
    StateOneViewController * oneMessage = [[StateOneViewController alloc]init];
    oneMessage.stateMessage = userStateMessage;
    oneMessage.title = @"动态详情";
    oneMessage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:oneMessage animated:YES];
}
/** 展示图片 */
-(void)touchUpInsidImageView:(NSMutableArray *)photos PhotosTag:(NSInteger)PhotosTag
{
    showImageController * showimage = [[showImageController alloc]init];
    showimage.imagesArray = photos;
    showimage.imageNumber = PhotosTag;
    showimage.flagType = 1000;
    showimage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:showimage animated:NO];
}
-(void)headerImageViewTapGes:(NSDictionary *)UserStateMessage
{
    /** 
      stateToPlager
     */
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:UserStateMessage[@"userId"],@"id", nil];
    [self performSegueWithIdentifier:@"stateToPlager" sender:dic];

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"stateToPlager"]) {
        PlagerinfoViewController *pv = segue.destinationViewController;
        pv.hidesBottomBarWhenPushed = YES;
        pv.playerInfo = sender;
    }
    if ([segue.identifier isEqualToString:@"newStatus"]) {
        MoveActionViewController * mv = segue.destinationViewController;
        self.navigationController.navigationBar.hidden = NO;
        mv.delegate = self;
    }
}

/** 添加约会信息或者是动态 */
-(void)AddState
{
    [self performSegueWithIdentifier:@"newStatus" sender:nil];
}
-(void)back
{
    [tableview.mj_header beginRefreshing];
}
-(void)AddYueHui
{
    NSArray * titleArray = @[@"线上点歌",@"视屏聊天",@"聚餐",@"线下K歌",@"夜店达人",@"叫醒服务",@"影伴",@"运动健身",@"LOL"];
    NSArray * imageNameArray = @[@"sing",@"video-chat",@"dining",@"sing-expert",@"go-nightclubbing",@"clock",@"shadow-with",@"sports",@"lol"];
    
    clearView = [[UIView alloc]initWithFrame:self.view.window.frame];
    UIView * grayview = [[UIView alloc]initWithFrame:clearView.frame];
    grayview.backgroundColor = [UIColor blackColor];
    grayview.alpha = 0.5;
    [clearView addSubview:grayview];
    [self.view.window addSubview:clearView];
    for (int i = 0; i<9; i++) {
        
        UIButton * chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.center = CGPointMake( dtScreenWidth/6 + i%3*dtScreenWidth/3,150 + i/3*120);
        if (IS_IPHONE_5) {
            chooseButton.bounds = CGRectMake(0, 0, 50, 50 );
            chooseButton.layer.cornerRadius = 25;
        }else{
            chooseButton.bounds = CGRectMake(0, 0, 64, 64 );
            chooseButton.layer.cornerRadius = 32;
        }
        chooseButton.clipsToBounds = YES;
        [chooseButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameArray[i]]] forState:UIControlStateNormal];
        
        chooseButton.titleLabel.font = [FontOutSystem fontWithFangZhengSize:15];
        chooseButton.tag = i;
        [chooseButton addTarget:self action:@selector(projectLabelSelector:) forControlEvents:UIControlEventTouchUpInside];
        
        [clearView addSubview:chooseButton];
        
        UILabel * titlelabel = [[UILabel alloc]init];
        titlelabel.text = [NSString stringWithFormat:@"%@",titleArray[i]];
        titlelabel.font = [FontOutSystem fontWithFangZhengSize:15.0];
        titlelabel.textColor = [UIColor whiteColor];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        
        CGSize size_titlelabal = [titlelabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titlelabel.font,NSFontAttributeName, nil]];
        titlelabel.frame = CGRectMake(chooseButton.center.x-size_titlelabal.width/2, chooseButton.frame.origin.y+chooseButton.frame.size.width+10, size_titlelabal.width, size_titlelabal.height);
        
        [clearView addSubview:titlelabel];
    }

}
- (void)projectLabelSelector:(UIButton *)sender
{
    clearView.hidden = YES;
    NSDictionary * dictionary = [NSDictionary dictionaryWithDictionary:[PersistenceManager getLoginUser]];
    int isAudit = [dictionary[@"isAudit"] intValue];
    if (isAudit==1) {

        dateWithEspecialMessageVC * especialDate = [[dateWithEspecialMessageVC alloc]init];
        self.navigationController.navigationBar.hidden = NO;
        especialDate.title = @"发布约会";
        especialDate.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:especialDate animated:YES];

    }else{
        [self ZDYshowAlertView:@"由于您还不是达人用户尚无法发布约会信息"];
    }
}

#pragma mark----zhanshi
-(void)ZDYshowAlertView:(NSString *)message
{
    showAlphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight)];
    showAlphaView.backgroundColor = [UIColor blackColor];
    showAlphaView.alpha = 0.2;
    [self.view addSubview:showAlphaView];

    showView = [[UIView alloc]init];
    showView.center = CGPointMake(dtScreenWidth/2, dtScreenHeight/2);
    showView.bounds = CGRectMake(0, 0, dtScreenWidth-40, 200);
    showView.backgroundColor = [UIColor whiteColor];
    showView.layer.cornerRadius = 5;
    showView.clipsToBounds = YES;
    showView.layer.borderColor = [CorlorTransform colorWithHexString:@"#e8e8e8"].CGColor;
    showView.layer.borderWidth = 0.5;
    [self.view addSubview:showView];
    
    UILabel * titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, showView.frame.size.width, 40)];
    titlelabel.font = [FontOutSystem fontWithFangZhengSize:17.0];
    titlelabel.text = @"温馨提示";
    titlelabel.textAlignment = NSTextAlignmentCenter;
    [showView addSubview:titlelabel];
    
    UILabel * contentText = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, showView.frame.size.width, showView.frame.size.height-44-40)];
    contentText.textAlignment = NSTextAlignmentCenter;
    contentText.numberOfLines = 0;
    contentText.text = message;
    contentText.backgroundColor = [CorlorTransform colorWithHexString:@"#e8e8e8"];
    contentText.font = [FontOutSystem fontWithFangZhengSize:15.0];
    [showView addSubview:contentText];
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0,showView.frame.size.height-44, showView.frame.size.width/2, 44);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[CorlorTransform colorWithHexString:@"#b2b2b2"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(sureButton:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:cancel];
    
    UIButton * sure = [UIButton buttonWithType:UIButtonTypeCustom];
    [sure setTitleColor:[CorlorTransform colorWithHexString:@"#78cdf8"] forState:UIControlStateNormal];
    sure.frame = CGRectMake(showView.frame.size.width/2, showView.frame.size.height-44, showView.frame.size.width/2, 44);
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setBackgroundImage:[UIImage imageNamed:@"OK"] forState:UIControlStateHighlighted];
    if (message.length>70) {
        sure.tag = 100;
    }else{
        sure.tag = 0;
    }
    [sure addTarget:self action:@selector(sureButton:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:sure];
}

- (void)sureButton:(UIButton *)sender
{
    showAlphaView.alpha = 0;
    showView.alpha = 0;
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if (sender.tag==100) {

        }
    }
}
@end
