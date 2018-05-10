//
//  MineViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"
#import "MineDetailViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "MineAddressViewController.h"
#import "MineFavoriteViewController.h"
#import "BonusViewController.h"
#import "MineFriendViewController.h"
#import "ServiceGuideViewController.h"
#import "ServiceCenterViewController.h"
#import "MineCommentViewController.h"
#import "MinePointViewController.h"

@interface MineViewController ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    UICollectionView *mineCollectionView;
    
    UIImageView *headImageView;
    UILabel *longinTipsLabel;//提示语
    UILabel *nameLabel;//昵称
    UILabel *member;//会员等级
    UILabel *level;//星级兔
    UILabel *money;//兔币余额
    UILabel *memberLabel;//会员等级标题
    UILabel *levelLabel;//星级兔标题
    UILabel *moneyLabel;//兔币余额标题
}

@end

@implementation MineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 265*SCALE);//头部大小
        flowLayout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, 0);//尾部大小
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-3)/3, 115*SCALE);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumInteritemSpacing = 0;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumLineSpacing = 1.5;
        //定义每个UICollectionView 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//上左下右
        
        mineCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        
        //注册cell和ReusableView（相当于头部）
        [mineCollectionView registerClass:[MineCell class] forCellWithReuseIdentifier:@"cell"];
        [mineCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        
        [mineCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        
        //设置代理
        mineCollectionView.delegate = self;
        mineCollectionView.dataSource = self;
        
        if (@available(iOS 11.0, *)) {
            mineCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        //背景颜色
        mineCollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [self.view addSubview:mineCollectionView];
    }
    
    return self;
}

#pragma mark 定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

#pragma mark 定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark 每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cell";
    
    MineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mine_wallet"];
        cell.label.text = @"邀请有奖";
    }else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"mine_point"];
        cell.label.text = @"兔币与积分";
    }else if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"mine_invite"];
        cell.label.text = @"我的好友";
    }else if (indexPath.row == 3) {
        cell.imageView.image = [UIImage imageNamed:@"mine_favorite"];
        cell.label.text = @"我的收藏";
    }else if (indexPath.row == 4) {
        cell.imageView.image = [UIImage imageNamed:@"mine_address"];
        cell.label.text = @"收货地址";
    }else if (indexPath.row == 5) {
        cell.imageView.image = [UIImage imageNamed:@"mine_tips"];
        cell.label.text = @"评价信息";
    }else if (indexPath.row == 6) {
        cell.imageView.image = [UIImage imageNamed:@"mine_service"];
        cell.label.text = @"客服中心";
    }else if (indexPath.row == 7) {
        cell.imageView.image = [UIImage imageNamed:@"mine_guide"];
        cell.label.text = @"会员指南";
    }
    
    return cell;
}

#pragma mark 头部显示的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    
    NSString *CellIdentifier = @"HeaderView";
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    header.backgroundColor = [UIColor whiteColor];
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        //底色
        header.backgroundColor = [UIColor whiteColor];
        //背景
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 260*SCALE)];
        imageView.image = [UIImage imageNamed:@"mine_bg"];
