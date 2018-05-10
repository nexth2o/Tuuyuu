//
//  MineCommentViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/26.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineCommentViewController.h"
#import "MineCommentHeaderCell.h"
#import "MineCommentCell.h"
#import "ShareCommentViewController.h"
#import "LoginViewController.h"
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"
#import "MJChiBaoZiFooter2.h"
#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYBackFooter.h"



@interface MineCommentViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *contentView;
    NSMutableArray *commentArray;
    
    UIImageView *tipsImage;
    UILabel *tipsLabel;
    
    NSInteger pageNumber;
    NSInteger pageLen;
    NSDictionary *jsonDic;
}

@end

@implementation MineCommentViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor clearColor];
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_bg"] forState:UIControlStateNormal];
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        
        contentView.delegate = self;
        
        contentView.dataSource = self;
        
        contentView.separatorStyle = NO;
        
        contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        //去除底部多余分割线
        contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 纯动画 无状态和时间
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        
        header.stateLabel.hidden = NO;
        // 设置header
        contentView.mj_header = header;
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        contentView.mj_header.automaticallyChangeAlpha = YES;
        
        // 上拉刷新
        contentView.mj_footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        contentView.estimatedRowHeight = 0;
        contentView.estimatedSectionHeaderHeight = 0;
        contentView.estimatedSectionFooterHeight = 0;
        
        if (@available(iOS 11.0, *)) {
            contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [self.view addSubview:contentView];
        
        [self.view bringSubviewToFront:navigationBar];
        
        tipsImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200*SCALE)/2, 200*SCALE, 200*SCALE, 200*SCALE)];
        tipsImage.image = [UIImage imageNamed:@"no_net"];
        [tipsImage setHidden:YES];
        [self.view addSubview:tipsImage];
        
        tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tipsImage.frame)+10*SCALE, SCREEN_WIDTH, 20*SCALE)];
        tipsLabel.text = @"暂时没有评论呦～";
        [tipsLabel setHidden:YES];
        tipsLabel.textColor = [UIColor darkGrayColor];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:tipsLabel];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    [self showLoadHUDMsg:@"努力加载中..."];
    [self requestData];
}

