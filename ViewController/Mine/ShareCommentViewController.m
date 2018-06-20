//
//  ShareCommentViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/8/9.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "ShareCommentViewController.h"
#import "HomeButton.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface ShareCommentViewController () {
    UILabel *title;
    
    UIImageView *star1;
    UIImageView *star2;
    UIImageView *star3;
    UIImageView *star4;
    UIImageView *star5;
}

@property(nonatomic, strong) NSDictionary *jsonDic;
@property(nonatomic, strong) UILabel *rateMsg;
@property(nonatomic, strong) HomeButton *qqBtn;
@property(nonatomic, strong) HomeButton *friendBtn;
@property(nonatomic, strong) HomeButton *wxBtn;
@property(nonatomic, strong) UIView *whiteView;

@end

@implementation ShareCommentViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor clearColor];
        
        navigationBar.titleLabel.text = @"分享评价";
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_bg"] forState:UIControlStateNormal];
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        //白色背景
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(20*SCALE, 80*SCALE, SCREEN_WIDTH-40*SCALE, SCREEN_WIDTH+20*SCALE)];
        _whiteView.backgroundColor = [UIColor whiteColor];
    
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-40*SCALE-70*SCALE)/2, 30*SCALE, 70*SCALE, 70*SCALE)];
        icon.image = [UIImage imageNamed:@"order_logo"];
        [_whiteView addSubview:icon];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(0*SCALE, CGRectGetMaxY(icon.frame)+10*SCALE, SCREEN_WIDTH-40*SCALE, 20*SCALE)];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"兔悠沈阳站店";
//        title.textColor = [UIColor darkGrayColor];
        title.font = [UIFont systemFontOfSize:16*SCALE];
        [_whiteView addSubview:title];
        
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(0*SCALE, CGRectGetMaxY(title.frame)+30*SCALE, SCREEN_WIDTH-40*SCALE, 20*SCALE)];
        subTitle.textAlignment = NSTextAlignmentCenter;
        subTitle.text = @"我的评价";
        subTitle.textColor = [UIColor darkGrayColor];
        subTitle.font = [UIFont systemFontOfSize:13*SCALE];
        [_whiteView addSubview:subTitle];
        
        
        star1 = [[UIImageView alloc] initWithFrame:CGRectMake(100*SCALE, CGRectGetMaxY(subTitle.frame)+20*SCALE, 24*SCALE, 24*SCALE)];
        star1.image = [UIImage imageNamed:@"score_star_yellow"];
        [_whiteView addSubview:star1];
        
        star2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(star1.frame)+5*SCALE, CGRectGetMaxY(subTitle.frame)+20*SCALE, 24*SCALE, 24*SCALE)];
        star2.image = [UIImage imageNamed:@"score_star_yellow"];
        [_whiteView addSubview:star2];
        
        star3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(star2.frame)+5*SCALE, CGRectGetMaxY(subTitle.frame)+20*SCALE, 24*SCALE, 24*SCALE)];
        star3.image = [UIImage imageNamed:@"score_star_yellow"];
        [_whiteView addSubview:star3];
        
        star4 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(star3.frame)+5*SCALE, CGRectGetMaxY(subTitle.frame)+20*SCALE, 24*SCALE, 24*SCALE)];
        star4.image = [UIImage imageNamed:@"score_star_yellow"];
        [_whiteView addSubview:star4];
        
        star5 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(star4.frame)+5*SCALE, CGRectGetMaxY(subTitle.frame)+20*SCALE, 24*SCALE, 24*SCALE)];
        star5.image = [UIImage imageNamed:@"score_star_yellow"];
        [_whiteView addSubview:star5];
        
        
        _rateMsg = [[UILabel alloc] initWithFrame:CGRectMake(20*SCALE, CGRectGetMaxY(star1.frame)+10*SCALE, SCREEN_WIDTH-60*SCALE, 70*SCALE)];
        _rateMsg.font = [UIFont systemFontOfSize:13*SCALE];
        _rateMsg.textColor = [UIColor darkGrayColor];
        _rateMsg.numberOfLines = 4;
        [_whiteView addSubview:_rateMsg];
        
        UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(95*SCALE, CGRectGetMaxY(_rateMsg.frame) + 20*SCALE, 70*SCALE, 20*SCALE)];
        tips.font = [UIFont systemFontOfSize:15*SCALE];
        tips.text = @"兔悠到家";
