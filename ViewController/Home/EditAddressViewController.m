//
//  EditAddressViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/22.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "EditAddressViewController.h"
#import "SearchBuildingViewController.h"
#import "LoginViewController.h"

@interface EditAddressViewController ()<UIScrollViewDelegate, UITextFieldDelegate> {
    
    UIImageView *maleImage;
    UIImageView *femaleImage;
    
    UITextField *nameField;
    UITextField *phoneField;
    UITextField *addressField;
    UITextField *buildingField;
}

@end

@implementation EditAddressViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor whiteColor];
        navigationBar.titleLabel.text = @"";
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        [navigationBar.editButton setTitle:@"保存" forState:UIControlStateNormal];
        [navigationBar.editButton setHidden:NO];
        
        UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundClick)];
        [contentView addGestureRecognizer:tap];
        contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:contentView];
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        //图标
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(12*SCALE, 12*SCALE, 16*SCALE, 16*SCALE)];
        icon.image = [UIImage imageNamed:@"order_address"];
        [contentView addSubview:icon];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10*SCALE, 10*SCALE, 60*SCALE, 20*SCALE)];
        title.text = @"地址信息";
        title.textColor = [UIColor darkGrayColor];
        title.font = [UIFont systemFontOfSize:13*SCALE];
        [contentView addSubview:title];
        
        UIView *whiteBg = [[UIView alloc] initWithFrame:CGRectMake(0, 40*SCALE, SCREEN_WIDTH, 41*5*SCALE)];
        whiteBg.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:whiteBg];
        
        //姓名
        nameField = [[UITextField alloc] initWithFrame:CGRectMake(10*SCALE, 40*SCALE, SCREEN_WIDTH - 20*SCALE, 40*SCALE)];
        nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 收货人姓名（请使用真实姓名）" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        nameField.textColor = [UIColor blackColor];
        nameField.font = [UIFont systemFontOfSize:13.0*SCALE];
        nameField.delegate = self;
        [contentView addSubview:nameField];
        
        //线
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameField.frame), SCREEN_WIDTH, 1)];
        line1.backgroundColor = UIColorFromRGB(250, 250, 250);
        [contentView addSubview:line1];
        
        //性别
        //男
        maleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(nameField.frame)+10*SCALE+1, 20*SCALE, 20*SCALE)];
        maleImage.image = [UIImage imageNamed:@"male_selected"];
        [contentView addSubview:maleImage];
        
        UILabel *maleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maleImage.frame)+5*SCALE, CGRectGetMaxY(nameField.frame)+10*SCALE+1, 40*SCALE, 20*SCALE)];
        maleLabel.text = @"先生";
        maleLabel.textColor = [UIColor lightGrayColor];
        maleLabel.font = [UIFont systemFontOfSize:13*SCALE];
        [contentView addSubview:maleLabel];
        
        UIButton *maleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [maleBtn setFrame:CGRectMake(10*SCALE, CGRectGetMaxY(nameField.frame)+1, 80*SCALE, 40*SCALE)];
        [maleBtn addTarget:self action:@selector(maleBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:maleBtn];
        
        //女
        femaleImage = [[UIImageView alloc] initWithFrame:CGRectMake(100*SCALE, CGRectGetMaxY(nameField.frame)+10*SCALE+1, 20*SCALE, 20*SCALE)];
        femaleImage.image = [UIImage imageNamed:@"female_unselected"];
        [contentView addSubview:femaleImage];
        
        UILabel *femaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(femaleImage.frame)+5*SCALE, CGRectGetMaxY(nameField.frame)+10*SCALE+1, 40*SCALE, 20*SCALE)];
        femaleLabel.text = @"女士";
        femaleLabel.textColor = [UIColor lightGrayColor];
        femaleLabel.font = [UIFont systemFontOfSize:13*SCALE];
        [contentView addSubview:femaleLabel];
        
        UIButton *femaleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [femaleBtn setFrame:CGRectMake(100*SCALE, CGRectGetMaxY(nameField.frame)+1, 80*SCALE, 40*SCALE)];
        [femaleBtn addTarget:self action:@selector(femaleBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:femaleBtn];
        
        //线
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(maleBtn.frame), SCREEN_WIDTH, 1)];
        line2.backgroundColor = UIColorFromRGB(250, 250, 250);
        [contentView addSubview:line2];
        
        //手机号码
        phoneField = [[UITextField alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(maleBtn.frame)+1, SCREEN_WIDTH - 20*SCALE, 40*SCALE)];
        phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 手机号码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        phoneField.textColor = [UIColor blackColor];
        phoneField.delegate = self;
        phoneField.keyboardType = UIKeyboardTypeNumberPad;
        phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        phoneField.inputAccessoryView = [self addToolbar];
        phoneField.font = [UIFont systemFontOfSize:13.0*SCALE];
        [contentView addSubview:phoneField];
        
        //线
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneField.frame), SCREEN_WIDTH, 1)];
        line3.backgroundColor = UIColorFromRGB(250, 250, 250);
        [contentView addSubview:line3];
        
        //小区大厦学校
        addressField = [[UITextField alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(phoneField.frame)+1, SCREEN_WIDTH - 20*SCALE, 40*SCALE)];
        addressField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 小区/大厦/学校" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        addressField.delegate = self;
        addressField.textColor = [UIColor blackColor];
        addressField.font = [UIFont systemFontOfSize:13.0*SCALE];
        [addressField setEnabled:NO];
        [contentView addSubview:addressField];
        
        UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [addressBtn setFrame:CGRectMake(0, CGRectGetMaxY(phoneField.frame)+1, SCREEN_WIDTH, 40*SCALE)];
        [addressBtn addTarget:self action:@selector(addressBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:addressBtn];
        
        //线
        UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addressField.frame), SCREEN_WIDTH, 1)];
        line4.backgroundColor = UIColorFromRGB(250, 250, 250);
        [contentView addSubview:line4];
        
        //详细地址
        buildingField = [[UITextField alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(addressField.frame)+1, SCREEN_WIDTH - 20*SCALE, 40*SCALE)];
        buildingField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 例：17号楼331室" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        buildingField.delegate = self;
        buildingField.textColor = [UIColor blackColor];
        buildingField.font = [UIFont systemFontOfSize:13.0*SCALE];
        [contentView addSubview:buildingField];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([navigationBar.titleLabel.text isEqualToString:@""]) {
        
        if ([[UserDefaults service] getEditName].length > 0) {
            navigationBar.titleLabel.text = @"修改地址";
        }else {
            navigationBar.titleLabel.text = @"新增地址";
        }
    }

    nameField.text = [[UserDefaults service] getEditName];
    phoneField.text = [[UserDefaults service] getEditPhone];
    addressField.text = [[UserDefaults service] getEditAddress];
    buildingField.text = [[UserDefaults service] getEditBuilding];
    
    if ([[[UserDefaults service] getEditGender] isEqualToString:@"0"]) {
        maleImage.image = [UIImage imageNamed:@"male_unselected"];
        femaleImage.image = [UIImage imageNamed:@"female_selected"];
        
    }else if ([[[UserDefaults service] getEditGender] isEqualToString:@"1"]){
        maleImage.image = [UIImage imageNamed:@"male_selected"];
        femaleImage.image = [UIImage imageNamed:@"female_unselected"];
    }else {
        [[UserDefaults service] updateEditGender:@"0"];
        maleImage.image = [UIImage imageNamed:@"male_unselected"];
        femaleImage.image = [UIImage imageNamed:@"female_selected"];
    }
    
    if ([[[UserDefaults service] getEditAddress] length] > 0) {
        addressField.placeholder = @"";
    }else {
        addressField.placeholder = @" 小区/大厦/学校";
    }
}