- (void)requestData {
    [contentView setHidden:YES];
    pageNumber = 0;
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%zd", pageNumber], @"page", nil];
    
    [HttpClientService requestMyrateinfo:paramDic success:^(id responseObject) {
        
        NSString *dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //json数据当中没有 \n \r \t 等制表符，当后台给出有问题时，我们需要对json数据过滤
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSData *utf8Data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        jsonDic = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            commentArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"info"]];
            
            if ([commentArray count] > 0) {
                
                [contentView setHidden:NO];
                
                [tipsImage setHidden:YES];
                [self.view sendSubviewToBack:tipsImage];
                
                [tipsLabel setHidden:YES];
                [self.view sendSubviewToBack:tipsLabel];
        
                [contentView reloadData];
                
                pageNumber++;
                
            }else {
                [contentView setHidden:YES];
                
                [tipsImage setHidden:NO];
                [self.view bringSubviewToFront:tipsImage];
                
                [tipsLabel setHidden:NO];
                [self.view bringSubviewToFront:tipsLabel];
            }
            
            [self hideLoadHUD:YES];
            
            
        }else if (status == 202) {
            [self showMsg:@"您的登录状态失效，请重新登录"];
            [self hideLoadHUD:YES];
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else {
            [self hideLoadHUD:YES];
            [self showMsg:[NSString stringWithFormat:@"错误码%zd", status]];
            
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        NSLog(@"请求评价信息失败");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [commentArray count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 150*SCALE;
    }else {
        
        if ([commentArray[indexPath.row-1][@"feedback_msg"] length] > 0) {
            NSString *tempStr = [NSString stringWithFormat:@"商家回复：%@", commentArray[indexPath.row-1][@"feedback_msg"]];
            CGRect lbsize = [tempStr boundingRectWithSize:CGSizeMake(260*SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12*SCALE]} context:nil];
            return 210*SCALE+lbsize.size.height+10*SCALE;
            
        }else {
            return 210*SCALE;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    static NSString *myCellIdentifier2 = @"MyCellIdentifier2";
    

    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        MineCommentHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
        if (cell == nil) {
            cell = [[MineCommentHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (commentArray.count > 0) {
            cell.title.text = commentArray[indexPath.row][@"nick_name"];
            cell.subTitle.text = [NSString stringWithFormat:@"已贡献%@条评价", [jsonDic objectForKey:@"total"]];
        }else {
            cell.subTitle.text = [NSString stringWithFormat:@"已贡献%@条评价", [jsonDic objectForKey:@"total"]];
        }
    
        return cell;
        
    }else {
        MineCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier2];
        if (cell == nil) {
            cell = [[MineCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.storeName.text = commentArray[indexPath.row-1][@"cvs_name"];
        
        cell.name.text = commentArray[indexPath.row-1][@"nick_name"];
        cell.time.text = commentArray[indexPath.row-1][@"rate_time"];
        
        cell.type.text = commentArray[indexPath.row-1][@"rate_msg"];
        
        //评论星
        UIImage *halfStar = [UIImage imageNamed:@"score_star_half"];
        UIImage *grayStar = [UIImage imageNamed:@"score_star_gray"];
        UIImage *yellowStar = [UIImage imageNamed:@"score_star_yellow"];
        
        double count = [commentArray[indexPath.row-1][@"cvs_rate"] doubleValue];
        
        for (int i = 0; i < 5; i++) {
            
            if ((count-i) >= 0.25 && (count-i) < 0.75) {//半星
                if (i==0) {
                    cell.star1.image = halfStar;
                }else if (i==1) {
                    cell.star2.image = halfStar;
                }else if (i==2) {
                    cell.star3.image = halfStar;
                }else if (i==3) {
                    cell.star4.image = halfStar;
                }else if (i==4) {
                    cell.star5.image = halfStar;
                }
            }else if ((count-i) < 0.25) {//空星
                if (i==0) {
                    cell.star1.image = grayStar;
                }else if (i==1) {
                    cell.star2.image = grayStar;
                }else if (i==2) {
                    cell.star3.image = grayStar;
                }else if (i==3) {
                    cell.star4.image = grayStar;
                }else if (i==4) {
                    cell.star5.image = grayStar;
                }
            }else {//满星
                if (i==0) {
                    cell.star1.image = yellowStar;
                }else if (i==1) {
                    cell.star2.image = yellowStar;
                }else if (i==2) {
                    cell.star3.image = yellowStar;
                }else if (i==3) {
                    cell.star4.image = yellowStar;
                }else if (i==4) {
                    cell.star5.image = yellowStar;
                }
            }
        }
        
        if (count > 0) {
            [cell.star1 setHidden:NO];
            [cell.star2 setHidden:NO];
            [cell.star3 setHidden:NO];
            [cell.star4 setHidden:NO];
            [cell.star5 setHidden:NO];
        }else {
            cell.star1.image = grayStar;
            cell.star2.image = grayStar;
            cell.star3.image = grayStar;
            cell.star4.image = grayStar;
            cell.star5.image = grayStar;
        }

        
        double count2 = [commentArray[indexPath.row-1][@"staff_rate"] doubleValue];
        
        for (int i = 0; i < 5; i++) {
            
            if ((count2-i) >= 0.25 && (count2-i) < 0.75) {//半星
                if (i==0) {
                    cell.staffStar1.image = halfStar;
                }else if (i==1) {
                    cell.staffStar2.image = halfStar;
                }else if (i==2) {
                    cell.staffStar3.image = halfStar;
                }else if (i==3) {
                    cell.staffStar4.image = halfStar;
                }else if (i==4) {
                    cell.staffStar5.image = halfStar;
                }
            }else if ((count2-i) < 0.25) {//空星
                if (i==0) {
                    cell.staffStar1.image = grayStar;
                }else if (i==1) {
                    cell.staffStar2.image = grayStar;
                }else if (i==2) {
                    cell.staffStar3.image = grayStar;
                }else if (i==3) {
                    cell.staffStar4.image = grayStar;
                }else if (i==4) {
                    cell.staffStar5.image = grayStar;
                }
            }else {//满星
                if (i==0) {
                    cell.staffStar1.image = yellowStar;
                }else if (i==1) {
                    cell.staffStar2.image = yellowStar;
                }else if (i==2) {
                    cell.staffStar3.image = yellowStar;
                }else if (i==3) {
                    cell.staffStar4.image = yellowStar;
                }else if (i==4) {
                    cell.staffStar5.image = yellowStar;
                }
            }
        }
        
        if (count2 > 0) {
            [cell.staffStar1 setHidden:NO];
            [cell.staffStar2 setHidden:NO];
            [cell.staffStar3 setHidden:NO];
            [cell.staffStar4 setHidden:NO];
            [cell.staffStar5 setHidden:NO];
        }else {
            cell.staffStar1.image = grayStar;
            cell.staffStar2.image = grayStar;
            cell.staffStar3.image = grayStar;
            cell.staffStar4.image = grayStar;
            cell.staffStar5.image = grayStar;
        }
        
        if ([commentArray[indexPath.row-1][@"feedback_msg"] length] > 0) {
            cell.type2.text = [NSString stringWithFormat:@"商家回复：%@", commentArray[indexPath.row-1][@"feedback_msg"]];
            CGRect lbsize = [cell.type2.text boundingRectWithSize:CGSizeMake(260*SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12*SCALE]} context:nil];
            cell.type2.frame = CGRectMake(CGRectGetMaxX(cell.userIcon.frame)+10*SCALE, CGRectGetMaxY(cell.type.frame)+5*SCALE, lbsize.size.width+40*SCALE, lbsize.size.height+10*SCALE);
        }else {
            cell.type2.frame = CGRectMake(CGRectGetMaxX(cell.userIcon.frame)+10*SCALE, CGRectGetMaxY(cell.storeTitle.frame)+0*SCALE, 260*SCALE, 60*SCALE);
        }

        cell.shareBtnBlock = ^()
        {

            ShareCommentViewController *shareCommentViewController = [[ShareCommentViewController alloc] init];
            [shareCommentViewController.orderDictionary setObject:commentArray[indexPath.row-1][@"order_id"] forKey:@"order_id"];
            PUSH(shareCommentViewController);
           
        };
        
        cell.deleteBtnBlock = ^()
        {
            UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"确定删除这条评价吗？" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                
                [self deleteEvent:commentArray[indexPath.row-1][@"order_id"]];
            }];
            
            UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                
            }];
            
            [storeExistAlert addAction:OKButton];
            
            [storeExistAlert addAction:NOButton];
            
            [self presentViewController:storeExistAlert animated:YES completion:nil];
            
        };
        
        return cell;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)deleteEvent:(NSString *)orderId {
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:orderId, @"order_id", nil];
    
    [HttpClientService requestOrderratedelete:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            commentArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"info"]];
            
            [self hideLoadHUD:YES];
            
            [self requestData];
            
        }else if (status == 202) {
            [self showMsg:@"您的登录状态失效，请重新登录"];
            [self hideLoadHUD:YES];
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else {
            [self showMsg:@"服务器异常"];
            [self hideLoadHUD:YES];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        NSLog(@"请求删除评价失败");
    }];
}


