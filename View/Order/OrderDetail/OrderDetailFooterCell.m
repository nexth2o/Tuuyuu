//
//  OrderDetailFooterCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/15.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderDetailFooterCell.h"

@implementation OrderDetailFooterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //商家电话
        UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [telBtn setFrame:CGRectMake((SCREEN_WIDTH -100*SCALE)/2, 0*SCALE, 100*SCALE, 40*SCALE)];
        [telBtn setBackgroundImage:[UIImage imageNamed:@"order_store_phone"] forState:UIControlStateNormal];
        [telBtn addTarget:self action:@selector(tel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:telBtn];
        
        //线
        UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(telBtn.frame), SCREEN_WIDTH, 6)];
        line0.backgroundColor = UIColorFromRGB(250, 250, 250);
        [self addSubview:line0];
        
        //期望时间
        UILabel *_timeTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(line0.frame), 60*SCALE, 35*SCALE)];
        _timeTitle.text = @"期望时间";
        _timeTitle.textColor = [UIColor darkGrayColor];
        _timeTitle.font = [UIFont systemFontOfSize:14*SCALE];
//        _timeTitle.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_timeTitle];
        
        //期望时间内容
        _time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeTitle.frame)+10*SCALE, CGRectGetMaxY(line0.frame), 200*SCALE, 35*SCALE)];
        _time.text = @"立即配送";
        _time.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_time];
        
        //线
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_time.frame), SCREEN_WIDTH, 1)];
        line1.backgroundColor = UIColorFromRGB(250, 250, 250);
        [self addSubview:line1];
        
        //配送地址
        UILabel *_addressTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_time.frame), 60*SCALE, 35*SCALE)];
        _addressTitle.text = @"配送地址";
        _addressTitle.textColor = [UIColor darkGrayColor];
        _addressTitle.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_addressTitle];
        
        
        //姓名电话
        _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_addressTitle.frame)+10*SCALE, _addressTitle.frame.origin.y, 200*SCALE, 35*SCALE)];
        _name.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_name];
        
        //住址
        _address = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_addressTitle.frame)+10*SCALE, _addressTitle.frame.origin.y+35*SCALE, 300*SCALE, 35*SCALE)];
        _address.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_address];
        
        //线
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_address.frame), SCREEN_WIDTH, 1)];
        line2.backgroundColor = UIColorFromRGB(250, 250, 250);
        [self addSubview:line2];
        
        //配送服务
        UILabel *_serviceTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_address.frame), 60*SCALE, 35*SCALE)];
        _serviceTitle.text = @"配送服务";
        _serviceTitle.textColor = [UIColor darkGrayColor];
        _serviceTitle.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_serviceTitle];
        
        //配送服务内容
        UILabel *service = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_serviceTitle.frame)+10*SCALE, _serviceTitle.frame.origin.y, 200*SCALE, 35*SCALE)];
        service.text = @"由兔悠骑士提供配送服务";
        service.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:service];
        
        //粗线
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(service.frame), SCREEN_WIDTH, 6)];
        line3.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:line3];
        
        //订单号码
        UILabel *_numberTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(line3.frame), 60*SCALE, 35*SCALE)];
        _numberTitle.text = @"订单号码";
        _numberTitle.textColor = [UIColor darkGrayColor];
        _numberTitle.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_numberTitle];
        
        //订单号码内容
        _number = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_numberTitle.frame)+10*SCALE, _numberTitle.frame.origin.y, 200*SCALE, 35*SCALE)];
        _number.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_number];
        
        //线
        UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_number.frame), SCREEN_WIDTH, 1)];
        line4.backgroundColor = UIColorFromRGB(250, 250, 250);
        [self addSubview:line4];
        
        //订单时间
        UILabel *_orderTimeTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_number.frame), 60*SCALE, 35*SCALE)];
        _orderTimeTitle.text = @"订单时间";
        _orderTimeTitle.textColor = [UIColor darkGrayColor];
        _orderTimeTitle.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_orderTimeTitle];
        
        //订单时间内容
        _orderTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_orderTimeTitle.frame)+10*SCALE, _orderTimeTitle.frame.origin.y, 200*SCALE, 35*SCALE)];
        _orderTime.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_orderTime];
        
        //线
        UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_orderTime.frame), SCREEN_WIDTH, 1)];
        line5.backgroundColor = UIColorFromRGB(250, 250, 250);
        [self addSubview:line5];
        
        //支付方式
        UILabel *_payTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_orderTime.frame), 60*SCALE, 35*SCALE)];
        _payTitle.text = @"支付方式";
        _payTitle.textColor = [UIColor darkGrayColor];
        _payTitle.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_payTitle];
        
        //支付方式内容
        _pay = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_payTitle.frame)+10*SCALE, _payTitle.frame.origin.y, 200*SCALE, 35*SCALE)];
        _pay.text = @"在线支付";
        _pay.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_pay];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)tel:(id)sender {
    
    self.phoneBlock();
    
}

@end