- (void)maleBtnEvent {
    maleImage.image = [UIImage imageNamed:@"male_selected"];
    femaleImage.image = [UIImage imageNamed:@"female_unselected"];
    [[UserDefaults service] updateEditGender:@"1"];
}

- (void)femaleBtnEvent {
    maleImage.image = [UIImage imageNamed:@"male_unselected"];
    femaleImage.image = [UIImage imageNamed:@"female_selected"];
    [[UserDefaults service] updateEditGender:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addressBtnEvent {
    
    [[UserDefaults service] updateEditName:nameField.text];
    [[UserDefaults service] updateEditPhone:phoneField.text];
    
    
    SearchBuildingViewController *searchBuildingViewController = [[SearchBuildingViewController alloc] init];
    PUSH(searchBuildingViewController);
}


#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    
    [[UserDefaults service] updateEditName:@""];
    [[UserDefaults service] updateEditGender:@""];
    [[UserDefaults service] updateEditPhone:@""];
    [[UserDefaults service] updateEditAddress:@""];
    [[UserDefaults service] updateEditBuilding:@""];
    [[UserDefaults service] updateEditLatitude:@""];
    [[UserDefaults service] updateEditLongitude:@""];
    [[UserDefaults service] updateEditAddressId:@""];
    
    [[UserDefaults service] getEditLatitude];
    [[UserDefaults service] getEditLongitude];
    POP;
}


- (void)editBtnClick:(id)sender {
    
    if([nameField.text isEqualToString:@""] || [phoneField.text isEqualToString:@""] || [addressField.text isEqualToString:@""] || [buildingField.text isEqualToString:@""]) {
        
        [self showMsg:@"请输入完整信息"];
        return;
    }
    
    if ([navigationBar.titleLabel.text isEqualToString:@"修改地址"]) {
        [self editAddress];
    }else {
        [self saveAddress];
    }

    
    
}

- (void)saveAddress {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:nameField.text, @"name", phoneField.text, @"tel_no", addressField.text, @"address", buildingField.text, @"building", @"0", @"is_default", [[UserDefaults service] getEditGender], @"flag", [[UserDefaults service] getEditLatitude], @"latitude", [[UserDefaults service] getEditLongitude], @"longitude", nil];
    
    [HttpClientService requestAddressadd:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            [self hideLoadHUD:YES];
            
            
            [[UserDefaults service] updateEditName:@""];
            [[UserDefaults service] updateEditGender:@""];
            [[UserDefaults service] updateEditPhone:@""];
            [[UserDefaults service] updateEditAddress:@""];
            [[UserDefaults service] updateEditBuilding:@""];
            [[UserDefaults service] updateEditAddressId:@""];
            
            
            [self showCustomDialog:@"新增地址成功"];
            
        }else if (status == 202) {
            [self hideLoadHUD:YES];
            [self showMsg:@"您的登录状态失效，请重新登录"];
            
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else if (status == 109) {
            [self hideLoadHUD:YES];
            [self cancelSuccess];
            
        }else {
            [self hideLoadHUD:YES];
            [self showMsg:[NSString stringWithFormat:@"错误码%zd", status]];
            
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        NSLog(@"新增地址失败");
    }];
    
}

