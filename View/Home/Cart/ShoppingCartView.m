//
//  ShoppingCartView.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/1.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "ShoppingCartView.h"
#import "BadgeView.h"
#import "OverlayView.h"


#define SECTION_HEIGHT 40.0*SCALE
#define ROW_HEIGHT     40.0*SCALE
#define MAX_ROW        5
#define MARGIN         20.0*SCALE
#define TIPS_HEIGHT 30.0*SCALE
#define MAX_HEIGHT     MAX_ROW * ROW_HEIGHT+SECTION_HEIGHT+MARGIN+TIPS_HEIGHT

@interface ShoppingCartView ()<ZFReOrderTableViewDelegate>

@property (nonatomic,strong) OverlayView *OverlayView;

@property (nonatomic,strong) UILabel *money;

@property (nonatomic,strong) UIButton *accountBtn;

//@property (nonatomic,assign) NSUInteger minFreeMoney;

@property (nonatomic,assign) float nTotal;

@property (nonatomic,strong) NSMutableArray *objects;

@property (nonatomic,assign) BOOL up;


@end

@implementation ShoppingCartView


- (instancetype) initWithFrame:(CGRect)frame inView:(UIView *)parentView withObjects:(NSMutableArray *)objects {
    self = [super initWithFrame:frame];
    if (self) {
        self.parentView = parentView;
       
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    
//    _minFreeMoney = 20;
    
    self.backgroundColor = UIColorFromRGB(76,76,76);
    //横线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = UIColorFromRGB(240,240,240);
    [self addSubview:line];
    
    
    //购物金额提示框
    _money = [[UILabel alloc] initWithFrame:CGRectMake(80*SCALE, 10*SCALE, SCREEN_WIDTH, 30*SCALE)];
    [_money setTextColor:[UIColor grayColor]];
    [_money setText:@"购物车空空如也~"];
    [_money setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:_money];
    
    //结账按钮
    _accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _accountBtn.layer.cornerRadius = 5;
    _accountBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _accountBtn.frame = CGRectMake(self.bounds.size.width - 100*SCALE, 0.5, 100*SCALE, BOTTOM_BAR_HEIGHT-0.5);
    _accountBtn.backgroundColor = [UIColor lightGrayColor];
//    [_accountBtn setTitle:[NSString stringWithFormat:@"还差￥%ld",_minFreeMoney] forState:UIControlStateNormal];￥0起送
    [_accountBtn setTitle:@"￥0起送" forState:UIControlStateNormal];

    [_accountBtn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    _accountBtn.enabled = NO;
    [self addSubview:_accountBtn];
    
    //购物车
    _shoppingCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shoppingCartBtn setUserInteractionEnabled:NO];
    [_shoppingCartBtn setImage:[UIImage imageNamed:@"home_cart_empty"] forState:UIControlStateNormal];
//    _shoppingCartBtn.backgroundColor = [UIColor purpleColor];
    _shoppingCartBtn.frame = CGRectMake(10*SCALE, -18*SCALE, 60*SCALE, 60*SCALE);
    [_shoppingCartBtn addTarget:self action:@selector(clickCartBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shoppingCartBtn];
    
    //设置角标位置
    if (!_badge) {
        _badge = [[BadgeView alloc] initWithFrame:CGRectMake(_shoppingCartBtn.frame.size.width - 12*SCALE, 2*SCALE, 15*SCALE, 15*SCALE) withString:nil];
        [_shoppingCartBtn addSubview:_badge];
    }
    
    //购物车内菜品
    _OrderList = [[ZFReOrderTableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - MAX_HEIGHT - BOTTOM_BAR_HEIGHT, SCREEN_WIDTH, MAX_HEIGHT)
                                               withObjects:nil
                                                canReorder:YES];
    _OrderList.delegate = self;
    
//    _OrderList.backgroundColor = [UIColor clearColor];
    
    _OverlayView = [[OverlayView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _OverlayView.ShoppingCartView = self;
    [_OverlayView addSubview:self];
    [self.parentView addSubview:_OverlayView];
    
    _OverlayView.alpha = 0.0;
    
    _up = NO;
    
    
}


#pragma mark - private method

- (void)setCartImage:(NSString *)imageName {
    
    [_shoppingCartBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
}

//-(void)clickCartBtn:(UIButton *)sender
- (void)clickCartBtn {
    
    if (![_badge.badgeValue intValue]) {
        [_shoppingCartBtn setUserInteractionEnabled:NO];
        return;
    }
    weakify(self);
    if (_up) {
        [_shoppingCartBtn bringSubviewToFront:_OverlayView];
        [UIView animateWithDuration:0.5 animations:^{
            strongify(self);
            self.OverlayView.alpha = 0.0;
        } completion:^(BOOL finished) {
            strongify(self);
            self.up = NO;
        }];
    }else {
        
        [self updateFrame:_OrderList];
        [_OverlayView addSubview:_OrderList];
        
        [UIView animateWithDuration:0.5 animations:^{
            strongify(self);
            self.OverlayView.alpha = 1.0;
        } completion:^(BOOL finished) {
            strongify(self);
            self.up = YES;
        }];
        
    }
}

- (void)updateFrame:(UIView *)view {
    ZFReOrderTableView *orderListView = (ZFReOrderTableView *)view;
    
    float height = 0;

    NSInteger row = [orderListView.objects count];
    
    height = row * ROW_HEIGHT+SECTION_HEIGHT+MARGIN+TIPS_HEIGHT;

    if (height >= MAX_HEIGHT) {
        height = MAX_HEIGHT;
    }
    _OrderList.frame = CGRectMake(0, SCREEN_HEIGHT - height - BOTTOM_BAR_HEIGHT, SCREEN_WIDTH, height);
}

#pragma mark - dismiss
- (void)dismissAnimated:(BOOL)animated {
    
    [_shoppingCartBtn bringSubviewToFront:_OverlayView];
    weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        strongify(self);
        self.OverlayView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        strongify(self);
        self.up = NO;
    }];
}

- (void)pay:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(cashBtnClick:)]) {
        [_delegate cashBtnClick:sender];
    }
}

- (void)setTotalMoney:(float)nTotal {
    _nTotal = nTotal;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    NSString *amount = [formatter stringFromNumber:[NSNumber numberWithFloat:nTotal]];
    
    if(nTotal > 0)
    {
        _money.font = [UIFont systemFontOfSize:20*SCALE];
        _money.textColor = [UIColor whiteColor];
        _money.text = [NSString stringWithFormat:@"%@",amount];
        
        _accountBtn.enabled = YES;
        [_accountBtn setTitle:@"去结算" forState:UIControlStateNormal];
        [_accountBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
        [_accountBtn setBackgroundColor:ICON_COLOR];
        
        [_shoppingCartBtn setUserInteractionEnabled:YES];
    }
    else
    {
        [_money setTextColor:[UIColor lightGrayColor]];
        [_money setText:@"购物车空空如也~"];
        [_money setFont:[UIFont systemFontOfSize:13*SCALE]];
        
        _accountBtn.enabled = NO;
        [_accountBtn setTitle:[NSString stringWithFormat:@"￥0起送"] forState:UIControlStateNormal];
        [_accountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_accountBtn setBackgroundColor:UIColorFromRGB(128,128,128)];
        
        [_shoppingCartBtn setUserInteractionEnabled:NO];
    }
    
}



@end
