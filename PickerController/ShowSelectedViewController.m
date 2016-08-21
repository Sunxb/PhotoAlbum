//
//  ShowSelectedViewController.m
//  PickerController
//
//  Created by sunxb on 16/8/21.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "ShowSelectedViewController.h"
#import "PhotoModel.h"

@interface ShowSelectedViewController ()

@end

@implementation ShowSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat imgWidth = (self.view.frame.size.width-40)/3.0;
    
    for (int i = 0; i < self.selectedPhotoArr.count; i ++) {
        PhotoModel * model = self.selectedPhotoArr[i];
        NSInteger col = i % 3;
        NSInteger row = i / 3;
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10+(imgWidth+10)*col, 80+(imgWidth+10)*row, imgWidth, imgWidth)];
        imgView.image = model.displayImg;
        [self.view addSubview:imgView];
        
    }
    
    // Do any additional setup after loading the view.
}

- (void)setSelectedPhotoArr:(NSArray *)selectedPhotoArr {
    _selectedPhotoArr = selectedPhotoArr;
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
