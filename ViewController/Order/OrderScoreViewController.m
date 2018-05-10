//
//  OrderScoreViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/6.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderScoreViewController.h"
#import "OrderScoreHeaderCell.h"
#import "OrderScoreCell.h"

#import "LoginViewController.h"

@interface OrderScoreViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
    UITableView *contentView;
    NSMutableDictionary *orderScoreDic;
    
    NSMutableArray *productArray;
    
    //接口入参数组
    NSMutableArray *orderratesubmit;
    
    NSString *staff_rate;//骑士评分
    NSString *cvs_rate;//订单评分
    NSString *rate_msg;//订单评价内容
}

@end

@implementation OrderScoreViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor whiteColor];
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        navigationBar.titleLabel.text = @"评价";
        [navigationBar.editButton setTitle:@"提交" forState:UIControlStateNormal];
        [navigationBar.editButton setHidden:NO];
        
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+1, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-1) style:UITableViewStylePlain];
        
        contentView.delegate = self;
        
        contentView.dataSource = self;
        
        contentView.separatorStyle = NO;
        
        contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        //去除底部多余分割线
        contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        
        [self.view addSubview:contentView];
        
        _orderDictionary = [[NSMutableDictionary alloc] init];
        
        staff_rate = @"0";
        cvs_rate = @"0";
        rate_msg = @"";
        
        
        
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
    
    [contentView setHidden:YES];
    
    [self loadNewData];
}

- (void)loadNewData {
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    //提交接口入参数组
    orderratesubmit = [[NSMutableArray alloc] init];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"order_id"], @"order_id", nil];
    
    [HttpClientService requestOrderrate:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            orderScoreDic = [[NSMutableDictionary alloc] initWithDictionary:jsonDic];
            
            productArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"orderrate"]];
            
            [contentView reloadData];
            
            [contentView setHidden:NO];
            
            //构造参数
            for (int i = 0; i < productArray.count; i++) {
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                [tempDic setObject:productArray[i][@"product_no"] forKey:@"product_no"];
                [tempDic setObject:@"1" forKey:@"product_rate"];
                [orderratesubmit addObject:tempDic];
            }
            
            
            [self hideLoadHUD:YES];
        }else if (status == 202) {
            [self showMsg:@"您的登录状态失效，请重新登录"];
            [self hideLoadHUD:YES];
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else {
//            [self showMsg:@"服务器异常"];
            [self hideLoadHUD:YES];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
    }];
}