//        imageView.backgroundColor = MAIN_COLOR;
        [header addSubview:imageView];
        
        //间隔区
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 260*SCALE, SCREEN_WIDTH, 5*SCALE)];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [header addSubview:lineView];
        
        //头像
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-80*SCALE)/2, 50*SCALE, 80*SCALE, 80*SCALE)];
        
        if ([[[UserDefaults service] getGender] isEqualToString:@"1"]) {
            headImageView.image = [UIImage imageNamed:@"test_head"];
        }else {
            headImageView.image = [UIImage imageNamed:@"test_head2"];
        }
        
        
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.borderWidth = 1.5;
        headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        headImageView.layer.cornerRadius=headImageView.frame.size.width / 2;
        
        [header addSubview:headImageView];
        
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [loginBtn setFrame:CGRectMake(30*SCALE, 70*SCALE, 200*SCALE, 80*SCALE)];
        loginBtn.backgroundColor = [UIColor clearColor];
        [loginBtn addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:loginBtn];
        
        //设置
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [settingBtn setFrame:CGRectMake(SCREEN_WIDTH-54*SCALE, STATUS_BAR_HEIGHT, 44*SCALE, 44*SCALE)];
        [settingBtn setBackgroundImage:[UIImage imageNamed:@"mine_setting"] forState:UIControlStateNormal];
        [settingBtn addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:settingBtn];
        
        //提示语
        longinTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0*SCALE, CGRectGetMaxY(headImageView.frame)+10*SCALE, SCREEN_WIDTH, 20*SCALE)];
        longinTipsLabel.text = @"登录后享受更多优惠";
        longinTipsLabel.textColor = [UIColor whiteColor];
        longinTipsLabel.font = [UIFont systemFontOfSize:15*SCALE];
        longinTipsLabel.textAlignment = NSTextAlignmentCenter;
        [header addSubview:longinTipsLabel];
        
        //昵称
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0*SCALE, CGRectGetMaxY(headImageView.frame)+10*SCALE, SCREEN_WIDTH, 20*SCALE)];
        nameLabel.text = @"binge";
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:15*SCALE];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [header addSubview:nameLabel];
        
        //会员等级
        member = [[UILabel alloc] initWithFrame:CGRectMake(0, 200*SCALE, SCREEN_WIDTH/3, 30*SCALE)];
        member.textColor = MAIN_COLOR;
        member.text = @"注册会员";
        member.font = [UIFont systemFontOfSize:16*SCALE];
        member.textAlignment = NSTextAlignmentCenter;
        [header addSubview:member];
        
        //星级兔
        level = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 200*SCALE, SCREEN_WIDTH/3, 30*SCALE)];
        level.textColor = MAIN_COLOR;
        level.text = @"1星兔";
        level.font = [UIFont systemFontOfSize:16*SCALE];
        level.textAlignment = NSTextAlignmentCenter;
        [header addSubview:level];
    
        //兔币余额
        money = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 200*SCALE, SCREEN_WIDTH/3, 30*SCALE)];
        money.textColor = MAIN_COLOR;
        money.text = @"10000";
        money.font = [UIFont systemFontOfSize:16*SCALE];
        money.textAlignment = NSTextAlignmentCenter;
        [header addSubview:money];
    
        //会员等级标题
        memberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(member.frame), SCREEN_WIDTH/3, 20*SCALE)];
        memberLabel.textColor = [UIColor darkGrayColor];
        memberLabel.font = [UIFont systemFontOfSize:13*SCALE];
        memberLabel.text = @"会员等级";
        memberLabel.textAlignment = NSTextAlignmentCenter;
        [header addSubview:memberLabel];
        
        //星级兔标题
        levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, CGRectGetMaxY(level.frame), SCREEN_WIDTH/3, 20*SCALE)];
        levelLabel.textColor = [UIColor darkGrayColor];
        levelLabel.font = [UIFont systemFontOfSize:13*SCALE];
        levelLabel.text = @"星级兔";
        levelLabel.textAlignment = NSTextAlignmentCenter;
        [header addSubview:levelLabel];
        
        //兔币余额标题
        moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, CGRectGetMaxY(money.frame), SCREEN_WIDTH/3, 20*SCALE)];
        moneyLabel.textColor = [UIColor darkGrayColor];
        moneyLabel.font = [UIFont systemFontOfSize:13*SCALE];
        moneyLabel.text = @"兔币余额";
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        [header addSubview:moneyLabel];
        
        if ([[UserDefaults service] getLoginStatus] == YES) {
            [longinTipsLabel setHidden:YES];
            
            [nameLabel setHidden:NO];//昵称
            nameLabel.text = [[UserDefaults service] getNickName];
            
            [member setHidden:NO];//会员等级
            if ([[[UserDefaults service] getGrade] isEqualToString:@"0"]) {
                member.text = @"注册会员";
            }else if ([[[UserDefaults service] getGrade] isEqualToString:@"1"]) {
                member.text = @"铜牌会员";
            }else if ([[[UserDefaults service] getGrade] isEqualToString:@"2"]) {
                member.text = @"银牌会员";
            }else if ([[[UserDefaults service] getGrade] isEqualToString:@"3"]) {
                member.text = @"金牌会员";
            }else if ([[[UserDefaults service] getGrade] isEqualToString:@"4"]) {
                member.text = @"钻石会员";
            }
            
            [level setHidden:NO];//星级兔
            level.text = [NSString stringWithFormat:@"%@星兔", [[UserDefaults service] getValueStar]];
            
            [money setHidden:NO];//兔币余额
            money.text = [[UserDefaults service] getIntegral];
            
            [memberLabel setHidden:NO];//会员等级标题
            [levelLabel setHidden:NO];//星级兔标题
            [moneyLabel setHidden:NO];//兔币余额标题
        }else {
            [longinTipsLabel setHidden:NO];
            
            [nameLabel setHidden:YES];//昵称
//            [accountLabel setHidden:YES];//兔悠号
            [member setHidden:YES];//会员等级
            [level setHidden:YES];//星级兔
            [money setHidden:YES];//兔币余额
            [memberLabel setHidden:YES];//会员等级标题
            [levelLabel setHidden:YES];//星级兔标题
            [moneyLabel setHidden:YES];//兔币余额标题
        }
        
        reusableView = header;
        return reusableView;
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        reusableView = footerview;
    }
    return reusableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=NO;
    
    if ([[UserDefaults service] getLoginStatus] == YES) {
        
        NSDictionary *paramDic = [[NSDictionary alloc] init];
        
        [HttpClientService requestMine:paramDic success:^(id responseObject) {
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            int status = [[jsonDic objectForKey:@"status"] intValue];
            
            if (status == 0) {
                //兔币
                [[UserDefaults service] updateIntegral:[jsonDic objectForKey:@"integral"]];
                //星级
                [[UserDefaults service] updateValueStar:[jsonDic objectForKey:@"value_star"]];
                //会员等级 0 注册会员1铜牌会员2银牌会员,3 金牌会员,4 钻石会员
                [[UserDefaults service] updateGrade:[jsonDic objectForKey:@"grade"]];
                //昵称
                [[UserDefaults service] updateNickName:[jsonDic objectForKey:@"nick_name"]];
                
                [[UserDefaults service] updateGender:[jsonDic objectForKey:@"is_male"]];
                
                [self reloadView];
                
                [self hideLoadHUD:YES];
            }if (status == 202) {
                
                [[UserDefaults service] updateSessionId:@""];
                
                [self hideLoadHUD:YES];
                
                [self showMsgWithPop:@"其他设备登录您的账号，请重新登录"];
            }
            
        } failure:^(NSError *error) {
            
            [self hideLoadHUD:YES];
            
        }];

    }else {
        [self reloadView];
    }
    
}

