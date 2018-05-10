//
//  MineDetailViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/16.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineDetailViewController.h"
#import "MineDetailImageCell.h"
#import "MineDetailCell.h"
#import "CartInfoDAL.h"
#import "CartInfoEntity.h"
#import "EditMineDetailViewController.h"
#import "EditGenderViewController.h"
#import "EditPasswordViewController.h"

@interface MineDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    UITableView *contentView;
    
    NSMutableDictionary *personalDic;
}

@end

@implementation MineDetailViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
 
        navigationBar.titleLabel.text = @"个人详情";
        [navigationBar.leftButton setHidden:NO];
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        contentView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+20, SCREEN_WIDTH, 300*SCALE) style:UITableViewStylePlain];
        
        contentView.delegate = self;
        
        contentView.dataSource = self;
        
        contentView.scrollEnabled = NO;
        
        [self.view addSubview:contentView];
        
        //按钮
        UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, contentView.frame.origin.y+contentView.frame.size.height+100*SCALE, SCREEN_WIDTH - 20*2, 44.0f*SCALE)];
        logoutButton.layer.cornerRadius = 5;
        logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [logoutButton setBackgroundImage:[UIImage imageNamed:@"order_appraise"] forState:UIControlStateNormal];
        [logoutButton setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
        [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logoutEvent) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:logoutButton];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self newData];
    
}

- (void)newData {
    [self showLoadHUDMsg:@"努力加载中..."];
    NSDictionary *paramDic = [[NSDictionary alloc] init];
    
    //查询取餐列表
    [HttpClientService requestGetpersonalinfo:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            personalDic = [[NSMutableDictionary alloc] initWithDictionary:jsonDic];
            
            [[UserDefaults service] updateNickName:personalDic[@"nick_name"]];
            [[UserDefaults service] updateGender:personalDic[@"is_male"]];
            [[UserDefaults service] updatePhone:personalDic[@"tel_no"]];
            
            [contentView reloadData];
            
            [self hideLoadHUD:YES];
        }if (status == 202) {
            
            [[UserDefaults service] updateSessionId:@""];
            
            [self hideLoadHUD:YES];
            
            [self showMsgWithPop:@"其他设备登录您的账号，请重新登录"];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 100*SCALE;
    }else {
        return 50*SCALE;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        
        MineDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        
        if (!cell) {
            cell = [[MineDetailImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.headLabel.text = @"头像";
        
        if ([[[UserDefaults service] getGender] isEqualToString:@"1"]) {
            cell.headImage.image = [UIImage imageNamed:@"test_head"];
        }else {
            cell.headImage.image = [UIImage imageNamed:@"test_head2"];
        }
        
        
        return cell;
        
    }else if(indexPath.row == 1) {
        
        MineDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        
        if (!cell) {
            cell = [[MineDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.titleLabel.text = @"昵称";
        cell.detailTitleLabel.text = personalDic[@"nick_name"];
        
        return cell;
    }else if(indexPath.row == 2) {
        
        MineDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        
        if (!cell) {
            cell = [[MineDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.titleLabel.text = @"性别";
        if ([personalDic[@"is_male"] isEqualToString:@"0"]) {
            cell.detailTitleLabel.text = @"女";
        }else if ([personalDic[@"is_male"] isEqualToString:@"1"]) {
            cell.detailTitleLabel.text = @"男";
        }
        
        
        return cell;
    }else if(indexPath.row == 3) {
        
        MineDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        
        if (!cell) {
            cell = [[MineDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"手机号码";
        cell.detailTitleLabel.text = personalDic[@"tel_no"];
        
        return cell;
    }else if(indexPath.row == 4) {
        
        MineDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        
        if (!cell) {
            cell = [[MineDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.titleLabel.text = @"修改密码";
        
        return cell;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //修改头像
    if (indexPath.row == 0) {
//        [self alterHeadPortrait];
        
    }else if (indexPath.row == 1) {
        //昵称
        EditMineDetailViewController *editMineDetailViewController = [[EditMineDetailViewController alloc] initWithNibName:nil bundle:nil];
    
        editMineDetailViewController.titleLabel.text = @"昵称";
        
        PUSH(editMineDetailViewController);
        
    }else if (indexPath.row == 2) {
        //性别
        EditGenderViewController *editGenderViewController = [[EditGenderViewController alloc] initWithNibName:nil bundle:nil];
        
        PUSH(editGenderViewController);
        
    }else if (indexPath.row == 3) {
        
    }else if (indexPath.row == 4) {
        
        EditPasswordViewController *editPasswordViewController = [[EditPasswordViewController alloc] initWithNibName:nil bundle:nil];
        PUSH(editPasswordViewController);
        
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

//-(void)alterHeadPortrait:(UITapGestureRecognizer *)gesture{
- (void)alterHeadPortrait {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        PickerImage.allowsEditing = YES;
        
        PickerImage.delegate = self;
        
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        PickerImage.allowsEditing = YES;
        
        PickerImage.delegate = self;
        
        [self presentViewController:PickerImage animated:YES completion:nil];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    //压缩图片
    NSData *imageData = UIImageJPEGRepresentation(newPhoto, 0.5);
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSLog(@"图片储存路径：%@",DocumentsPath);
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:imageData attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,@"/image.png"];
    NSLog(@"................%@",filePath);
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //TODO 上传图片
    [self uploadImage:filePath];
    
}

- (void)uploadImage:(NSString *)filePath {
    
//    [self showLoadHUDMsg:@"正在修改头像..."];
//    
//    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    
//    //    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:tokenStr, @"token", nil];
//    
//    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"userId",@"", @"token",@"", @"loginToken",@"111", @"appId", nil];
//    
//    //上传头像
//    [HttpClientService requestUploadImage:paramDic filePath:filePath success:^(id responseObject) {
//        
//        //        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"iconData"];
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"上传成功dic:%@",dic);
//        NSDictionary *imageDic = [dic objectForKey:@"data"];
//        [[UserDefaults service] updateImgUrl:[imageDic objectForKey:@"imgUrl"]];
//        [contentView reloadData];
//        
//        [self hideLoadHUD:YES];
//        
//        [self showMsg:@"头像修改成功"];
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"%@",[error description]);
//        NSLog(@"上传失败%@",error);
//        
//    }];
    
}

- (void)logoutEvent {
    
    [self showLoadHUDMsg:@"正在退出登录..."];
    
    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
    
    [dal cleanCartInfo];
    
    [[UserDefaults service] updateSessionId:@"0"];
    //兔币
    [[UserDefaults service] updateIntegral:@""];
    
    //星级
    [[UserDefaults service] updateValueStar:@""];
    
    //会员等级 0 注册会员1铜牌会员2银牌会员,3 金牌会员,4 钻石会员
    [[UserDefaults service] updateGrade:@""];
    
    //昵称
    [[UserDefaults service] updateNickName:@""];
    //性别
    [[UserDefaults service] updateGender:@""];
    //电话
    [[UserDefaults service] updatePhone:@""];
    
    [[UserDefaults service] updateName:@""];
    [[UserDefaults service] updateAddressGender:@""];
    [[UserDefaults service] updateAddressPhone:@""];
    [[UserDefaults service] updateAddress:@""];
    [[UserDefaults service] updateBuilding:@""];
    [[UserDefaults service] updateAddressLatitude:@""];
    [[UserDefaults service] updateAddressLongitude:@""];
    
    [self hideLoadHUD:YES];
    
    [self showCustomDialog:@"退出登录成功"];
    
}


#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

@end
