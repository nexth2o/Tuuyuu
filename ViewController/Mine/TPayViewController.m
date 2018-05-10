//
//  TPayViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/26.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "TPayViewController.h"
#import "TPayDetailViewController.h"

#import "LoginViewController.h"

@interface TPayViewController () {
    
    UIView *contentView;
    //二维码
    UIImageView *codeImageView;
    
    NSDictionary *jsonDic;
    
    //兔币余额
    UILabel *subTitle;
}

@end

@implementation TPayViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor whiteColor];
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        navigationBar.titleLabel.text = @"兔币支付";
        
        [navigationBar.editButton setHidden:NO];
        [navigationBar.editButton setTitle:@"兔币明细" forState:UIControlStateNormal];
        
        
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT)];
        [self.view addSubview:contentView];
        
        //兔币图标
        UIImageView *mark = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-90*SCALE)/2, 20*SCALE, 90*SCALE, 90*SCALE)];
        mark.image = [UIImage imageNamed:@"mine_pay_mark"];
//        mark.backgroundColor = [UIColor purpleColor];s
        [contentView addSubview:mark];
        
        //我的兔币
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mark.frame)+10*SCALE, SCREEN_WIDTH, 20*SCALE)];
//        title.backgroundColor = [UIColor lightGrayColor];
        title.text = @"我的兔币";
        title.font = [UIFont systemFontOfSize:15*SCALE];
        title.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:title];
        
        //兔币
        subTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame)+10*SCALE, SCREEN_WIDTH, 20*SCALE)];
        subTitle.text = @"0";
        subTitle.font = [UIFont boldSystemFontOfSize:20*SCALE];
        subTitle.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:subTitle];
        
        //二维码区
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subTitle.frame)+30*SCALE, SCREEN_WIDTH, 420*SCALE)];
        bg.image = [UIImage imageNamed:@"mine_pay_bg"];
        [contentView addSubview:bg];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(40*SCALE, 50*SCALE, SCREEN_WIDTH-80*SCALE, SCREEN_WIDTH-80*SCALE)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [bg addSubview:whiteView];
        
        //标题
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-80*SCALE, 40*SCALE)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [whiteView addSubview:line];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 10*SCALE, 20*SCALE, 20*SCALE)];
        icon.image = [UIImage imageNamed:@"mine_pay_icon"];
        [whiteView addSubview:icon];
        
        UILabel *QRtitle = [[UILabel alloc] initWithFrame:CGRectMake(40*SCALE, 0, SCREEN_WIDTH-120*SCALE, 40*SCALE)];
        QRtitle.text = @"二维码支付";
        QRtitle.textColor = MAIN_COLOR;
        QRtitle.font = [UIFont systemFontOfSize:13*SCALE];
        [whiteView addSubview:QRtitle];
   
        //二维码
        codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50*SCALE, 60*SCALE, 200*SCALE, 200*SCALE)];//185
        //        codeImageView.image = [UIImage imageNamed:@"pickup_qrcode"];
        [whiteView addSubview:codeImageView];
        
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
    [self showLoadHUDMsg:@"努力加载中..."];
    
        NSDictionary *paramDic = [[NSDictionary alloc] init];
    
        [HttpClientService requestQrcode:paramDic success:^(id responseObject) {
    
            jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
    
            int status = [[jsonDic objectForKey:@"status"] intValue];
    
            if (status == 0) {
                [contentView setHidden:NO];
                subTitle.text = [jsonDic objectForKey:@"integral"];
                
                // 1.创建过滤器
                CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
                // 2.恢复默认
                [filter setDefaults];
                // 3.给过滤器添加数据(正则表达式/账号和密码)
                NSString *dataString = [jsonDic objectForKey:@"code"];
                NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
                [filter setValue:data forKeyPath:@"inputMessage"];
                
                // 4.获取输出的二维码
                CIImage *outputImage = [filter outputImage];
                // 5.将CIImage转换成UIImage，并放大显示
                codeImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200*SCALE];
    
    
                [self hideLoadHUD:YES];
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
            
            NSLog(@"请求通知消息失败");
        }];
    
    
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}
- (void)editBtnClick:(id)sender {

    TPayDetailViewController *tPayDetailViewController = [[TPayDetailViewController alloc] init];
    PUSH(tPayDetailViewController);
}

@end
