//
//  OrderReturnViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/3.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderReturnViewController.h"
#import "OrderReturnHeaderCell.h"
#import "OrderReturnCell.h"
#import "OrderReturnFooterCell.h"
#import "UILabel+AlertActionFont.h"
#import "LoginViewController.h"
#import "OrderViewController.h"
#import "OrderReturnDetailViewController.h"


@interface OrderReturnViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, strong) NSMutableDictionary *orderDic;
@property (nonatomic, strong) NSMutableArray *returnArray;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic) float price;
@property (nonatomic) float orderPrice;

@end

@implementation OrderReturnViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [navigationBar.leftButton setHidden:NO];
        navigationBar.titleLabel.text = @"申请退货";
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.separatorStyle = NO;
        _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:_contentView];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        //提交
        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitBtn setFrame:CGRectMake(0*SCALE, SCREEN_HEIGHT -BOTTOM_BAR_HEIGHT, SCREEN_WIDTH, BOTTOM_BAR_HEIGHT)];
        [commitBtn setBackgroundColor:ICON_COLOR];
        [commitBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
        [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [commitBtn addTarget:self action:@selector(commitBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:commitBtn];
        
        _orderDictionary = [[NSMutableDictionary alloc] init];
        
        //退货参数
        _returnArray = [NSMutableArray array];
        
        _price = 0;
        _reason = @"";
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self newData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)newData {
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"order_id"], @"order_id", nil];
    
    weakify(self);
    //支付方式 1现金 2微信 3支付宝 4兔币
    [HttpClientService requestReturnsummary:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            self.orderDic = [[NSMutableDictionary alloc] initWithDictionary:jsonDic];
            self.orderPrice = [self.orderDic[@"money"] floatValue];
            
            //[orderDic[@"summary"] mutableCopy];全退
            
            self.returnArray = [self.orderDic[@"summary"] mutableCopy];
            
            [self.contentView reloadData];
            
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
        
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return [_orderDic[@"summary"] count];
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return (40*5+6+70)*SCALE;
    }else if (indexPath.section == 1) {
        return 60*SCALE;
    }else {
        return (100+6+80)*SCALE;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *orderCellIdentifier1 = @"OrderCellIdentifier1";
    static NSString *orderCellIdentifier2 = @"OrderCellIdentifier2";
    static NSString *orderCellIdentifier3 = @"OrderCellIdentifier3";
    
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        OrderReturnHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier1];
        if (!cell) {
            cell = [[OrderReturnHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier1];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        //@"共3个商品，消费小计39.9元";
        cell.title.text = _orderDic[@"cvs_name"];
        cell.subTitle.text = [NSString stringWithFormat:@"共%@个商品，消费小计%.2f元", _orderDic[@"count"], _orderPrice];
        
        if ([_orderDic[@"pay_type"] isEqualToString:@"1"]) {
            cell.pay.text = @"现金退款";
        }else if ([_orderDic[@"pay_type"] isEqualToString:@"2"]) {
            cell.pay.text = @"退至您的支付账户";
        }else if ([_orderDic[@"pay_type"] isEqualToString:@"3"]) {
            cell.pay.text = @"退至您的支付账户";
        }else if ([_orderDic[@"pay_type"] isEqualToString:@"4"]) {
            cell.pay.text = @"退至您的兔币账户";
        }else {
            cell.pay.text = @"退至您的支付账户";
        }
        
//        __weak __typeof(&*cell)weakCell = cell;
        weakify(cell);
        weakify(self);
        cell.allBtnBlock = ^() {
            strongify(cell);
            strongify(self);
            cell.allIcon.image = [UIImage imageNamed:@"order_selected"];
            cell.otherIcon.image = [UIImage imageNamed:@"order_unselected"];
    
            //全选处理
            for (int i = 0; i < self.returnArray.count; i++) {
                NSMutableDictionary *dic = [self.returnArray[i] mutableCopy];
                    [dic setObject:dic[@"count"] forKey:@"return_count"];
                    [self.returnArray replaceObjectAtIndex:i withObject:dic];

            }
            //UI处理
            [self.contentView reloadData];
            
            [self requstTotalMoney];
        };
        
        cell.otherBtnBlock = ^() {
            strongify(cell);
            strongify(self);
            cell.allIcon.image = [UIImage imageNamed:@"order_unselected"];
            cell.otherIcon.image = [UIImage imageNamed:@"order_selected"];
            
            //部分选择处理
            self.returnArray = [self.orderDic[@"summary"] mutableCopy];
            
            //UI处理
            [self.contentView reloadData];
            
            [self requstTotalMoney];
        };
        
        
        
        
        return cell;
    }else if (indexPath.section == 1) {
        OrderReturnCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier2];
        if (!cell) {
            cell = [[OrderReturnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier2];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.title.text = _returnArray[indexPath.row][@"description"];
        cell.subTitle.text = [NSString stringWithFormat:@"x%@件",_returnArray[indexPath.row][@"count"]];
        
        cell.amount = [_returnArray[indexPath.row][@"return_count"] integerValue];
        
        
        if (cell.amount == [_returnArray[indexPath.row][@"count"] integerValue]) {
            [cell.plus setEnabled:NO];
        }else {
            [cell.plus setEnabled:YES];
        }
        
        
        
//        __weak __typeof(&*cell)weakCell = cell;
        weakify(cell);
        weakify(self);
        cell.plusBlock = ^(NSInteger nCount,BOOL animated)
        {
            strongify(cell);
            strongify(self);
            if (cell.amount == [self.returnArray[indexPath.row][@"count"] integerValue]) {
                [cell.plus setEnabled:NO];
            }else {
                [cell.plus setEnabled:YES];
            }
            NSMutableDictionary *dic = [self.returnArray[indexPath.row] mutableCopy];
            //
            [self storeOrders:dic isAdded:animated];
            
            [self requstTotalMoney];
            
        };
        
        return cell;
    }else if (indexPath.section == 2) {
        OrderReturnFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier3];
        if (!cell) {
            cell = [[OrderReturnFooterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier3];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        float nTotal = _price;//价格
        NSString *priceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:nTotal]];
        cell.price.text = priceStr;
        
        
//        __weak __typeof(&*cell)weakCell = cell;
        weakify(cell);
        weakify(self);
        cell.reasonBtnBlock = ^() {
            strongify(cell);
            strongify(self);
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
                
            }];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"买错了，买多了，买少了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                cell.reason.text = @"买错了，买多了，买少了";
                self.reason = @"买错了，买多了，买少了";
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"送达时间选错了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                cell.reason.text = @"送达时间选错了";
                self.reason = @"送达时间选错了";
            }];
            UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"地址，电话填写错误" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                cell.reason.text = @"地址，电话填写错误";
                self.reason = @"地址，电话填写错误";
            }];
            UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"计划有变，不想要了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                cell.reason.text = @"计划有变，不想要了";
                self.reason = @"计划有变，不想要了";
            }];
            UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"商家通知我卖完了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                cell.reason.text = @"商家通知我卖完了";
                self.reason = @"商家通知我卖完了";
            }];
            UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"商家沟通态度差" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                cell.reason.text = @"商家沟通态度差";
                self.reason = @"商家沟通态度差";
            }];
            
            [cancle setValue:[UIColor darkGrayColor] forKey:@"titleTextColor"];
            [action1 setValue:[UIColor darkGrayColor] forKey:@"titleTextColor"];
            [action2 setValue:[UIColor darkGrayColor] forKey:@"titleTextColor"];
            [action3 setValue:[UIColor darkGrayColor] forKey:@"titleTextColor"];
            [action4 setValue:[UIColor darkGrayColor] forKey:@"titleTextColor"];
            [action5 setValue:[UIColor darkGrayColor] forKey:@"titleTextColor"];
            [action6 setValue:[UIColor darkGrayColor] forKey:@"titleTextColor"];
            
            UILabel *appearanceLabel = [UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]];
            UIFont *font = [UIFont systemFontOfSize:15*SCALE];
            [appearanceLabel setAppearanceFont:font];
            
            [alertVc addAction:cancle];
            [alertVc addAction:action1];
            [alertVc addAction:action2];
            [alertVc addAction:action3];
            [alertVc addAction:action4];
            [alertVc addAction:action5];
            [alertVc addAction:action6];
            [self presentViewController:alertVc animated:YES completion:nil];
        };
        
        return cell;
    }
    
    return cell;
}

