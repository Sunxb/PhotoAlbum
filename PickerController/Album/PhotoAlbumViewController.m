//
//  PhotoAlbumViewController.m
//  PickerController
//
//  Created by sunxb on 16/8/20.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "PhotoAlbumViewController.h"
#import "PhotoDisplayView.h"
#import "PhotoModel.h"
#import "ShowSelectedViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <POP/POP.h>
#import <MBProgressHUD.h>

#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height

@interface PhotoAlbumViewController ()<PhotoDisplayViewDelegate>
@property (nonatomic,strong) NSMutableDictionary * albumDict;
@property (nonatomic,strong) NSMutableArray * thumbnailArr;

@property (nonatomic,strong) PhotoDisplayView * displayView;

@property (nonatomic,strong) UILabel * tipPhotoNumLbl;
//@property (nonatomic,strong) NSString * photoNum;
@property (nonatomic,assign) NSInteger photoNum;
@property (nonatomic,strong) NSMutableArray * indexArr;
@end

@implementation PhotoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"selectedPhotoNum"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedPhotoSelectedNotification:) name:@"photoIsSelected" object:nil];
    
    _photoNum = 0;
    _albumDict = [NSMutableDictionary new];
    
    [self loadNavBarView];
    [self loadPhotoDisplayView];
    [self getThumbnailImages];
}

- (void)loadNavBarView {
    UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(KWidth-10-40, 15, 40, 20);
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(clickedOnDoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:doneBtn];
    
    if ([self.navigationController.navigationBar viewWithTag:100]) {
        [[self.navigationController.navigationBar viewWithTag:100] removeFromSuperview];
    }
    
    _tipPhotoNumLbl = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-50-25, 15, 20, 20)];
    _tipPhotoNumLbl.hidden = YES;
    _tipPhotoNumLbl.layer.cornerRadius = 10.0f;
    _tipPhotoNumLbl.layer.masksToBounds = YES;
    _tipPhotoNumLbl.font = [UIFont systemFontOfSize:14];
    _tipPhotoNumLbl.textColor = [UIColor whiteColor];
    _tipPhotoNumLbl.textAlignment = NSTextAlignmentCenter;
    _tipPhotoNumLbl.backgroundColor = [UIColor redColor];
    _tipPhotoNumLbl.tag = 100;
    [self.navigationController.navigationBar addSubview:_tipPhotoNumLbl];
}

#pragma mark 接受选择图片的通知
- (void)receivedPhotoSelectedNotification:(NSNotification *)info {
    BOOL isAddPhoto = [[info.userInfo objectForKey:@"photoBeSelected"] boolValue];
    if (isAddPhoto) {
        _photoNum += 1;
    }
    else {
        _photoNum -= 1;
    }
    
    if (_photoNum == 0) {
        _tipPhotoNumLbl.hidden = YES;
    }
    else {
        _tipPhotoNumLbl.hidden = NO;
    }
    _tipPhotoNumLbl.text = [NSString stringWithFormat:@"%ld",_photoNum];
    
    POPSpringAnimation * animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    animation.velocity = [NSValue valueWithCGSize:CGSizeMake(8.0f, 8.0f)];
    animation.springBounciness = 20.0f;
    [_tipPhotoNumLbl.layer pop_addAnimation:animation forKey:@"layerScaleSpringAnimation"];
    
    NSLog(@"---%@",info);
}

#pragma mark 完成
- (void)clickedOnDoneBtn:(UIButton *)btn {
    if (_indexArr.count==0) {
        return;
    }
    
    NSMutableArray * selectedAllPhotoArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < _indexArr.count; i ++) {
        NSInteger index = [_indexArr[i] integerValue];
        [selectedAllPhotoArr addObject:_thumbnailArr[index]];
    }
    
    ShowSelectedViewController * showVC = [[ShowSelectedViewController alloc] init];
    showVC.selectedPhotoArr = selectedAllPhotoArr;
    [self.navigationController pushViewController:showVC animated:YES];
    
    NSLog(@"%@",_indexArr);
}

#pragma mark 加载展示photo的view
- (void)loadPhotoDisplayView {
    _displayView = [[PhotoDisplayView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64)];
    _displayView.delegate = self;
    [_displayView setSelectedPhotoIndexBlock:^(NSArray * selectedIndexArr) {
        _indexArr = [[NSMutableArray alloc] initWithArray:selectedIndexArr];
    }];
    [_displayView loadPhotoAlbumView];
    [self.view addSubview:_displayView];
}

#pragma mark 缩略图
- (void)getThumbnailImages {
//    // 获得所有的自定义相簿
//    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    // 遍历所有的自定义相簿
//    for (PHAssetCollection *assetCollection in assetCollections) {
//        [self enumerateAssetsInAssetCollection:assetCollection original:NO];
//    }
    
    _thumbnailArr = [[NSMutableArray alloc] init];
    // 获得系统相册
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [self enumerateAssetsInAssetCollection:cameraRoll original:NO containerArr:_thumbnailArr];
    _displayView.photoArr = [[NSMutableArray alloc] initWithArray:_thumbnailArr];
    [_displayView loadPhotoAlbumView];
    
}


- (void)getOriginalImages {
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:YES  containerArr:nil];
    }
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 遍历相机胶卷,获取大图
    [self enumerateAssetsInAssetCollection:cameraRoll original:YES containerArr:nil];
}


- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original containerArr:(NSMutableArray *)containerArr {
//    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            PhotoModel * photoMod = [[PhotoModel alloc] init];
            photoMod.displayImg = result;
            photoMod.isSelected = NO;
            [containerArr addObject:photoMod];
        }];
    }
}


#pragma mark 照片已满9张的delegate
- (void)photoDisplayView_photoSelectedEnough {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"最多可选9张照片";
    
    [hud hide:YES afterDelay:2.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _photoNum = 0;
    [_tipPhotoNumLbl removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
