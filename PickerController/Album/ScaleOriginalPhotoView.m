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

@implementation ScaleOriginalPhotoView


- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 1;
    }
    return self;
}

- (void)scaleOrigimalPhoto:(UIImageView *)currentImgView {
    
    UIImage * currentImg = currentImgView.image;
    UIWindow * mainWindow = [UIApplication sharedApplication].keyWindow;
    
    oldFrame = [currentImgView convertRect:currentImgView.bounds toView:mainWindow];
    oldImgWidth  = currentImg.size.width;
    oldImgHeight  = currentImg.size.height;
    
    UIImageView * newImgView= [[UIImageView alloc] initWithFrame:oldFrame];
    newImgView.contentMode = UIViewContentModeScaleAspectFill;
    newImgView.clipsToBounds = YES; // ~
    newImgView.userInteractionEnabled = YES;
    newImgView.image = currentImg;
    newImgView.tag = 100;
    [self addSubview:newImgView];
    [mainWindow addSubview:self];
    
    // 添加手势
    //tap
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImg:)];
    [newImgView addGestureRecognizer:tap];
    //pinch
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchOnImg:)];
    [newImgView addGestureRecognizer:pinch];
    
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
        tapRecognize.view.frame = oldFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
// 捏合
- (void)pinchOnImg:(UIPinchGestureRecognizer *)pinchRecognize {
    if (pinchRecognize.state == UIGestureRecognizerStateBegan || pinchRecognize.state == UIGestureRecognizerStateChanged) {
        pinchRecognize.view.transform = CGAffineTransformScale(pinchRecognize.view.transform, pinchRecognize.scale, pinchRecognize.scale);
        NSLog(@"%f",pinchRecognize.scale);
        pinchRecognize.scale = 1;
    }
    if (pinchRecognize.state == UIGestureRecognizerStateEnded) {
        
        if (pinchRecognize.view.frame.size.width < KViewWidth) {
            [UIView animateWithDuration:0.3 animations:^{
                CGFloat newWidth = KViewWidth;
                CGFloat newHeight = newWidth/(oldImgWidth*1.0/oldImgHeight);
                CGFloat yPosition = (KViewHeight-newHeight)/2.0;
                pinchRecognize.view.frame = CGRectMake(0, yPosition, newWidth, newHeight);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
