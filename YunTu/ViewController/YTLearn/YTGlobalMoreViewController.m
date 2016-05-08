//
//  YTGlobalMoreViewController.m
//  YunTu
//
//  Created by 丁健 on 16/5/8.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import "YTGlobalMoreViewController.h"
#import "AppUtil.h"
#import "YTGlobal.h"
#import "UIImage+Resize.h"
@interface YTGlobalMoreViewController ()

@end

@implementation YTGlobalMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.navigationItem.leftBarButtonItem = [AppUtil leftBarItemWithTarget:self action:@selector(popBack)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    _lblTitle.text = self.globalItem.sTitle;
    _lblDetailTitle.text = self.globalItem.sSubTitle;
    UIImage *img = [self autoResizeImage:[UIImage imageNamed:self.globalItem.imageTitle]];
    _imgvMore.image = img;
}

//自动适应图片大小
- (UIImage *)autoResizeImage:(UIImage *)nativeImage
{
    if (nativeImage.size.width > ScreenWidth - 20) {
        CGFloat imageWidth = self.view.frame.size.width - 20;
        CGFloat imageHeight = nativeImage.size.height * (imageWidth / nativeImage.size.width);
        nativeImage = [nativeImage resizeToSize:CGSizeMake(imageWidth, imageHeight)];
    }
    return nativeImage;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return _cellTitle;
            break;
        case 1:
            return _cellImage;
            break;
        case 2:
            return _cellDetailTitle;
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 30;
            break;
        case 1:
        {
            UIImage *img = [self autoResizeImage:[UIImage imageNamed:self.globalItem.imageTitle]];
            return img.size.height;
        }
            break;
        case 2:
        {
            return 16 + [AppUtil contentHeightWithText:self.globalItem.sSubTitle constraintWidth:ScreenWidth-30 fontSize:14];
        }
            break;
        default:
            return 0.01;
            break;
    }
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
