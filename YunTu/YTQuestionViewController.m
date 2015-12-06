//
//  YTQuestionViewController.m
//  YunTu
//
//  Created by 丁健 on 15/11/1.
//  Copyright © 2015年 丁健. All rights reserved.
//

#import "YTQuestionViewController.h"
#import "YTDataBaseManager.h"
#import "YTQuestionItem.h"
#import "QuestionCell.h"
#import "YTButton.h"
#import "AppUtil.h"
#import "UIImage+Resize.h"
@interface YTQuestionViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign,nonatomic) NSUInteger collectionViewRowNum;
@property (strong, nonatomic) NSArray *questionList;
@property (weak, nonatomic) YTButton *pageButton;
@property (weak, nonatomic) UIBarButtonItem *pageItem;
@end
static NSString *titleImageID = @"title_image_cell";
static NSString *optionID = @"option_cell";
@implementation YTQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.questionList = [[YTDataBaseManager sharedInstance] questionsList];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width, self.collectionView.frame.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.collectionViewLayout = layout;
    
    YTButton *pageBtn = [[YTButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    NSString *pageStr = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)_collectionViewRowNum + 1,(unsigned long)_questionList.count];
    [pageBtn setTitle:pageStr forState:UIControlStateNormal];
    pageBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [pageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pageBtn setImage:[UIImage imageNamed:@"卞卞.JPG"] forState:UIControlStateNormal];
    UIBarButtonItem *pageItem = [[UIBarButtonItem alloc]initWithCustomView:pageBtn];
    self.navigationItem.rightBarButtonItem = pageItem;
    self.pageButton = pageBtn;
    self.pageItem = pageItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (YTQuestionItem *questionItem in _questionList) {
        questionItem.isAnswered = NO;
        questionItem.isOption1Selected = NO;
        questionItem.isOption2Selected = NO;
        questionItem.isOption3Selected = NO;
        questionItem.isOption4Selected = NO;
        questionItem.isShowAnswerExplain = NO;
    }

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.questionList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"collect_cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    UITableView *tableView = (UITableView *)[cell viewWithTag:1];
    _collectionViewRowNum = indexPath.row;
    [tableView reloadData];
    return cell;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    YTQuestionItem *questionItem = self.questionList[_collectionViewRowNum];
    return questionItem.isShowAnswerExplain == YES ? 3 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YTQuestionItem *questionItem = self.questionList[_collectionViewRowNum];
    if (section == 0) {
        return (questionItem.imageStr == NULL ? 1 : 2);
    } else if (section == 1){
        return (questionItem.type == 0 ? 4 : 2);
    } else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return [self tableView:tableView questionCellAtIndexPath:indexPath];
}

    
- (UITableViewCell *)tableView:(UITableView *)tableView questionCellAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YTQuestionItem *questionItem = self.questionList[_collectionViewRowNum];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:optionID forIndexPath:indexPath];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
            titleLabel.text = questionItem.question;
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:titleImageID forIndexPath:indexPath];
                UIImageView *questionView = (UIImageView *)[cell viewWithTag:1];
                questionView.hidden = questionItem.imageStr == NULL ? YES : NO;
                if (!questionView.hidden) {
                    UIImage *normalImage = [UIImage imageNamed:questionItem.imageStr];
                    if (normalImage.size.width > self.collectionView.frame.size.width - 16) {
                        CGFloat imageWidth = self.collectionView.frame.size.width - 16;
                        CGFloat imageHeight = normalImage.size.height * (imageWidth / normalImage.size.width);
                        normalImage = [normalImage resizeToSize:CGSizeMake(imageWidth, imageHeight)];
                    }
                    questionView.image = normalImage;
                }
            }
        } else if (indexPath.section == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:optionID forIndexPath:indexPath];
            UILabel *optionLabel = (UILabel *)[cell viewWithTag:1];
            switch (indexPath.row) {
                case 0:
                    optionLabel.text = questionItem.option1;
                    if (questionItem.isOption1Selected) {
                        optionLabel.textColor = [self judgeQuestionAnsweredWithQuestionItem:questionItem option:1] == YES ? [UIColor blueColor] : [UIColor redColor];
                    } else {
                        optionLabel.textColor = [UIColor blackColor];
                    }
                    break;
                case 1:
                    optionLabel.text = questionItem.option2;
                    if (questionItem.isOption2Selected) {
                        optionLabel.textColor = [self judgeQuestionAnsweredWithQuestionItem:questionItem option:2] == YES ? [UIColor blueColor] : [UIColor redColor];
                    } else {
                        optionLabel.textColor = [UIColor blackColor];
                    }
                    break;
                case 2:
                    optionLabel.text = questionItem.option3;
                    if (questionItem.isOption3Selected) {
                        optionLabel.textColor = [self judgeQuestionAnsweredWithQuestionItem:questionItem option:3] == YES ? [UIColor blueColor] : [UIColor redColor];
                    } else {
                        optionLabel.textColor = [UIColor blackColor];
                    }
                    break;
                default:
                    optionLabel.text = questionItem.option4;
                    if (questionItem.isOption4Selected) {
                        optionLabel.textColor = [self judgeQuestionAnsweredWithQuestionItem:questionItem option:4] == YES ? [UIColor blueColor] : [UIColor redColor];
                    } else {
                        optionLabel.textColor = [UIColor blackColor];
                    }
                    break;
            }
            
        } else {
        cell = [tableView dequeueReusableCellWithIdentifier:optionID forIndexPath:indexPath];
        UILabel *optionLabel = (UILabel *)[cell viewWithTag:1];
        optionLabel.text = questionItem.answer_explain;
    }
    return cell;

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    CGFloat height;
    YTQuestionItem *questionItem = self.questionList[_collectionViewRowNum];
    NSString *titleLabel;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            titleLabel = questionItem.question;
            height = [AppUtil contentHeightWithText:titleLabel constraintWidth:self.collectionView.frame.size.width - 16 fontSize:17] + 16;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:titleImageID];
            UIImageView *questionView = (UIImageView *)[cell viewWithTag:1];
            questionView.hidden = questionItem.imageStr == NULL ? YES : NO;
            if (!questionView.hidden) {
                UIImage *normalImage = [UIImage imageNamed:questionItem.imageStr];
                if (normalImage.size.width > self.collectionView.frame.size.width - 16) {
                    CGFloat imageWidth = self.collectionView.frame.size.width - 16;
                    CGFloat imageHeight = normalImage.size.height * (imageWidth / normalImage.size.width);
                    normalImage = [normalImage resizeToSize:CGSizeMake(imageWidth, imageHeight)];
                }
                questionView.image = normalImage;
            }
            height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
          }
        } else if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0:
                    titleLabel = questionItem.option1;
                    break;
                case 1:
                    titleLabel = questionItem.option2;
                    break;
                case 2:
                    titleLabel = questionItem.option3;
                    break;
                default:
                    titleLabel = questionItem.option4;
                    break;
            }
            height = [AppUtil contentHeightWithText:titleLabel constraintWidth:self.collectionView.frame.size.width - 16 fontSize:17] + 16;
        } else {
        titleLabel = questionItem.answer_explain;
        height = [AppUtil contentHeightWithText:titleLabel constraintWidth:self.collectionView.frame.size.width- 16 fontSize:17] + 16;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTQuestionItem *questionItem = _questionList[_collectionViewRowNum];
    if (indexPath.section == 1 && !questionItem.isAnswered) {
        switch (indexPath.row) {
            case 0:
            {
                questionItem.isOption1Selected = YES;
                if ([questionItem.option1 isEqualToString:questionItem.answer]) {
                    [tableView reloadData];
                    [self performSelector:@selector(scrollToNextQuestion) withObject:nil afterDelay:0.7];
                    
                } else {
                    questionItem.isShowAnswerExplain = YES;
                    [tableView reloadData];
                }
            }
                break;
            case 1:
            {
                questionItem.isOption2Selected = YES;
                if ([questionItem.option2 isEqualToString:questionItem.answer]) {
                    [tableView reloadData];
                    [self performSelector:@selector(scrollToNextQuestion) withObject:nil afterDelay:0.7];
                } else {
                    questionItem.isShowAnswerExplain = YES;
                    [tableView reloadData];
                }

            }
                break;
            case 2:
            {
                questionItem.isOption3Selected = YES;
                if ([questionItem.option3 isEqualToString:questionItem.answer]) {
                    [tableView reloadData];
                    [self performSelector:@selector(scrollToNextQuestion) withObject:nil afterDelay:0.7];

                } else {
                    questionItem.isShowAnswerExplain = YES;
                    [tableView reloadData];
                }
            }
                break;
            case 3:
            {
                questionItem.isOption4Selected = YES;
                if ([questionItem.option4 isEqualToString:questionItem.answer]) {
                    [tableView reloadData];
                    [self performSelector:@selector(scrollToNextQuestion) withObject:nil afterDelay:0.7];

                } else {
                    questionItem.isShowAnswerExplain = YES;
                    [tableView reloadData];
                }
            }
                break;
            default:
                break;
        }
        questionItem.isAnswered = YES;
    }
}

- (void)scrollToNextQuestion
{
    CGPoint centerPoint = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *currIndexPath = [self.collectionView indexPathForItemAtPoint:centerPoint];
    if (currIndexPath.row >= _questionList.count - 1) {
        return;
    }
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:currIndexPath.row + 1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (BOOL)judgeQuestionAnsweredWithQuestionItem:(YTQuestionItem *)questionItem option:(NSUInteger)option
{
    NSString *strOption;
    switch (option) {
        case 1:
            strOption = questionItem.option1;
            break;
        case 2:
            strOption = questionItem.option2;
            break;
        case 3:
            strOption = questionItem.option3;
            break;
        default:
            strOption = questionItem.option4;
            break;
    }
    if ([questionItem.answer isEqualToString:strOption]) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint centerPoint = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:centerPoint];
    [self.pageButton setTitle:[NSString stringWithFormat:@"%lu/%lu",(unsigned long)indexPath.row + 1,(unsigned long)_questionList.count] forState:UIControlStateNormal];
    _collectionViewRowNum = indexPath.row;
}








@end
