//
//  GiftProductViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/20.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "GiftProductViewController.h"
#import "ProductDetailViewController.h"
#import "SubmitOrderViewController.h"
#import "GiftProductCell.h"
#import "CartInfoDAL.h"
#import "CartInfoEntity.h"

@interface GiftProductViewController ()<UITableViewDataSource, UITableViewDelegate> {
    UILabel *halfTitleLabel;
    
    UIScrollView *contentView;
    
    UITableView *productView;
    
    NSInteger pageNumber;
    
    NSInteger pageLen;
    
    NSMutableArray *ordersArray;
    //商家促销
    BOOL isOpen;
}

@end

@implementation GiftProductViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [navigationBar.leftButton setFrame:CGRectMake(0.0f, STATUS_BAR_HEIGHT, 88.0f*SCALE, NAV_BAR_HEIGHT)];
        [navigationBar.leftButton setTitle:@"取消换购" forState:UIControlStateNormal];
        [navigationBar.editButton setTitle:@"确定" forState:UIControlStateNormal];
        [navigationBar.editButton setHidden:NO];
        
        //标题
        navigationBar.titleLabel.text = @"换购商品";
        
        productView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+1, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-1) style:UITableViewStylePlain];
        
        productView.delegate = self;
        
        productView.dataSource = self;
        
        productView.separatorStyle = NO;
        
        productView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        //去除底部多余分割线
        productView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:productView];
        
        if (@available(iOS 11.0, *)) {
            productView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //        [self.view bringSubviewToFront:navigationBar];
        
        
        //购物车数据初始化
        ordersArray = [NSMutableArray array];
        
        //入参数
        _paramArray = [[NSMutableArray alloc] init];
        
        isOpen = NO;
        
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

    //购物车数据初始化
    ordersArray = [NSMutableArray array];
    
    //取DB最新
    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
    NSMutableArray *entityArray = [dal queryCartInfoGift];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < entityArray.count; i++) {
        CartInfoEntity *entity = [[CartInfoEntity alloc] init];
        entity = entityArray[i];
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
        
        [tempDic setObject:entity.product_no forKey:@"product_no"];
        [tempDic setObject:entity.cvs_no forKey:@"cvs_no"];
        [tempDic setObject:entity.orderCount forKey:@"orderCount"];
        [tempDic setObject:entity.descriptionn forKey:@"description"];
        [tempDic setObject:entity.dis_price forKey:@"dis_price"];
        
        [tempArray addObject:tempDic];
        
    }
    ordersArray = tempArray;

    [productView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _paramArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    
    GiftProductCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
    
    if (!cell) {
        cell = [[GiftProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:_paramArray[indexPath.row][@"product_url"]]
                           placeholderImage:[UIImage imageNamed:@""]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      //TODO
                                      if ([_paramArray[indexPath.row][@"stock_qty"] intValue] > 0) {
                                          //hidden
                                          [cell.rightImageView2 setHidden:YES];
                                      }else {
                                          //show
                                          [cell.rightImageView2 setHidden:NO];
                                      }
                                  }];
    
    cell.rightTitle.text = _paramArray[indexPath.row][@"description"];//商品名
    cell.rightSubTitle.text = _paramArray[indexPath.row][@"capacity_description"];//规格
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    float nTotal = [_paramArray[indexPath.row][@"exchg_price"] floatValue];//价格
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:nTotal]];
    cell.price.text = price;
    
    cell.oldPrice = [_paramArray[indexPath.row][@"sa_price"] floatValue];
    
    cell.tipsTitle.text = [NSString stringWithFormat:@"享受换购价格的商品数量:%@个 超出部分原价销售", _paramArray[indexPath.row][@"count"]];
    
    if ([_paramArray[indexPath.row][@"stock_qty"] intValue] > 0) {
        //hidden
        [cell.plus setEnabled:YES];
    }else {
        //show
        [cell.plus setEnabled:NO];
    }
    
