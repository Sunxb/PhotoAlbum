//
//  PhotoDisplayView.h
//  PickerController
//
//  Created by sunxb on 16/8/20.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoDisplayViewDelegate <NSObject>
- (void)photoDisplayView_photoSelectedEnough;
@end

@interface PhotoDisplayView : UIView

/*展示的照片*/
@property (nonatomic,strong) NSMutableArray * photoArr;
@property (nonatomic,strong) void(^selectedPhotoIndexBlock)(NSArray * indexArr);
@property (nonatomic,weak) id <PhotoDisplayViewDelegate> delegate;
- (void)loadPhotoAlbumView;
@end
