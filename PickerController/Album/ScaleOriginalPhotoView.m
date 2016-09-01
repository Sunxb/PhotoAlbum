//
//  ScaleOriginalPhotoView.m
//  PickerController
//
//  Created by sunxb on 16/8/27.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "ScaleOriginalPhotoView.h"

#define KViewWidth  [UIScreen mainScreen].bounds.size.width
#define KViewHeight [UIScreen mainScreen].bounds.size.height

static CGRect oldFrame;
CGFloat oldImgWidth;
CGFloat oldImgHeight;

@interface ScaleOriginalPhotoView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView * rootScrollView;
@property (nonatomic,assign) CGFloat lastScale;
@end

@implementation ScaleOriginalPhotoView
- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 1;
    }
    return self;
}

- (void)scaleOrigimalPhoto:(UIImageView *)currentImgView showOriginalImg:(UIImage *)showImg {
    
    UIImage * currentImg = currentImgView.image;
    UIWindow * mainWindow = [UIApplication sharedApplication].keyWindow;

    oldFrame = [currentImgView convertRect:currentImgView.bounds toView:mainWindow];
    oldImgWidth  = currentImg.size.width;
    oldImgHeight  = currentImg.size.height;
    
    _rootScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    NSLog(@"%f~~~~%f",oldImgWidth,oldImgHeight);
    _rootScrollView.contentSize = CGSizeMake(oldImgWidth, oldImgHeight);
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.delegate = self;
    _rootScrollView.minimumZoomScale = 1.0f;
    _rootScrollView.maximumZoomScale = 2.0f;
    [_rootScrollView setZoomScale:0.5 animated:YES];
    [self addSubview:_rootScrollView];
    
    UIImageView * newImgView= [[UIImageView alloc] initWithFrame:oldFrame];
    newImgView.contentMode = UIViewContentModeScaleAspectFill;
    newImgView.clipsToBounds = YES; // ~
    newImgView.userInteractionEnabled = YES;
    newImgView.image = showImg;
    newImgView.tag = 100;
    [_rootScrollView addSubview:newImgView];
    [mainWindow addSubview:self];
    
    // 添加手势
    //tap
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImg:)];
    [newImgView addGestureRecognizer:tap];
    
    // 变大
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat newWidth = KViewWidth;
        CGFloat newHeight = newWidth/(oldImgWidth*1.0/oldImgHeight);
        CGFloat yPosition = (KViewHeight-newHeight)/2.0;
        newImgView.frame = CGRectMake(0, yPosition, newWidth, newHeight);
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark 手势
// 点按
- (void)tapOnImg:(UITapGestureRecognizer *)tapRecognize {
    self.backgroundColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0];
    [UIView animateWithDuration:0.4 animations:^{
        _rootScrollView.contentOffset = CGPointMake(0, 0);
        tapRecognize.view.frame = oldFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
// 捏合
- (void)pinchOnImg:(UIPinchGestureRecognizer *)pinchRecognize {
////    UIImageView * pinchIV = (UIImageView *)pinchRecognize.view;
//    if (pinchRecognize.state == UIGestureRecognizerStateBegan || pinchRecognize.state == UIGestureRecognizerStateChanged) {
////        pinchRecognize.view.transform = CGAffineTransformScale(pinchRecognize.view.transform, pinchRecognize.scale, pinchRecognize.scale);
////        pinchRecognize.view.frame = CGRectMake(0, 0, pinchRecognize.view.frame.size.width*pinchRecognize.scale, pinchRecognize.view.frame.size.height*pinchRecognize.scale);
//        
//        if (pinchRecognize.view.frame.size.width*pinchRecognize.scale>KViewWidth && pinchRecognize.view.frame.size.height*pinchRecognize.scale<KViewHeight) {
//            _rootScrollView.contentOffset = CGPointMake(pinchRecognize.view.frame.size.width*(pinchRecognize.scale-1)/2.0, 0);
//            pinchRecognize.view.frame = CGRectMake(0, (KViewHeight-pinchRecognize.view.frame.size.height*pinchRecognize.scale)/2.0, pinchRecognize.view.frame.size.width*pinchRecognize.scale, pinchRecognize.view.frame.size.height*pinchRecognize.scale);
//        }
//        if (pinchRecognize.view.frame.size.width*pinchRecognize.scale>KViewWidth && pinchRecognize.view.frame.size.height*pinchRecognize.scale>KViewHeight) {
//            _rootScrollView.contentOffset = CGPointMake(pinchRecognize.view.frame.size.width*(pinchRecognize.scale-1)/2.0, pinchRecognize.view.frame.size.height*(pinchRecognize.scale-1)/2.0);
//            pinchRecognize.view.frame = CGRectMake(0, 0, pinchRecognize.view.frame.size.width*pinchRecognize.scale, pinchRecognize.view.frame.size.height*pinchRecognize.scale);
//        }
//        if (pinchRecognize.view.frame.size.width*pinchRecognize.scale<KViewWidth && pinchRecognize.view.frame.size.height*pinchRecognize.scale<KViewHeight) {
//            _rootScrollView.contentOffset = CGPointMake(0, 0);
//            pinchRecognize.view.frame = CGRectMake((KViewWidth-pinchRecognize.view.frame.size.width*pinchRecognize.scale)/2.0, (KViewHeight-pinchRecognize.view.frame.size.height*pinchRecognize.scale)/2.0, pinchRecognize.view.frame.size.width*pinchRecognize.scale, pinchRecognize.view.frame.size.height*pinchRecognize.scale);
//        }
//
////        pinchRecognize.view.center = _rootScrollView.center;
//        NSLog(@"%f",pinchRecognize.scale);
//        NSLog(@"%f ====== %f",pinchRecognize.view.frame.origin.x,pinchRecognize.view.frame.origin.y);
//        pinchRecognize.scale = 1;
//    }
    
//    if (pinchRecognize.state == UIGestureRecognizerStateEnded) {
//        // 最小不能比原图小
//        if (pinchRecognize.view.frame.size.width < KViewWidth) {
//            [UIView animateWithDuration:0.3 animations:^{
//                CGFloat newWidth = KViewWidth;
//                CGFloat newHeight = newWidth/(oldImgWidth*1.0/oldImgHeight);
//                CGFloat yPosition = (KViewHeight-newHeight)/2.0;
//                pinchRecognize.view.frame = CGRectMake(0, yPosition, newWidth, newHeight);
//            } completion:^(BOOL finished) {
//                _rootScrollView.contentOffset = CGPointMake(0, 0);
//                _rootScrollView.contentSize = CGSizeMake(pinchRecognize.view.frame.size.width, pinchRecognize.view.frame.size.height);
//            }];
//        }
//        // 最多放大1.8
//        if (pinchRecognize.view.frame.size.width > KViewWidth*1.8) {
//            [UIView animateWithDuration:0.3 animations:^{
//                CGFloat newWidth = KViewWidth*1.8;
//                CGFloat newHeight = newWidth/(oldImgWidth*1.0/oldImgHeight);
//                CGFloat yPosition = (KViewHeight-newHeight)/2.0;
//                _rootScrollView.contentOffset = CGPointMake((KViewWidth*0.9/2), newHeight>KViewHeight?(KViewHeight*0.9/2):0);
//                pinchRecognize.view.frame = CGRectMake(0, newHeight>KViewHeight?0:yPosition, newWidth, newHeight);
//            } completion:^(BOOL finished) {
//                _rootScrollView.contentSize = CGSizeMake(pinchRecognize.view.frame.size.width, pinchRecognize.view.frame.size.height);
//            }];
//        }
//    }

//    _rootScrollView.contentSize = CGSizeMake(pinchRecognize.view.frame.size.width, pinchRecognize.view.frame.size.height);
    
    
    
    
    
}




#pragma mark scrollView的delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:100];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = [scrollView viewWithTag:100];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}




//- scrollview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