- (void)loadMoreData {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return [productArray count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //60 50 4 60 50 140
        return (380+4)*SCALE;
    }else {
        return 40*SCALE;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    static NSString *myCellIdentifier2 = @"MyCellIdentifier2";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        OrderScoreHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
        
        if (cell == nil) {
            cell = [[OrderScoreHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        //骑手名称
        cell.staffLabel.text = orderScoreDic[@"staff_name"];
        
        [cell.staffIcon sd_setImageWithURL:orderScoreDic[@"staff_portrait"]
                              placeholderImage:[UIImage imageNamed:@"order_logo"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         //TODO
                                     }];
        
        //店铺名称
        cell.storeLabel.text = orderScoreDic[@"cvs_name"];

        
//        __weak __typeof(&*cell)weakCell = cell;
        weakify(cell);
        cell.staffBtn1Block = ^() {
            strongify(cell);
            [cell.staffBtn1 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.staffBtn2 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            [cell.staffBtn3 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            [cell.staffBtn4 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            [cell.staffBtn5 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            
            staff_rate = @"1";
        };
        cell.staffBtn2Block = ^() {
            strongify(cell);
            [cell.staffBtn1 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.staffBtn2 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.staffBtn3 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            [cell.staffBtn4 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            [cell.staffBtn5 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            
            staff_rate = @"2";
        };
        cell.staffBtn3Block = ^() {
            strongify(cell);
            [cell.staffBtn1 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.staffBtn2 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.staffBtn3 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.staffBtn4 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            [cell.staffBtn5 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            
            staff_rate = @"3";
        };
        cell.staffBtn4Block = ^() {
            strongify(cell);
            [cell.staffBtn1 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.staffBtn2 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.staffBtn3 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.staffBtn4 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.staffBtn5 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            
            staff_rate = @"4";
        };
        cell.staffBtn5Block = ^() {
            strongify(cell);
            [cell.staffBtn1 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.staffBtn2 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.staffBtn3 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.staffBtn4 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.staffBtn5 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            
            staff_rate = @"5";
        };
        
        
        
        cell.storeBtn1Block = ^() {
            strongify(cell);
            [cell.storeBtn1 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.storeBtn2 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            [cell.storeBtn3 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            [cell.storeBtn4 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            [cell.storeBtn5 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            
            cvs_rate = @"1";
        };
        cell.storeBtn2Block = ^() {
            strongify(cell);
            [cell.storeBtn1 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.storeBtn2 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.storeBtn3 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            [cell.storeBtn4 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            [cell.storeBtn5 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            
            cvs_rate = @"2";
        };
        cell.storeBtn3Block = ^() {
            strongify(cell);
            [cell.storeBtn1 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.storeBtn2 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.storeBtn3 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.storeBtn4 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            [cell.storeBtn5 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            
            cvs_rate = @"3";
        };
        cell.storeBtn4Block = ^() {
            strongify(cell);
            [cell.storeBtn1 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.storeBtn2 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.storeBtn3 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.storeBtn4 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.storeBtn5 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
            
            cvs_rate = @"4";
        };
        cell.storeBtn5Block = ^() {
            strongify(cell);
            [cell.storeBtn1 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.storeBtn2 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.storeBtn3 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.storeBtn4 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            [cell.storeBtn5 setImage:[UIImage imageNamed:@"score_star_yellow"] forState:UIControlStateNormal];
            
            cvs_rate = @"5";
        };
        
        cell.storeTextView.delegate = self;
        
        
        
        
        return cell;
    }else if (indexPath.section == 1) {
        OrderScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier2];
        
        if (cell == nil) {
            cell = [[OrderScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.product.text = productArray[indexPath.row][@"description"];
        
//        __weak __typeof(&*cell)weakCell = cell;
        weakify(cell);
        cell.upBtnBlock = ^() {
            strongify(cell);
            [cell.upBtn setImage:[UIImage imageNamed:@"score_up_selected"] forState:UIControlStateNormal];
            [cell.downBtn setImage:[UIImage imageNamed:@"score_down"] forState:UIControlStateNormal];
            
            
            for (int i = 0; i < orderratesubmit.count; i++) {
                
                NSMutableDictionary *dic = [orderratesubmit[i] mutableCopy];
                if ([dic[@"product_no"] isEqualToString:orderratesubmit[indexPath.row][@"product_no"]]){
                    [dic setObject:@"1" forKey:@"product_rate"];
                    [orderratesubmit replaceObjectAtIndex:indexPath.row withObject:dic];
                }
            }
        };
        
        cell.downBtnBlock = ^() {
            strongify(cell);
            [cell.upBtn setImage:[UIImage imageNamed:@"score_up"] forState:UIControlStateNormal];
            [cell.downBtn setImage:[UIImage imageNamed:@"score_down_selected"] forState:UIControlStateNormal];
            
            for (int i = 0; i < orderratesubmit.count; i++) {
                
                NSMutableDictionary *dic = [orderratesubmit[i] mutableCopy];
                if ([dic[@"product_no"] isEqualToString:orderratesubmit[indexPath.row][@"product_no"]]){
                    [dic setObject:@"0" forKey:@"product_rate"];
                    [orderratesubmit replaceObjectAtIndex:indexPath.row withObject:dic];
                }
            }
        };
        
        
        
        return cell;
    }
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


#pragma mark - TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

- (void)editBtnClick:(id)sender {
  
    [self requestOrderratesubmit];
}

#pragma mark - UITextViewDelegate Methods
//编辑结束
-(void)textViewDidEndEditing:(UITextView *)textView {
    
    
    if (textView.text.length > 0 && textView.text.length <= 80) {
        rate_msg = textView.text;
    }else {
        [self showMsg:@"备注最多可填写80个字"];
        return;
    }
}

//关键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//评价动作请求
- (void)requestOrderratesubmit {
    
    if ([staff_rate isEqualToString:@"0"]) {
        [self showMsg:@"您还未对骑手评分"];
        
        return;
    }
    
    if ([cvs_rate isEqualToString:@"0"]) {
        [self showMsg:@"您还未对订单评分"];
        
        return;
    }
    
    
    
    
    
    [self showLoadHUDMsg:@"处理中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:orderScoreDic[@"order_id"], @"order_id", orderScoreDic[@"staff_id"], @"staff_id", staff_rate, @"staff_rate", cvs_rate, @"cvs_rate", orderScoreDic[@"cvs_no"], @"cvs_no", rate_msg, @"rate_msg", orderratesubmit, @"orderratesubmit", nil];
    
    [HttpClientService requestOrderratesubmit:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            
            [self hideLoadHUD:YES];
            
            [self showCustomDialog:@"评价成功"];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
    }];
}

@end
