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
#import "YTGlobal.h"
#import "UIViewController+NavUtils.h"
#import "answeredCollectionCell.h"

#define titleWidthDiffer        43
#define titleImageWidthDiffer   16
#define optionWidthDiffer       60
#define explainWidthDiffer      40
#define MainCollectionViewTag   222
#define AnsweredCollectionViewTag 333

@interface YTQuestionViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    BOOL bShowBottomView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIControl *maskView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UICollectionView *answeredCollectionView;//答题情况表
@property (assign,nonatomic) NSUInteger collectionViewRowNum;
@property (strong, nonatomic) NSArray *questionList;
@property (weak, nonatomic) YTButton *pageButton;
@property (weak, nonatomic) UIBarButtonItem *pageItem;
@end

static NSString *titleID = @"question_title_cell";
static NSString *titleImageID = @"title_image_cell";
static NSString *optionID = @"option_cell";
static NSString *explainID = @"question_explain_cell";

static NSString *answerCollectionCellID = @"answer_collection_cell";

@implementation YTQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDefaultData];
    [self createBaseView];
    
}

- (void)createBaseView
{
    //主集合视图
    [self createMainCollectionView];
    //答题情况表
    [self createBottomAnswerView];
    
    //导航栏视图
    //页数按钮
    YTButton *pageBtn = [[YTButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    NSString *pageStr = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)_collectionViewRowNum + 1,(unsigned long)_questionList.count];
    [pageBtn setTitle:pageStr forState:UIControlStateNormal];
    pageBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [pageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pageBtn setImage:[UIImage imageNamed:@"test_top_card"] forState:UIControlStateNormal];
    [pageBtn addTarget:self action:@selector(didPressPageItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *pageItem = [[UIBarButtonItem alloc]initWithCustomView:pageBtn];
    
    
    //收藏按钮
    YTButton *storeBtn = [[YTButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [storeBtn setTitle:@"收藏" forState:UIControlStateNormal];
    storeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [storeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [storeBtn setImage:[UIImage imageNamed:@"test_top_shoucnag_n"] forState:UIControlStateNormal];
    UIBarButtonItem *storeItem = [[UIBarButtonItem alloc]initWithCustomView:storeBtn];

    self.navigationItem.rightBarButtonItems = @[pageItem,storeItem];
    self.pageButton = pageBtn;
    self.pageItem = pageItem;
    
    self.tabBarItem.image = [[UIImage imageNamed:@"canvas1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
}

//初始化主集合视图
- (void)createMainCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 64);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.tag = MainCollectionViewTag;
}


//初始化答题情况表
- (void)createBottomAnswerView
{
    
    self.maskView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.0;
    self.maskView.hidden = YES;
    [self.maskView addTarget:self action:@selector(didPressedMaskView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.maskView];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3*2)];
    self.bottomView.backgroundColor = [UIColor yellowColor];
    
    //答题情况集合视图
    UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc]init];
    layout2.itemSize = CGSizeMake(30, 30);
    layout2.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout2.minimumInteritemSpacing = 10;
    layout2.minimumLineSpacing = 10;
    layout2.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.answeredCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.bottomView.frame.size.height) collectionViewLayout:layout2];
    [self.answeredCollectionView registerNib:[UINib nibWithNibName:@"answeredCollectionCell" bundle:nil] forCellWithReuseIdentifier:answerCollectionCellID];
    self.answeredCollectionView.tag = AnsweredCollectionViewTag;
    self.answeredCollectionView.delegate = self;
    self.answeredCollectionView.dataSource = self;
    self.answeredCollectionView.backgroundColor = [UIColor whiteColor];
    [_bottomView addSubview:self.answeredCollectionView];
    [self.view addSubview:_bottomView];
}


