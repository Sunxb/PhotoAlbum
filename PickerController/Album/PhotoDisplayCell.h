//
//  PhotoDisplayCell.h
//  PickerController
//
//  Created by sunxb on 16/8/20.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

@interface PhotoDisplayCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImg;
@property (weak, nonatomic) IBOutlet UIImageView *checkImg;
@property (nonatomic,assign) BOOL isSelected;

@property (nonatomic,strong) PhotoModel * model;

@property (nonatomic,copy) void(^photoNumIsEnoughBlock)();

@end
