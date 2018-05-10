//
//  BonusViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/9.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BonusViewController.h"
#import "BonusHeaderCell.h"
#import "ServiceGuideViewController.h"
#import "LoginViewController.h"
#import "PopView.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>


@interface BonusViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *contentView;
    NSDictionary *jsonDic;
    UIView *popContentView;
}

@end

@implementation BonusViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor clearColor];
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_bg"] forState:UIControlStateNormal];
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        
        contentView.delegate = self;
        
        contentView.dataSource = self;
        
        contentView.separatorStyle = NO;
        
        contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        //去除底部多余分割线
        contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:contentView];
        
        if (@available(iOS 11.0, *)) {
            contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [self.view bringSubviewToFront:navigationBar];
        
        popContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280*SCALE, 280*SCALE)];
        popContentView.backgroundColor = [UIColor lightGrayColor];
        
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
    
        [HttpClientService requestSharelink:paramDic success:^(id responseObject) {
    
            jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
    
            int status = [[jsonDic objectForKey:@"status"] intValue];
    
            if (status == 0) {
    
                [contentView setHidden:NO];
                [contentView reloadData];
    
    
                [self hideLoadHUD:YES];
            }else if (status == 202) {
                [self hideLoadHUD:YES];
                [self showMsg:@"您的登录状态失效，请重新登录"];
                
                sleep(1.0);
                LoginViewController *loginViewController = [[LoginViewController alloc] init];
                PUSH(loginViewController);
                
            }else {
                [self hideLoadHUD:YES];
//                [self showMsg:@"服务器异常"];
                
            }
    
        } failure:^(NSError *error) {
    
            [self hideLoadHUD:YES];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return SCREEN_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    
    
    
    BonusHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
    if (cell == nil) {
        cell = [[BonusHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
    }
    
//    __weak __typeof(&*cell)weakCell =cell;
    cell.wxBtnBlock = ^()
    {
        //创建发送对象实例
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息
        sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = [jsonDic objectForKey:@"title"];//分享标题
        urlMessage.description = [jsonDic objectForKey:@"subhead"];//分享描述
        //TODO替换分享图片
        [urlMessage setThumbImage:[UIImage imageNamed:@"180"]];//分享图片
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = [jsonDic objectForKey:@"url"];//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        
        //发送分享信息
        [WXApi sendReq:sendReq];
    };
    
    cell.qqBtnBlock = ^()
    {
        //TODO替换分享图片
        UIImage *image = [UIImage imageNamed:@"180"];
        NSData *imageData = UIImagePNGRepresentation(image);
        
        NSURL *url = [NSURL URLWithString:[jsonDic objectForKey:@"url"]];
        
        QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url
                                                        title:[jsonDic objectForKey:@"title"]
                                                  description:[jsonDic objectForKey:@"subhead"]
                                              previewImageData:imageData];
 
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:img];
        [QQApiInterface sendReq:req];
//        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    };
    
    cell.faceBtnBlock = ^()
    {
        
        // 1.创建过滤器
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        // 2.恢复默认
        [filter setDefaults];
        // 3.给过滤器添加数据(正则表达式/账号和密码)
        NSString *dataString = [jsonDic objectForKey:@"url"];
        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        [filter setValue:data forKeyPath:@"inputMessage"];
        
        // 4.获取输出的二维码
        CIImage *outputImage = [filter outputImage];
        // 5.将CIImage转换成UIImage，并放大显示
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(40*SCALE, 40*SCALE, 200*SCALE, 200*SCALE)];
        imageV.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200*SCALE];
        [popContentView addSubview:imageV];
        
        [PopView sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
        [PopView sharedInstance].closeButtonType = ButtonPositionTypeRight;
        [[PopView sharedInstance] showWithPresentView:popContentView animated:YES];
    };
    
    cell.friendBtnBlock = ^()
    {
        //创建发送对象实例
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息
        sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = [jsonDic objectForKey:@"title"];//分享标题
        urlMessage.description = [jsonDic objectForKey:@"subhead"];//分享描述
        //TODO替换分享图片
        [urlMessage setThumbImage:[UIImage imageNamed:@"180"]];//分享图片
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = [jsonDic objectForKey:@"url"];//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        
        //发送分享信息
        [WXApi sendReq:sendReq];
    };
    
    cell.tipsBtnBlock = ^()
    {
        ServiceGuideViewController *serviceGuideViewController = [[ServiceGuideViewController alloc] init];
        PUSH(serviceGuideViewController);
    };
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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

@end
