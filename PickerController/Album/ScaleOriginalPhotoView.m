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
    tap.numberOfTapsRequired = 1;
    [newImgView addGestureRecognizer:tap];
    
    //双击
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: tap2];
    [newImgView addGestureRecognizer:tap2];
    
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

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_rootScrollView.zoomScale > 1) {
        [_rootScrollView setZoomScale:1 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:tap.view];
        CGFloat newZoomScale = _rootScrollView.maximumZoomScale;
        CGFloat xsize = KViewWidth / newZoomScale;
        CGFloat ysize = KViewHeight / newZoomScale;
        [_rootScrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
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




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