- (void)initDefaultData
{
    self.questionList = [[YTDataBaseManager sharedInstance] questionsList];
    self.title = @"模拟考试";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (YTQuestionItem *questionItem in _questionList) {
        questionItem.isAnswered = NO;
        questionItem.isAnsweredRight = NO;
        questionItem.isOption1Selected = NO;
        questionItem.isOption2Selected = NO;
        questionItem.isOption3Selected = NO;
        questionItem.isOption4Selected = NO;
        questionItem.isShowAnswerExplain = NO;
    }
    self.navigationItem.leftBarButtonItem = [AppUtil leftBarItemWithTarget:self action:@selector(popBack)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (UIBarButtonItem *)createRightBarButtonWithImage:(NSString *)image title:(NSString *)title
{
    YTButton *btn = [[YTButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    UIBarButtonItem *Item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return Item;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.questionList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == MainCollectionViewTag) {//主集合视图
        static NSString *ID = @"collect_cell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        UITableView *tableView = (UITableView *)[cell viewWithTag:1];
        _collectionViewRowNum = indexPath.row;
        [tableView reloadData];
        return cell;
    } else {
        //答题情况集合视图
        answeredCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:answerCollectionCellID forIndexPath:indexPath];
        cell.questionItem = self.questionList[indexPath.row];
        return cell;
    }
    
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
            cell = [tableView dequeueReusableCellWithIdentifier:titleID forIndexPath:indexPath];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];//标题
            UIImageView *typeView = (UIImageView *)[cell viewWithTag:2];//题目类型图标
            titleLabel.text = questionItem.question;
            typeView.image = [self imageWithQuestionType:questionItem.type];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:titleImageID forIndexPath:indexPath];
                UIImageView *questionView = (UIImageView *)[cell viewWithTag:1];
                questionView.hidden = questionItem.imageStr == NULL ? YES : NO;
                if (!questionView.hidden) {
                    UIImage *normalImage = [UIImage imageNamed:questionItem.imageStr];
                    if (normalImage.size.width > self.collectionView.frame.size.width - titleImageWidthDiffer) {
                        CGFloat imageWidth = self.collectionView.frame.size.width - titleImageWidthDiffer;
                        CGFloat imageHeight = normalImage.size.height * (imageWidth / normalImage.size.width);
                        normalImage = [normalImage resizeToSize:CGSizeMake(imageWidth, imageHeight)];
                    }
                    questionView.image = normalImage;
                }
            }
        } else if (indexPath.section == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:optionID forIndexPath:indexPath];
            UILabel *optionLabel = (UILabel *)[cell viewWithTag:1];
            UIButton *optionBtn = (UIButton *)[cell viewWithTag:2];
            switch (indexPath.row) {
                case 0:
                {
                    optionLabel.text = questionItem.option1;
                    if (questionItem.isOption1Selected) {
                        //选项被选择
                        optionLabel.textColor = [self judgeQuestionAnsweredWithQuestionItem:questionItem option:1] == YES ? def_text_trueAnswer : def_text_falseAnswer;
                        [optionBtn setBackgroundImage:[self judgeQuestionAnsweredWithQuestionItem:questionItem option:1] == YES ? [UIImage imageNamed:@"yuntu_practise_true"] : [UIImage imageNamed:@"yuntu_practise_false"] forState:UIControlStateNormal];
                        [optionBtn setTitle:@"" forState:UIControlStateNormal];
                        
                    } else {
                        if ([self judgeQuestionAnsweredWithQuestionItem:questionItem option:1] == YES && questionItem.isAnswered) {
                            //答错则要显示正确答案及icon变化
                            optionLabel.textColor = def_text_trueAnswer;
                            [optionBtn setBackgroundImage:[UIImage imageNamed:@"yuntu_practise_true"] forState:UIControlStateNormal];
                            [optionBtn setTitle:@"" forState:UIControlStateNormal];
                        } else {
                            //未答则正常显示
                            optionLabel.textColor = [UIColor blackColor];
                            [optionBtn setBackgroundImage:[UIImage imageNamed:@"yuntu_practise_bg_n"] forState:UIControlStateNormal];
                            [optionBtn setTitle:@"A" forState:UIControlStateNormal];
                        }
                    }
                }
                    break;
                case 1:
                {
                    optionLabel.text = questionItem.option2;
                    if (questionItem.isOption2Selected) {
                        optionLabel.textColor = [self judgeQuestionAnsweredWithQuestionItem:questionItem option:2] == YES ? def_text_trueAnswer : def_text_falseAnswer;
                        [optionBtn setBackgroundImage:[self judgeQuestionAnsweredWithQuestionItem:questionItem option:2] == YES ? [UIImage imageNamed:@"yuntu_practise_true"] : [UIImage imageNamed:@"yuntu_practise_false"] forState:UIControlStateNormal];
                        [optionBtn setTitle:@"" forState:UIControlStateNormal];
                    } else {
                        if ([self judgeQuestionAnsweredWithQuestionItem:questionItem option:2] == YES && questionItem.isAnswered) {
                            //答错则要显示正确答案及icon变化
                            optionLabel.textColor = def_text_trueAnswer;
                            [optionBtn setBackgroundImage:[UIImage imageNamed:@"yuntu_practise_true"] forState:UIControlStateNormal];
                            [optionBtn setTitle:@"" forState:UIControlStateNormal];
                        } else {
                            //未答则正常显示
                            optionLabel.textColor = [UIColor blackColor];
                            [optionBtn setBackgroundImage:[UIImage imageNamed:@"yuntu_practise_bg_n"] forState:UIControlStateNormal];
                            [optionBtn setTitle:@"B" forState:UIControlStateNormal];
                        }
                    }
                }
                    break;
                case 2:
                {
                    optionLabel.text = questionItem.option3;
                    if (questionItem.isOption3Selected) {
                        optionLabel.textColor = [self judgeQuestionAnsweredWithQuestionItem:questionItem option:3] == YES ? def_text_trueAnswer : def_text_falseAnswer;
                        [optionBtn setBackgroundImage:[self judgeQuestionAnsweredWithQuestionItem:questionItem option:3] == YES ? [UIImage imageNamed:@"yuntu_practise_true"] : [UIImage imageNamed:@"yuntu_practise_false"] forState:UIControlStateNormal];
                        [optionBtn setTitle:@"" forState:UIControlStateNormal];
                    } else {
                        if ([self judgeQuestionAnsweredWithQuestionItem:questionItem option:3] == YES && questionItem.isAnswered) {
                            //答错则要显示正确答案及icon变化
                            optionLabel.textColor = def_text_trueAnswer;
                            [optionBtn setBackgroundImage:[UIImage imageNamed:@"yuntu_practise_true"] forState:UIControlStateNormal];
                            [optionBtn setTitle:@"" forState:UIControlStateNormal];
                        } else {
                            //未答则正常显示
                            optionLabel.textColor = [UIColor blackColor];
                            [optionBtn setBackgroundImage:[UIImage imageNamed:@"yuntu_practise_bg_n"] forState:UIControlStateNormal];
                            [optionBtn setTitle:@"C" forState:UIControlStateNormal];
                        }
                    }
                }
                    break;
                default:
                {
                    optionLabel.text = questionItem.option4;
                    if (questionItem.isOption4Selected) {
                        optionLabel.textColor = [self judgeQuestionAnsweredWithQuestionItem:questionItem option:4] == YES ? def_text_trueAnswer : def_text_falseAnswer;
                        [optionBtn setBackgroundImage:[self judgeQuestionAnsweredWithQuestionItem:questionItem option:4] == YES ? [UIImage imageNamed:@"yuntu_practise_true"] : [UIImage imageNamed:@"yuntu_practise_false"] forState:UIControlStateNormal];
                        [optionBtn setTitle:@"" forState:UIControlStateNormal];
                    } else {
                        if ([self judgeQuestionAnsweredWithQuestionItem:questionItem option:4l] == YES && questionItem.isAnswered) {
                            //答错则要显示正确答案及icon变化
                            optionLabel.textColor = def_text_trueAnswer;
                            [optionBtn setBackgroundImage:[UIImage imageNamed:@"yuntu_practise_true"] forState:UIControlStateNormal];
                            [optionBtn setTitle:@"" forState:UIControlStateNormal];
                        } else {
                            //未答则正常显示
                            optionLabel.textColor = [UIColor blackColor];
                            [optionBtn setBackgroundImage:[UIImage imageNamed:@"yuntu_practise_bg_n"] forState:UIControlStateNormal];
                            [optionBtn setTitle:@"D" forState:UIControlStateNormal];
                        }
                    }
                }
                    break;
            }
            
        } else {
        cell = [tableView dequeueReusableCellWithIdentifier:explainID forIndexPath:indexPath];
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
            height = [AppUtil contentHeightWithText:titleLabel constraintWidth:self.collectionView.frame.size.width - titleWidthDiffer fontSize:17] + 16;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:titleImageID];
            UIImageView *questionView = (UIImageView *)[cell viewWithTag:1];
            questionView.hidden = questionItem.imageStr == NULL ? YES : NO;
            if (!questionView.hidden) {
                UIImage *normalImage = [UIImage imageNamed:questionItem.imageStr];
                if (normalImage.size.width > self.collectionView.frame.size.width - titleImageWidthDiffer) {
                    CGFloat imageWidth = self.collectionView.frame.size.width - titleImageWidthDiffer;
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
            height = [AppUtil contentHeightWithText:titleLabel constraintWidth:self.collectionView.frame.size.width - optionWidthDiffer fontSize:17] + 16;
        } else {
        titleLabel = questionItem.answer_explain;
        height = [AppUtil contentHeightWithText:titleLabel constraintWidth:self.collectionView.frame.size.width- explainWidthDiffer fontSize:17] + 16;
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
                    questionItem.isAnsweredRight = YES;//回答正确
                } else {
                    questionItem.isShowAnswerExplain = YES;
                    questionItem.isAnsweredRight = NO;//回答错误
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
                    questionItem.isAnsweredRight = YES;//回答正确
                } else {
                    questionItem.isShowAnswerExplain = YES;
                    questionItem.isAnsweredRight = NO;//回答错误
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
                    questionItem.isAnsweredRight = YES;//回答正确

                } else {
                    questionItem.isShowAnswerExplain = YES;
                    questionItem.isAnsweredRight = NO;//回答错误
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
                    questionItem.isAnsweredRight = YES;//回答正确

                } else {
                    questionItem.isShowAnswerExplain = YES;
                    questionItem.isAnsweredRight = NO;//回答错误
                    [tableView reloadData];
                }
            }
                break;
            default:
                break;
        }
        questionItem.isAnswered = YES;
        [self.answeredCollectionView reloadData];
    }
}

