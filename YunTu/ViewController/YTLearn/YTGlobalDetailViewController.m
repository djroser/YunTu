//
//  YTGlobalDetailViewController.m
//  YunTu
//
//  Created by 丁健 on 16/5/5.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import "YTGlobalDetailViewController.h"
#import "YTGlobalDetailItem.h"
#import "AppUtil.h"

@interface YTGlobalDetailViewController ()

@end

@implementation YTGlobalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"国际学分类法";
    self.navigationItem.leftBarButtonItem = [AppUtil leftBarItemWithTarget:self action:@selector(popBack)];
    [self initDefaultData];
}

- (void)initDefaultData
{
    switch (self.globalType) {
        case YTGlobalCJY:
        {
            YTGlobalDetailItem *item1 = [[YTGlobalDetailItem alloc] init];
            item1.sTitle = @"透光层积云";
            item1.sSubTitle = @"云层厚度变化很大，云块之间有明显的缝隙；即使无缝隙，大部分云块边缘也比较明亮。";
            item1.imageTitle = @"global1";
            
            YTGlobalDetailItem *item2 = [[YTGlobalDetailItem alloc] init];
            item2.sTitle = @"蔽光层积云(Sc op)";
            item2.sSubTitle = @"阴暗的大条形云轴或团块组成的连续云层，无缝隙，云层底部有明显的起伏。有时不一定满布全天。";
            item2.imageTitle = @"global2";
            
            YTGlobalDetailItem *item3 = [[YTGlobalDetailItem alloc] init];
            item3.sTitle = @"积云性层积云";
            item3.sSubTitle = @"由积云、积雨云因上面有稳定气层而扩展或云顶下塌平衍而成的层积云。多呈灰色条状，顶部常有积云特征。";
            item3.imageTitle = @"global3";
            
            YTGlobalDetailItem *item4 = [[YTGlobalDetailItem alloc] init];
            item4.sTitle = @"堡状层积云";
            item4.sSubTitle = @"垂直发展的积云形的云块，并列在一线上，有一个共同的底边，顶部凸起明显，远处看去好象城堡。";
            item4.imageTitle = @"global4";
            YTGlobalDetailItem *item5 = [[YTGlobalDetailItem alloc] init];
            item5.sTitle = @"荚状层积云";
            item5.sSubTitle = @"中间厚、边缘薄，形似豆荚、梭子状的云条。个体分明，分离散处。";
            item5.imageTitle = @"global5";
            self.detailArray = [NSArray arrayWithObjects:item1,item2,item3,item4,item5, nil];
        }
            break;
        case YTGlobalJYY:
        {
            YTGlobalDetailItem *item1 = [[YTGlobalDetailItem alloc] init];
            item1.sTitle = @"秃积雨云 Cb calv";
            item1.sSubTitle = @"秃积雨云是浓积云向鬃积雨云发展过渡阶段。云的顶部已开始冰晶化，呈圆弧形重叠，轮廓模糊，已出现少量白色茸毛状云丝，但尚未扩展开来。";
            item1.imageTitle = @"global2-1";
            
            YTGlobalDetailItem *item2 = [[YTGlobalDetailItem alloc] init];
            item2.sTitle = @"鬃积雨云 Cb cap";
            item2.sSubTitle = @"它是积雨云发展的成熟阶段，云顶有白色毛丝般的纤维结构，并已扩展成为马鬃状叫鬃积雨云或成为铁砧状积雨云，云的底部阴暗而混乱。";
            item2.imageTitle = @"global2-2";
            
            self.detailArray = [NSArray arrayWithObjects:item1,item2, nil];
        }
            break;
        case YTGlobalJY:
        {
            YTGlobalDetailItem *item1 = [[YTGlobalDetailItem alloc] init];
            item1.sTitle = @"淡积云 Cu hum";
            item1.sSubTitle = @"积云处在发展初期，云体底部较平，北方淡积云轮廓清晰，个体不大，顶部呈圆弧形凸起，云体水平宽度大于垂直厚度，薄的云块呈白色，厚的云块中部有淡影。南方淡积云由于水汽较多，轮廓不如北方淡积云清晰。淡积云单体分散或成群成群分布在空中，晴天多见。淡积云是由直径5-30微米的小水滴组成，而北方和青藏高原地区冬季的淡积云是由过冷水滴或冰晶组成，有时会降零星雨雪。";
            item1.imageTitle = @"global3-1";
            
            YTGlobalDetailItem *item2 = [[YTGlobalDetailItem alloc] init];
            item2.sTitle = @"碎积云 Fc";
            item2.sSubTitle = @"它是由1-15微米的小水滴组成。云体很小，比较零散分布在天空，形状多变，为白色碎块，多为破碎了或初生的积云。";
            item2.imageTitle = @"global3-2";
            
            YTGlobalDetailItem *item3 = [[YTGlobalDetailItem alloc] init];
            item3.sTitle = @"浓积云 Cu cong";
            item3.sSubTitle = @"浓积云云体高大，轮廓清晰，底部较平，比较阴暗，很像高塔，垂直发展旺盛，垂直厚度超过水平宽度、顶部呈圆弧形重叠，很像花椰菜。\n浓积云是由大小不同尺度的水滴组成，小水滴直径出现在5-50微米之间；大水滴多出现在100-200微米之间。当云发展旺盛时，云中上升气流可达10-20米/秒，当云顶温度在-10℃以下，会出现过冷水滴、冻滴、霰和冰晶。每当浓积云发展非常旺盛时，云的顶部会出现头巾似的一条白云，叫幞状云。\n浓积云是由淡积云发展或合并发展而成，当它发展旺盛阶段时，一般不会出现降水，但也有时降小阵雨。如果清晨有浓积云发展，显示出大气层结不稳定，会出现雷阵雨天气。";
            item3.imageTitle = @"global3-3";

            
            self.detailArray = [NSArray arrayWithObjects:item1,item2,item3, nil];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"yun_detail_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    YTGlobalDetailItem *item = self.detailArray[indexPath.row];
    cell.textLabel.text = item.sTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self pushToDetailVCWithIndexPath:indexPath];
//}

//- (void)pushToDetailVCWithIndexPath:(NSIndexPath *)indexPath
//{
//    YTGlobalDetailViewController *globalDetailVC = [[YTGlobalDetailViewController alloc] initWithNibName:@"YTGlobalDetailViewController" bundle:nil];
//    switch (indexPath.row) {
//        case 0:
//            globalDetailVC.globalType = YTGlobalCJY;
//            break;
//        case 1:
//            globalDetailVC.globalType = YTGlobalJYY;
//            break;
//        case 2:
//            globalDetailVC.globalType = YTGlobalJY;
//            break;
//        default:
//            break;
//    }
//    globalDetailVC.sTitle = self.yunArray[indexPath.row];
//    [self.navigationController pushViewController:globalDetailVC animated:YES];
//}


- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