//        tips.backgroundColor = [UIColor purpleColor];
        [_whiteView addSubview:tips];
        
        UILabel *tipsDetail = [[UILabel alloc] initWithFrame:CGRectMake(95*SCALE, CGRectGetMaxY(tips.frame) + 5*SCALE, 220*SCALE, 20*SCALE)];
        tipsDetail.font = [UIFont systemFontOfSize:12*SCALE];
        tipsDetail.text = @"长按识别图中二维码 查看商家更多信息";
        tipsDetail.textColor = [UIColor darkGrayColor];
//        tipsDetail.backgroundColor = [UIColor purpleColor];
        [_whiteView addSubview:tipsDetail];
        
        
        _wxBtn = [HomeButton buttonWithType:UIButtonTypeCustom];
        [_wxBtn setFrame:CGRectMake(40*SCALE, 500*SCALE, 80*SCALE, 80*SCALE)];
        
        [_wxBtn setImage:[UIImage imageNamed:@"home_bonus_wx"] forState:UIControlStateNormal];
        [_wxBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_wxBtn setTitle:@"微信好友" forState:UIControlStateNormal];
        [_wxBtn.titleLabel setFont:[UIFont systemFontOfSize:9*SCALE]];
        [_wxBtn verticalImageAndTitle:6*SCALE];
        [_wxBtn addTarget:self action:@selector(wxBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        //        _wxBtn.backgroundColor = [UIColor blueColor];
        
        
        _qqBtn = [HomeButton buttonWithType:UIButtonTypeCustom];
        [_qqBtn setFrame:CGRectMake(CGRectGetMaxX(_wxBtn.frame)+30*SCALE, 500*SCALE, 80*SCALE, 80*SCALE)];
        [_qqBtn setImage:[UIImage imageNamed:@"home_bonus_qq"] forState:UIControlStateNormal];
        [_qqBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_qqBtn setTitle:@"QQ好友" forState:UIControlStateNormal];
        [_qqBtn.titleLabel setFont:[UIFont systemFontOfSize:9*SCALE]];
        [_qqBtn verticalImageAndTitle:6*SCALE];
        [_qqBtn addTarget:self action:@selector(qqBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        //        _qqBtn.backgroundColor = [UIColor blueColor];
        
        _friendBtn = [HomeButton buttonWithType:UIButtonTypeCustom];
        [_friendBtn setFrame:CGRectMake(CGRectGetMaxX(_qqBtn.frame)+30*SCALE, 500*SCALE, 80*SCALE, 80*SCALE)];
        [_friendBtn setImage:[UIImage imageNamed:@"home_bonus_friend"] forState:UIControlStateNormal];
        [_friendBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_friendBtn setTitle:@"朋友圈" forState:UIControlStateNormal];
        [_friendBtn.titleLabel setFont:[UIFont systemFontOfSize:9*SCALE]];
        [_friendBtn verticalImageAndTitle:6*SCALE];
        [_friendBtn addTarget:self action:@selector(friendBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        //        _qqBtn.backgroundColor = [UIColor blueColor];
        
        
        _orderDictionary = [[NSMutableDictionary alloc] init];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self hideTabBar:self.tabBarController];
    self.tabBarController.tabBar.hidden=YES;
    
    [self requestShare];
}


- (void)requestShare {
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"order_id"], @"order_id", nil];
    weakify(self);
    [HttpClientService requestOrderrateshare:paramDic success:^(id responseObject) {
        strongify(self);
        self.jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[self.jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {

            [self reloadView];
            [self hideLoadHUD:YES];
 
            // 1.创建过滤器
            CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
            // 2.恢复默认
            [filter setDefaults];
            // 3.给过滤器添加数据(正则表达式/账号和密码)
            NSString *dataString = [self.jsonDic objectForKey:@"register_url"];
            NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
            [filter setValue:data forKeyPath:@"inputMessage"];
            
            // 4.获取输出的二维码
            CIImage *outputImage = [filter outputImage];
            // 5.将CIImage转换成UIImage，并放大显示
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20*SCALE, CGRectGetMaxY(self.rateMsg.frame) + 10*SCALE, 65*SCALE, 65*SCALE)];
//            imageV.backgroundColor = [UIColor purpleColor];
            imageV.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:65*SCALE];
            [self.whiteView addSubview:imageV];
            
            [self.view addSubview:self.whiteView];
            
            [self.view addSubview:self.wxBtn];
            [self.view addSubview:self.qqBtn];
            [self.view addSubview:self.friendBtn];
            
            [self cutUIImage];
            
        }else if (status == 202) {
            [self showMsg:@"您的登录状态失效，请重新登录"];
            [self hideLoadHUD:YES];
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else {
            [self hideLoadHUD:YES];
            [self showMsg:[NSString stringWithFormat:@"错误码%d", status]];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        NSLog(@"请求分享评价失败");
    }];
}

- (void)reloadView {
    
    title.text = [_jsonDic objectForKey:@"cvs_name"];
    
    //评论星
    UIImage *halfStar = [UIImage imageNamed:@"score_star_half"];
    UIImage *grayStar = [UIImage imageNamed:@"score_star_gray"];
    UIImage *yellowStar = [UIImage imageNamed:@"score_star_yellow"];
    
    double count = [[_jsonDic objectForKey:@"cvs_rate"] doubleValue];
    
    for (int i = 0; i < 5; i++) {
        
        if ((count-i) >= 0.25 && (count-i) < 0.75) {//半星
            if (i==0) {
                star1.image = halfStar;
            }else if (i==1) {
                star2.image = halfStar;
            }else if (i==2) {
                star3.image = halfStar;
            }else if (i==3) {
                star4.image = halfStar;
            }else if (i==4) {
                star5.image = halfStar;
            }
        }else if ((count-i) < 0.25) {//空星
            if (i==0) {
                star1.image = grayStar;
            }else if (i==1) {
                star2.image = grayStar;
            }else if (i==2) {
                star3.image = grayStar;
            }else if (i==3) {
                star4.image = grayStar;
            }else if (i==4) {
                star5.image = grayStar;
            }
        }else {//满星
            if (i==0) {
                star1.image = yellowStar;
            }else if (i==1) {
                star2.image = yellowStar;
            }else if (i==2) {
                star3.image = yellowStar;
            }else if (i==3) {
                star4.image = yellowStar;
            }else if (i==4) {
                star5.image = yellowStar;
            }
        }
    }
    
    if (count > 0) {
        [star1 setHidden:NO];
        [star2 setHidden:NO];
        [star3 setHidden:NO];
        [star4 setHidden:NO];
        [star5 setHidden:NO];
    }else {
        star1.image = grayStar;
        star2.image = grayStar;
        star3.image = grayStar;
        star4.image = grayStar;
        star5.image = grayStar;
    }
    
    _rateMsg.text = [_jsonDic objectForKey:@"rate_msg"];
    
}

- (UIImage*)cutUIImage{

    UIGraphicsBeginImageContext(_whiteView.frame.size);
    [_whiteView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;// 生成后
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(newImage);
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MAX(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
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

- (void)wxBtnEvent {
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
//    
    WXMediaMessage * message = [WXMediaMessage message];
    [message setThumbImage:[self cutUIImage]];
    
    WXImageObject * imageObject = [WXImageObject object];
//    imageObject.imageData = [self imageWithImage:[self cutUIImage] scaledToSize:CGSizeMake(300, 300)];
    imageObject.imageData = [self imageWithImage:[self cutUIImage] scaledToSize:_whiteView.frame.size];
    
    message.mediaObject = imageObject;
    
    sendReq.message = message;

    [WXApi sendReq:sendReq];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)friendBtnEvent {
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    WXMediaMessage * message = [WXMediaMessage message];
    [message setThumbImage:[self cutUIImage]];
    
    WXImageObject * imageObject = [WXImageObject object];
    imageObject.imageData = [self imageWithImage:[self cutUIImage] scaledToSize:CGSizeMake(300, 300)];
    message.mediaObject = imageObject;
    
    sendReq.message = message;
    
    [WXApi sendReq:sendReq];
}

- (void)qqBtnEvent {
    //TODO替换分享图片
//    UIImage *image = [UIImage imageNamed:@"test_btn"];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    
//    NSURL *url = [NSURL URLWithString:[jsonDic objectForKey:@"url"]];
//    
//    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url
//                                                    title:[jsonDic objectForKey:@"title"]
//                                              description:[jsonDic objectForKey:@"subhead"]
//                                         previewImageData:imageData];
//    
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:img];
//    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:[self imageWithImage:[self cutUIImage] scaledToSize:CGSizeMake(300, 300)]
                                               previewImageData:[self imageWithImage:[self cutUIImage] scaledToSize:CGSizeMake(300, 300)]
                                                          title:@""
                                                    description:@""];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    
    //将内容分享到qq
    
//    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [QQApiInterface sendReq:req];
}


#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

@end