- (void)storeOrders:(NSMutableDictionary *)dictionary isAdded:(BOOL)added {
    
    
    
    if (added) {
        for (int i = 0; i < _returnArray.count; i++) {
            
            NSMutableDictionary *dic = [_returnArray[i] mutableCopy];
            if ([dic[@"product_no"] isEqualToString:dictionary[@"product_no"]]){
                NSInteger nCount = [dic[@"return_count"] integerValue];
                nCount = nCount+1;
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"return_count"];
                [_returnArray replaceObjectAtIndex:i withObject:dic];
            }
        }
        
    }else {
        
        for (int i = 0; i < _returnArray.count; i++) {
            NSMutableDictionary *dic = [_returnArray[i] mutableCopy];
            if ([dic[@"product_no"] isEqualToString:dictionary[@"product_no"]]) {
                
                NSInteger nCount = [dic[@"return_count"] integerValue];
                
                nCount = nCount-1;
                
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"return_count"];
                [_returnArray replaceObjectAtIndex:i withObject:dic];
                
            }
        }
    }
}

- (void)commitBtnEvent {
    
    [self requstSubmit];
}

#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

//计算金额接口
- (void)requstTotalMoney {
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"order_id"], @"order_id", _returnArray, @"info", nil];
    weakify(self);
    [HttpClientService requestReturnsettle:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            self.price = [jsonDic[@"money"] floatValue];
            [self.contentView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
    }];
}

