//
//  ViewController.m
//  PickerController
//
//  Created by sunxb on 16/8/20.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "ViewController.h"
#import "PhotoAlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.frame = CGRectMake(10, 10, 100, 50);
    openBtn.backgroundColor = [UIColor grayColor];
    [openBtn setTitle:@"打开相册" forState:UIControlStateNormal];
    openBtn.center = self.view.center;
    [openBtn addTarget:self action:@selector(cilickedOnOpenAlbumBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openBtn];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)cilickedOnOpenAlbumBtn:(UIButton *)btn {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        // 拒绝 --
        NSLog(@"%@",@"拒绝");
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相册\n设置>隐私>照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        return ;
    }
    else {
        PhotoAlbumViewController * photoAlbunVC = [[PhotoAlbumViewController alloc] init];
        [self.navigationController pushViewController:photoAlbunVC animated:YES];
    }

//    PhotoAlbumViewController * photoAlbunVC = [[PhotoAlbumViewController alloc] init];
//    [self.navigationController pushViewController:photoAlbunVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