//    __weak __typeof(&*cell)weakCell =cell;
    cell.plusBlock = ^(NSInteger nCount,BOOL animated)
    {
        NSMutableDictionary *dic = [_paramArray[indexPath.row] mutableCopy];
        
        [dic setObject:@"1" forKey:@"type"];//是否是换购
        [self storeOrders:dic isAdded:animated];
        
    };
    
    //刷新父列表(需要强化测试)
    if (ordersArray.count > 0) {
//        NSMutableDictionary *dic = _paramArray[indexPath.row];
        cell.amount = 0;
        for (NSMutableDictionary *dic in ordersArray) {
            
            if ([dic[@"product_no"] isEqualToString:_paramArray[indexPath.row][@"product_no"]]){
                
                NSInteger nCount = [dic[@"orderCount"] integerValue];
                cell.amount = nCount;
            }
        }
        
        return cell;
    }else {
        cell.amount = 0;
        return cell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100*SCALE;
}

#pragma mark - store orders 存放订单
- (void)storeOrders:(NSMutableDictionary *)dictionary isAdded:(BOOL)added {
    
    if (added) {
        //存入商品 dictionary
        for (NSMutableDictionary *dic in ordersArray) {
            
            if ([dic[@"product_no"] isEqualToString:dictionary[@"product_no"]]){
                //购物车内有选择的商品
                NSInteger nCount = [dic[@"orderCount"] integerValue];
                nCount = nCount+1;
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"orderCount"];
                
                //更新DB
                [self updateDB2:dic];
                
                return;
            }
        }
        
        //购物车内没有商品
        [dictionary setObject:@"1" forKey:@"orderCount"];
        [ordersArray addObject:dictionary];
        
        //更新DB
        [self updateDB:dictionary];
        
        return;
        
    }else {
        //减法的时候
        for (NSMutableDictionary *dic in ordersArray) {
            
            if ([dic[@"product_no"] isEqualToString:dictionary[@"product_no"]]){
                
                NSInteger nCount = [dic[@"orderCount"] integerValue];
                
                nCount = nCount-1;
                
                if (nCount==0) {
                    [dic setObject:@"0" forKey:@"orderCount"];
                    //更新DB
                    [self updateDB2:dic];
                    
                    [ordersArray removeObject:dic];
                    
                    return;
                }else{
                    //更新
                    [dic setObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"orderCount"];
                    
                    [self updateDB2:dic];
                    
                    return;
                }
            }
        }
    }
}

//更新DB
- (void)updateDB:(NSMutableDictionary *)dic {
    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
    CartInfoEntity *entity = [[CartInfoEntity alloc] init];
    entity.product_no = [dic objectForKey:@"product_no"];
    entity.cvs_no = [[UserDefaults service] getStoreId];
    entity.orderCount = [dic objectForKey:@"orderCount"];
    entity.descriptionn = [dic objectForKey:@"description"];
    entity.dis_price = [dic objectForKey:@"exchg_price"];
    entity.gift_flag = @"1";
    [dal insertIntoTable:entity];
}

//因为换购 换购价字段变了exchg_price
- (void)updateDB2:(NSMutableDictionary *)dic {
    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
    CartInfoEntity *entity = [[CartInfoEntity alloc] init];
    entity.product_no = [dic objectForKey:@"product_no"];
    entity.cvs_no = [[UserDefaults service] getStoreId];
    entity.orderCount = [dic objectForKey:@"orderCount"];
    entity.descriptionn = [dic objectForKey:@"description"];
    entity.dis_price = [dic objectForKey:@"dis_price"];
    entity.gift_flag = @"1";
    [dal insertIntoTable:entity];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    
    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
    NSMutableArray *entityArray = [dal queryCartInfoGift];
    
    for (int i = 0; i < entityArray.count; i++) {
        
        CartInfoEntity *entity = [[CartInfoEntity alloc] init];
        entity = entityArray[i];
        entity.orderCount = @"0";
        [dal insertIntoTable:entity];
    }
    
    [self showCustomDialog:@"取消换购"];
}

- (void)editBtnClick:(id)sender {
    POP;
}


@end