- (void)cancelSuccess{
    
    UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您最多只能有5个送货地址" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    
    [storeExistAlert addAction:OKButton];
    
    [self presentViewController:storeExistAlert animated:YES completion:nil];
}

- (void)editAddress {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:nameField.text, @"name", phoneField.text, @"tel_no", addressField.text, @"address", buildingField.text, @"building", @"0", @"is_default", [[UserDefaults service] getEditGender], @"flag", [[UserDefaults service] getEditLatitude], @"latitude", [[UserDefaults service] getEditLongitude], @"longitude", [[UserDefaults service] getEditAddressId], @"address_id", nil];
    
    [HttpClientService requestAddressmodify:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            [self hideLoadHUD:YES];
            
            [[UserDefaults service] updateEditName:@""];
            [[UserDefaults service] updateEditGender:@""];
            [[UserDefaults service] updateEditPhone:@""];
            [[UserDefaults service] updateEditAddress:@""];
            [[UserDefaults service] updateEditBuilding:@""];
         
            [[UserDefaults service] updateEditAddressId:@""];
            
            
            [self showCustomDialog:@"地址修改成功"];
            
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


- (UIToolbar *)addToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
    toolbar.tintColor = MAIN_COLOR;
    toolbar.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[space, bar];
    return toolbar;
}

- (void)textFieldDone {
    
    [buildingField becomeFirstResponder];
}

- (void)backGroundClick{
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}


@end
