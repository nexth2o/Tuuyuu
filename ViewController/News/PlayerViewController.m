//
//  PlayerViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/6.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface PlayerViewController ()<AVPlayerViewControllerDelegate> {
    AVAudioSession *session;
}

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerViewController  *playerController;

@end

@implementation PlayerViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor whiteColor];

        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
//        NSString *playString = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
        NSString *playString = @"https://movie.japan-i.net/test/CM.mp4";
        
        //视频播放的url
        NSURL *playerURL = [NSURL URLWithString:playString];
        
        session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:playerURL];
        
        _player = [AVPlayer playerWithPlayerItem:item];
        _playerController = [[AVPlayerViewController alloc] init];
        _playerController.player = _player;
        _playerController.videoGravity = AVLayerVideoGravityResizeAspect;
        _playerController.delegate = self;
        _playerController.allowsPictureInPicturePlayback = true;    //画中画，iPad可用
        _playerController.showsPlaybackControls = true;
        
        [self addChildViewController:_playerController];
        _playerController.view.translatesAutoresizingMaskIntoConstraints = true;    //AVPlayerViewController 内部可能是用约束写的，这句可以禁用自动约束，消除报错
        _playerController.view.frame = self.view.bounds;
        [self.view addSubview:_playerController.view];
        
        [_playerController.player play];    //自动播放
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
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self showViewController:playerView sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

@end