//根据题目类型选择相应的icon
- (UIImage *)imageWithQuestionType:(NSInteger)qType
{
    if (qType == 1) {//选择题
        return [UIImage imageNamed:@"yuntu_practise_danxuanti"];
    } else {
        return [UIImage imageNamed:@"yuntu_practise_panduanti"];
    }
}


//回答正确自动进入下一题
- (void)scrollToNextQuestion
{
    CGPoint centerPoint = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *currIndexPath = [self.collectionView indexPathForItemAtPoint:centerPoint];
    
    if (currIndexPath.row >= _questionList.count - 1) {
        return;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:currIndexPath.row + 1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    //进入下一题相应切换页数
    [self setPageBtnTitleWithIndexPath:nextIndexPath];
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
//    [self.pageButton setTitle:[NSString stringWithFormat:@"%lu/%lu",(unsigned long)indexPath.row + 1,(unsigned long)_questionList.count] forState:UIControlStateNormal];
//    _collectionViewRowNum = indexPath.row;
    [self setPageBtnTitleWithIndexPath:indexPath];
}

//设置导航栏右上角页数
- (void)setPageBtnTitleWithIndexPath:(NSIndexPath *)indexPath
{
    [self.pageButton setTitle:[NSString stringWithFormat:@"%lu/%lu",(unsigned long)indexPath.row + 1,(unsigned long)_questionList.count] forState:UIControlStateNormal];
    _collectionViewRowNum = indexPath.row;
}

#pragma mark - 点击事件
- (void)didPressPageItem
{
    self.maskView.hidden = NO;
    bShowBottomView = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.5;
        self.bottomView.frame = CGRectMake(0, self.view.frame.size.height / 3, self.view.frame.size.width, self.view.frame.size.height/3*2);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didPressedMaskView
{
    bShowBottomView = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.0;
        self.bottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/3*2);
    } completion:^(BOOL finished) {
        self.maskView.hidden = YES;
    }];
    
}


@end