- (void)reloadView {
    
    if ([[UserDefaults service] getLoginStatus] == YES) {
        [longinTipsLabel setHidden:YES];
        
        
        if ([[[UserDefaults service] getGender] isEqualToString:@"1"]) {
            headImageView.image = [UIImage imageNamed:@"test_head"];
        }else {
            headImageView.image = [UIImage imageNamed:@"test_head2"];
        }
        
        [nameLabel setHidden:NO];//昵称
        nameLabel.text = [[UserDefaults service] getNickName];
        
        [member setHidden:NO];//会员等级
        if ([[[UserDefaults service] getGrade] isEqualToString:@"0"]) {
            member.text = @"注册会员";
        }else if ([[[UserDefaults service] getGrade] isEqualToString:@"1"]) {
            member.text = @"铜牌会员";
        }else if ([[[UserDefaults service] getGrade] isEqualToString:@"2"]) {
            member.text = @"银牌会员";
        }else if ([[[UserDefaults service] getGrade] isEqualToString:@"3"]) {
            member.text = @"金牌会员";
        }else if ([[[UserDefaults service] getGrade] isEqualToString:@"4"]) {
            member.text = @"钻石会员";
        }
        
        [level setHidden:NO];//星级兔
        level.text = [NSString stringWithFormat:@"%@星兔", [[UserDefaults service] getValueStar]];
        
        [money setHidden:NO];//兔币余额
        money.text = [[UserDefaults service] getIntegral];
        
        [memberLabel setHidden:NO];//会员等级标题
        [levelLabel setHidden:NO];//星级兔标题
        [moneyLabel setHidden:NO];//兔币余额标题
    }else {
        [longinTipsLabel setHidden:NO];
        
        [nameLabel setHidden:YES];//昵称
//        [accountLabel setHidden:YES];//兔悠号
        [member setHidden:YES];//会员等级
        [level setHidden:YES];//星级兔
        [money setHidden:YES];//兔币余额
        [memberLabel setHidden:YES];//会员等级标题
        [levelLabel setHidden:YES];//星级兔标题
        [moneyLabel setHidden:YES];//兔币余额标题
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"选择item%ld",indexPath.item);
    
    if (indexPath.item == 0) {
//        NSLog(@"邀请有奖");
        if ([[UserDefaults service] getLoginStatus] == YES) {
            BonusViewController *bonusViewController = [[BonusViewController alloc] init];
            PUSH(bonusViewController);
        }else {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
        }
        
    }else if (indexPath.item == 1) {
//        NSLog(@"兔币与积分");
        if ([[UserDefaults service] getLoginStatus] == YES) {
            MinePointViewController *minePointViewController = [[MinePointViewController alloc] init];
            PUSH(minePointViewController);
        }else {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
        }
        
        
        
    }else if (indexPath.item == 2) {
//        NSLog(@"我的好友");
        
        if ([[UserDefaults service] getLoginStatus] == YES) {
            MineFriendViewController *mineFriendViewController = [[MineFriendViewController alloc] init];
            PUSH(mineFriendViewController);
        }else {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
        }
        
    }else if (indexPath.item == 3) {
//        NSLog(@"我的收藏");
        
        if ([[UserDefaults service] getLoginStatus] == YES) {
            MineFavoriteViewController *mineFavoriteViewController = [[MineFavoriteViewController alloc] init];
            PUSH(mineFavoriteViewController);
        }else {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
        }
        
    }else if (indexPath.item == 4) {
//        NSLog(@"收货地址");
        
        if ([[UserDefaults service] getLoginStatus] == YES) {
            MineAddressViewController *mineAddressViewController = [[MineAddressViewController alloc] init];
            PUSH(mineAddressViewController);
        }else {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
        }
        
    }else if (indexPath.item == 5) {
//        NSLog(@"评价信息");
        if ([[UserDefaults service] getLoginStatus] == YES) {
            MineCommentViewController *mineCommentViewController = [[MineCommentViewController alloc] init];
            PUSH(mineCommentViewController);
        }else {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
        }
        
        
        
    }else if (indexPath.item == 6) {
//        NSLog(@"客服中心");
        ServiceCenterViewController *serviceCenterViewController = [[ServiceCenterViewController alloc] init];
        PUSH(serviceCenterViewController);
        //
    }
    
    else if (indexPath.item == 7) {
        
        ServiceGuideViewController *serviceGuideViewController = [[ServiceGuideViewController alloc] init];
        PUSH(serviceGuideViewController);
        
    }

}

- (void)settingClick {
//    NSLog(@"设置");
    if ([[UserDefaults service] getLoginStatus] == YES) {
        SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
        
        PUSH(settingViewController);
    }else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        PUSH(loginViewController);
    }
}

- (void)headClick {
    
    if ([[UserDefaults service] getLoginStatus] == YES) {
        MineDetailViewController *mineDetailViewController = [[MineDetailViewController alloc] initWithNibName:nil bundle:nil];
        
        PUSH(mineDetailViewController);
    }else {
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        
        PUSH(loginViewController);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self hideLoadHUD:YES];
}

@end
