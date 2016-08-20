//
//  PhotoDisplayView.h
//  PickerController
//
//  Created by sunxb on 16/8/20.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDisplayView : UIView

/*展示的照片*/
@property (nonatomic,strong) NSMutableArray * photoArr;

- (void)loadPhotoAlbumView;

@end
