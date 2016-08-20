//
//  PhotoDisplayCell.m
//  PickerController
//
//  Created by sunxb on 16/8/20.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "PhotoDisplayCell.h"
#import <POP/POP.h>

@implementation PhotoDisplayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.photoImg.contentMode = UIViewContentModeScaleAspectFill;
    self.checkImg.image = [UIImage imageNamed:@"button-unchecked@2x"];
    self.checkImg.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapCheckImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnCheckImg:)];
    [self.checkImg addGestureRecognizer:tapCheckImg];
    self.isSelected = NO;
}

- (void)setModel:(PhotoModel *)model {
    _model = model;
    self.isSelected = model.isSelected;
    self.photoImg.image = model.displayImg;
    self.checkImg.image = [UIImage imageNamed:model.isSelected?@"button-checked@2x":@"button-unchecked@2x"];
}

#pragma mark checkImg的手势
- (void)tapOnCheckImg:(UITapGestureRecognizer *)recognize {
    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedPhotoNum"];
    if (self.isSelected) {
        self.checkImg.image = [UIImage imageNamed:@"button-unchecked@2x"];
        [[NSUserDefaults standardUserDefaults] setInteger:(num-1) forKey:@"selectedPhotoNum"];
    }
    else {
        if (num<=8) {
            self.checkImg.image = [UIImage imageNamed:@"button-checked@2x"];
            POPSpringAnimation * animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            animation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
            animation.velocity = [NSValue valueWithCGSize:CGSizeMake(10.0f, 10.0f)];
            animation.springBounciness = 20.0f;
            [self.checkImg.layer pop_addAnimation:animation forKey:@"layerScaleSpringAnimation"];
            [[NSUserDefaults standardUserDefaults] setInteger:(num+1) forKey:@"selectedPhotoNum"];
        }
        else {
            self.photoNumIsEnoughBlock();
            return;
        }
        
    }
    
    self.isSelected = !self.isSelected;
    self.model.isSelected = !self.model.isSelected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoIsSelected" object:nil userInfo:@{@"photoBeSelected":@(self.model.isSelected)}];
    
    
    
}

@end
