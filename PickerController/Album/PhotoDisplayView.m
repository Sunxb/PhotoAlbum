//
//  PhotoDisplayView.m
//  PickerController
//
//  Created by sunxb on 16/8/20.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "PhotoDisplayView.h"
#import "PhotoDisplayCell.h"

static NSString * cellID = @"photoAlbumCell";

@interface PhotoDisplayView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView * rootCollectionView;
@property (nonatomic,strong) NSMutableArray * selectedIndexArr;

@end

@implementation PhotoDisplayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _selectedIndexArr = [[NSMutableArray alloc] init];
        [self loadPhotoCollectionView];
    }
    return self;
}

- (void)loadPhotoAlbumView {
    [_rootCollectionView reloadData];
}

#pragma mark 创建展示照片的collectionView
- (void)loadPhotoCollectionView {
    /*layout*/
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((self.frame.size.width-10)/3.0, (self.frame.size.width-10)/3.0);
    layout.minimumInteritemSpacing = 5.0;
    layout.minimumLineSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _rootCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _rootCollectionView.backgroundColor = [UIColor whiteColor];
    _rootCollectionView.delegate = self;
    _rootCollectionView.dataSource = self;
    [_rootCollectionView registerNib:[UINib nibWithNibName:@"PhotoDisplayCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    [self addSubview:_rootCollectionView];
}

#pragma mark collectionView delegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoDisplayCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell setPhotoNumIsEnoughBlock:^{
        if ([self.delegate respondsToSelector:@selector(photoDisplayView_photoSelectedEnough)]) {
            [self.delegate photoDisplayView_photoSelectedEnough];
        }
        NSLog(@"只能选9张");
    }];
    [cell setPhotoSelectedBlock:^(BOOL isSelected, NSInteger selectedIndex) {
        if (isSelected) {
            if (![_selectedIndexArr containsObject:@(selectedIndex)]) {
                [_selectedIndexArr addObject:@(selectedIndex)];
            }
            
        }
        else {
            [_selectedIndexArr removeObject:@(selectedIndex)];
        }
        self.selectedPhotoIndexBlock(_selectedIndexArr);
    }];
    cell.backgroundColor = [UIColor greenColor];
    cell.model = self.photoArr[indexPath.row];
    cell.model.photoIndex = indexPath.row;
    return cell;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
