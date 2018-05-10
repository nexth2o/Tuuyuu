//
//  GetDeliveryDatesViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/11/10.
//  Copyright © 2017年 JapanI. All rights reserved.
//

#import "GetDeliveryDatesViewController.h"
#import "GetDeliveryDatesCell.h"

@interface GetDeliveryDatesViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *contentView;
}

@end

//#define FOOTER_HEIGHT 50
#define FOOTER_HEIGHT BOTTOM_BAR_HEIGHT

#define CELL_HEIGHT 44

@implementation GetDeliveryDatesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [navigationBar setHidden:YES];
        
        self.view.backgroundColor = [UIColor clearColor];
        
        contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - CELL_HEIGHT*SCALE*5-FOOTER_HEIGHT, SCREEN_WIDTH, CELL_HEIGHT*SCALE*5+FOOTER_HEIGHT) style:UITableViewStylePlain];
        contentView.delegate = self;
        contentView.dataSource = self;
        contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:contentView];
        
        _deliveryDatesArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([_deliveryDatesArray count] > 5) {
        [contentView setFrame:CGRectMake(0, SCREEN_HEIGHT - CELL_HEIGHT*SCALE*5-FOOTER_HEIGHT, SCREEN_WIDTH, CELL_HEIGHT*SCALE*5+FOOTER_HEIGHT)];
    }else {
        [contentView setFrame:CGRectMake(0, SCREEN_HEIGHT - CELL_HEIGHT*SCALE*[_deliveryDatesArray count]-FOOTER_HEIGHT, SCREEN_WIDTH, CELL_HEIGHT*SCALE*[_deliveryDatesArray count]+FOOTER_HEIGHT)];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_deliveryDatesArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT*SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        static NSString *myCellIdentifier = @"MyCellIdentifier";
    
    GetDeliveryDatesCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    
    if (!cell) {
        cell = [[GetDeliveryDatesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier];
    }

    NSString *hhStr = [[_deliveryDatesArray objectAtIndex:indexPath.row][@"time"] substringWithRange:NSMakeRange(8,2)];
    NSString *mmStr = [[_deliveryDatesArray objectAtIndex:indexPath.row][@"time"] substringWithRange:NSMakeRange(10,2)];
    NSString *hhmmStr = [NSString stringWithFormat:@"%@:%@", hhStr, mmStr];
    
    cell.time.text = hhmmStr;

        if ([[_deliveryDatesArray objectAtIndex:indexPath.row][@"selected"] isEqualToString:@"1"]) {
            cell.accessoryType = cell.accessoryType = UITableViewCellAccessoryCheckmark;

        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //存选中的时间
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] initWithDictionary:_deliveryDatesArray[indexPath.row]];
    [dic2 setObject:@"1" forKey:@"selected"];
    NSInteger i=indexPath.row;
    
    [[[[UserDefaults service] getDeliveryDates] mutableCopy] replaceObjectAtIndex:i withObject:dic2];

    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<[_deliveryDatesArray count]; i++) {
        NSMutableDictionary *dic = [_deliveryDatesArray[i] mutableCopy];
        [dic setObject:@"0" forKey:@"selected"];
        if (dic[@"index"] == [NSNumber numberWithInteger:indexPath.row]) {
            [array addObject:dic2];
        }else {
            [array addObject:dic];
        }
    }

    [[UserDefaults service] updateDeliveryDates:array];
    
//    NSMutableArray *arr = [[UserDefaults service] getDeliveryDates];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"submitOrderReload" object:self];
    [self closeClick];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 50*SCALE;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = UIColorFromRGB(240,240,240);
    
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FOOTER_HEIGHT)];
    [close setTitle:@"取消" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:close];
    
    
    return footer;
}

- (void)closeClick {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeDeliveryDates" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