- (void)loadNewData {
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    pageNumber = 0;
    
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%zd", pageNumber], @"page", nil];
    
    [HttpClientService requestMyrateinfo:paramDic success:^(id responseObject) {

        NSString *dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //json数据当中没有 \n \r \t 等制表符，当后台给出有问题时，我们需要对json数据过滤
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSData *utf8Data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableLeaves error:nil];
        
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            commentArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"info"]];
            
            if ([commentArray count] > 0) {
                
                [contentView setHidden:NO];
                
                [tipsImage setHidden:YES];
                [self.view sendSubviewToBack:tipsImage];
                
                [tipsLabel setHidden:YES];
                [self.view sendSubviewToBack:tipsLabel];
                
                
                
                [contentView.mj_header endRefreshing];
                [contentView.mj_footer endRefreshing];
                [contentView reloadData];

                pageNumber++;
                
            }else {
                [contentView setHidden:YES];
                
                [tipsImage setHidden:NO];
                [self.view bringSubviewToFront:tipsImage];
                
                [tipsLabel setHidden:NO];
                [self.view bringSubviewToFront:tipsLabel];
            }
            
            [self hideLoadHUD:YES];
        }
        
    } failure:^(NSError *error) {
        
        [contentView.mj_header endRefreshing];
        
        [self hideLoadHUD:YES];
        
        NSLog(@"请求炸鸡美食失败");
    }];
    
}


- (void)loadMoreData {
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%zd", pageNumber], @"page", nil];
    //查询取餐列表
    [HttpClientService requestMyrateinfo:paramDic success:^(id responseObject) {
        
        NSString *dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //json数据当中没有 \n \r \t 等制表符，当后台给出有问题时，我们需要对json数据过滤
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSData *utf8Data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"info"]];
            
            if (array.count == 0) {
                
                [self hideLoadHUD:YES];
                
                [self showMsg:@"没有更多评价了"];
                
                [contentView.mj_footer endRefreshingWithNoMoreData];
                
            }else if (array.count > 0 && array.count < 20) {
                
                for (int i = 0; i<array.count; i++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    
                    dic = [array objectAtIndex:i];
                    
                    [commentArray addObject:dic];
                }
                
                [contentView reloadData];
                
                [self hideLoadHUD:YES];
                
                [contentView.mj_footer endRefreshingWithNoMoreData];
                
                
            }else {
                
                for (int i = 0; i<array.count; i++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    
                    dic = [array objectAtIndex:i];
                    
                    [commentArray addObject:dic];
                }
                pageNumber++;
                
                [contentView reloadData];
                
                [self hideLoadHUD:YES];
                
                [contentView.mj_footer endRefreshing];
                
            }
            
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
//        [self showMsg:@"加载失败"];
        
        [contentView.mj_footer endRefreshing];
        
    }];
    
}


#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

@end