- (BOOL)check {
    
    if (_returnArray.count > 0) {
        for (int i = 0; i < _returnArray.count; i++) {
            NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:_returnArray[i]];
            if ([dic[@"return_count"] intValue] > 0) {
                return YES;
            }
        }
    }
    return NO;
}

//提交接口
- (void)requstSubmit {
    
    if ([self check] == YES) {
        [self showLoadHUDMsg:@"努力加载中..."];
        
        NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"order_id"], @"order_id",_returnArray, @"info", _reason, @"reason", nil];
        
        weakify(self);
        [HttpClientService requestReturnsubmit:paramDic success:^(id responseObject) {
            
            strongify(self);
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            int status = [[jsonDic objectForKey:@"status"] intValue];
            
            if (status == 0) {
                
                [self hideLoadHUD:YES];
                
                UIAlertController *hurryAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"申请已提交。" preferredStyle:(UIAlertControllerStyleAlert)];
                
                UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    
                    NSMutableArray *viewControllers =[[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
                    for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
                        if (![[[self.navigationController.viewControllers mutableCopy] objectAtIndex:i] isKindOfClass:[OrderViewController class]]) {
                            [viewControllers removeObject:[[self.navigationController.viewControllers mutableCopy] objectAtIndex:i]];
                        }
                    }
                    
                    OrderReturnDetailViewController *orderReturnDetailViewController = [[OrderReturnDetailViewController alloc] init];
                    [orderReturnDetailViewController.orderDictionary setObject:self.orderDictionary[@"order_id"] forKey:@"order_id"];
                    
                    [viewControllers addObject:orderReturnDetailViewController];
                    [self.navigationController setViewControllers:viewControllers animated:YES];
                }];
                
                [hurryAlert addAction:OKButton];
                
                [self presentViewController:hurryAlert animated:YES completion:nil];
                
            }else if (status == 126) {
                [self hideLoadHUD:YES];
                [self showMsg:[NSString stringWithFormat:@"%@", [jsonDic objectForKey:@"msg"]]];
                
            }else {
                [self hideLoadHUD:YES];
                
                UIAlertController *hurryAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"申请提交失败，请尝试联系客服。" preferredStyle:(UIAlertControllerStyleAlert)];
                
                UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    
                }];
                
                [hurryAlert addAction:OKButton];
                
                [self presentViewController:hurryAlert animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            
            [self hideLoadHUD:YES];
            
        }];
    }else {
        [self showMsg:@"请选择退货商品"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
