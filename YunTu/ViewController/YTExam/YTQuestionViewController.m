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
#import "UIViewController+NavUtils.h"
#import "answeredCollectionCell.h"
#import "JZAlbumViewController.h"
#import "UserInfo.h"
#import "YTTabButton.h"
#import "Pods/AFNetworking/AFNetworking/AFNetworking.h"
#import "Pods/MBProgressHUD/MBProgressHUD.h"

#define titleWidthDiffer        43
#define titleImageWidthDiffer   16
#define optionWidthDiffer       60
#define explainWidthDiffer      40
#define MainCollectionViewTag   222
#define AnsweredCollectionViewTag 333
#define DeleteAlertTag            888
#define HandInAlertTag            999
@interface YTQuestionViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    BOOL bShowBottomView;
    BOOL bShowLargeImage;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIControl *maskView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UICollectionView *answeredCollectionView;//答题情况表
@property (assign,nonatomic) NSUInteger collectionViewRowNum;
@property (strong, nonatomic) NSMutableArray *questionList;
@property (weak, nonatomic) YTTabButton *pageButton;//页数
@property (strong, nonatomic) YTTabButton *correctBtn;//底部答对题数按钮
@property (strong, nonatomic) YTTabButton *wrongBtn;//底部答错题数按钮
@property (weak, nonatomic) UIBarButtonItem *pageItem;
@property (strong, nonatomic) UIImageView *imgvQuestion;
@property (strong, nonatomic) UIControl *largeImgMaskView;
@property (strong, nonatomic) NSMutableArray *arrImgQuestion;
@property (assign, nonatomic) NSUInteger rightQuesCount;//答对题数
@property (assign, nonatomic) NSUInteger wrongQuesCount;//答错题数
@property (assign, nonatomic) NSUInteger testScore;//分数
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

- (NSMutableArray *)arrImgQuestion
{
    if (!_arrImgQuestion) {
        _arrImgQuestion = [NSMutableArray array];
    }
    return _arrImgQuestion;
}

- (NSMutableArray *)questionList
{
    if (!_questionList) {
        _questionList = [NSMutableArray array];
    }
    return _questionList;
}

- (void)createBaseView
{
    //导航栏视图
    [self createNavgationView];
    //主集合视图
    [self createMainCollectionView];
    //答题情况表
    [self createBottomAnswerView];
    
    self.tabBarItem.image = [[UIImage imageNamed:@"canvas1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

//导航栏视图
- (void)createNavgationView
{
    //删除按钮
    YTButton *deleteBtn = [[YTButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"test_top_card"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(didPressDelete) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];

    //查看题解按钮
    YTButton *explainBtn = [[YTButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [explainBtn setTitle:@"题解" forState:UIControlStateNormal];
    explainBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [explainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [explainBtn addTarget:self action:@selector(didPressExplain) forControlEvents:UIControlEventTouchUpInside];
    [explainBtn setImage:[UIImage imageNamed:@"test_top_shoucnag_n"] forState:UIControlStateNormal];
    UIBarButtonItem *explainItem = [[UIBarButtonItem alloc]initWithCustomView:explainBtn];
    
    
    //收藏按钮
    YTButton *storeBtn = [[YTButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [storeBtn setTitle:@"收藏" forState:UIControlStateNormal];
    storeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [storeBtn addTarget:self action:@selector(didPressStore) forControlEvents:UIControlEventTouchUpInside];
    [storeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [storeBtn setImage:[UIImage imageNamed:@"test_top_shoucnag_n"] forState:UIControlStateNormal];
    UIBarButtonItem *storeItem = [[UIBarButtonItem alloc]initWithCustomView:storeBtn];
    //错题练习模式多个删除本题按钮
    if (self.answerType == YTAnswerWrong) {
        self.navigationItem.rightBarButtonItems = @[deleteItem,storeItem,explainItem];
    } else {
        self.navigationItem.rightBarButtonItems = @[storeItem,explainItem];
    }
}

//初始化主集合视图
- (void)createMainCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 64 - 40);
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
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 64-40, ScreenWidth, ScreenHeight/3*2)];
    self.bottomView.backgroundColor = def_BG_DarkBlue;
    
    //交卷按钮
    YTTabButton *handBtn = [[YTTabButton alloc]initWithFrame:CGRectMake(15, 0, 80, 40)];
    [handBtn addTarget:self action:@selector(didPressHandExams) forControlEvents:UIControlEventTouchUpInside];
    [handBtn setTitle:@"交卷" forState:UIControlStateNormal];
    handBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [handBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [handBtn setImage:[UIImage imageNamed:@"test_top_shoucnag_n"] forState:UIControlStateNormal];
    [_bottomView addSubview:handBtn];
    //答对题目按钮
    self.correctBtn = [[YTTabButton alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 80, 0, 80, 40)];
    [self.correctBtn setTitle:@"正确" forState:UIControlStateNormal];
    self.correctBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.correctBtn addTarget:self action:@selector(didPressPageItem) forControlEvents:UIControlEventTouchUpInside];
    [self.correctBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.correctBtn setImage:[UIImage imageNamed:@"test_top_shoucnag_n"] forState:UIControlStateNormal];
    [_bottomView addSubview:self.correctBtn];
    //答错题目按钮
    self.wrongBtn = [[YTTabButton alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, 80, 40)];
    [self.wrongBtn setTitle:@"错误" forState:UIControlStateNormal];
    self.wrongBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.wrongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.wrongBtn addTarget:self action:@selector(didPressPageItem) forControlEvents:UIControlEventTouchUpInside];
    [self.wrongBtn setImage:[UIImage imageNamed:@"test_top_shoucnag_n"] forState:UIControlStateNormal];
    [_bottomView addSubview:self.wrongBtn];
    //题目序号
    YTTabButton *pageBtn = [[YTTabButton alloc]initWithFrame:CGRectMake(ScreenWidth - 80, 0, 80, 40)];
    [pageBtn setTitle:[NSString stringWithFormat:@"%lu/%lu",(unsigned long)_collectionViewRowNum + 1,(unsigned long)_questionList.count] forState:UIControlStateNormal];
    [pageBtn addTarget:self action:@selector(didPressPageItem) forControlEvents:UIControlEventTouchUpInside];
    pageBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [pageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pageBtn setImage:[UIImage imageNamed:@"test_top_shoucnag_n"] forState:UIControlStateNormal];
    [_bottomView addSubview:pageBtn];
    self.pageButton = pageBtn;
    
    //答题情况集合视图
    UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc]init];
    layout2.itemSize = CGSizeMake(30, 30);
    layout2.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout2.minimumInteritemSpacing = 10;
    layout2.minimumLineSpacing = 10;
    layout2.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.answeredCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.bottomView.frame.size.height - 44) collectionViewLayout:layout2];
    [self.answeredCollectionView registerNib:[UINib nibWithNibName:@"answeredCollectionCell" bundle:nil] forCellWithReuseIdentifier:answerCollectionCellID];
    self.answeredCollectionView.tag = AnsweredCollectionViewTag;
    self.answeredCollectionView.userInteractionEnabled = YES;
    self.answeredCollectionView.delegate = self;
    self.answeredCollectionView.dataSource = self;
    self.answeredCollectionView.backgroundColor = [UIColor whiteColor];
    [_bottomView addSubview:self.answeredCollectionView];
    [self.view addSubview:_bottomView];
}


- (void)initDefaultData
{
//    [UserInfo sharedInstance].isOriginalDataBase = NO;
    self.wrongQuesCount = 0;
    self.rightQuesCount = 0;
    self.testScore = 0;
    
    switch (self.answerType) {
        case YTAnswerExam:
        {
            self.title = @"模拟考试";
            NSMutableArray *array1 = [[[YTDataBaseManager sharedInstance] questionsListWithSectionNum:1] mutableCopy];
            NSMutableArray *array2 = [[[YTDataBaseManager sharedInstance] questionsListWithSectionNum:2] mutableCopy];
            NSMutableArray *array3 = [[[YTDataBaseManager sharedInstance] questionsListWithSectionNum:3] mutableCopy];
            while (self.questionList.count < 15) {
                if (array1.count > 0) {
                    int r1 = arc4random() % array1.count;
                    [self.questionList addObject:array1[r1]];
                    [array1 removeObjectAtIndex:r1];
                }
                if (self.questionList.count >=15) {
                    return;
                }
                if (array2.count > 0) {
                    int r2 = arc4random() % array2.count;
                    [self.questionList addObject:array2[r2]];
                    [array2 removeObjectAtIndex:r2];
                }
                if (self.questionList.count >=15) {
                    return;
                }
                if (array3.count > 0) {
                    int r3 = arc4random() % array3.count;
                    [self.questionList addObject:array3[r3]];
                    [array3 removeObjectAtIndex:r3];
                }
            }
        }
            break;
        case YTAnswerOrder:
        {
            self.questionList = [[YTDataBaseManager sharedInstance] questionsList];
            self.title = @"顺序练习";
        }
            break;
        case YTAnswerSection:
        {
            self.questionList = [[YTDataBaseManager sharedInstance] questionsListWithSectionNum:self.sectionNum];
            self.title = @"章节练习";
        }
            break;
        case YTAnswerRandom:
        {
            NSMutableArray *array = [[[YTDataBaseManager sharedInstance] questionsList] mutableCopy];
            if ([YTDataBaseManager sharedInstance].questionsList.count < 10) {
                self.questionList = [YTDataBaseManager sharedInstance].questionsList;
            } else {
                while (self.questionList.count < 10) {
                    int r = arc4random() % array.count;
                    [self.questionList addObject:array[r]];
                    [array removeObjectAtIndex:r];
                }
            }
            self.title = @"随机练习";
        }
            break;
        case YTAnswerWrong:
        {
            self.questionList = [YTDataBaseManager sharedInstance].wrongQuestionsList;
            self.title = @"错题练习";
        }
            break;
        case YTAnswerStore:
        {
            self.questionList = [YTDataBaseManager sharedInstance].storeQuestionsList;
            self.title = @"收藏练习";
        }
            break;
        default:
            break;
    }
    
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
        cell.btnAnswerNum.tag = indexPath.row + 1000;
        [cell.btnAnswerNum addTarget:self action:@selector(scrollToSelectedQuestion:) forControlEvents:UIControlEventTouchUpInside];
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
        return (questionItem.QShortImgUrl == NULL ? 1 : 2);
    } else if (section == 1){
        return ([questionItem.QType integerValue] == 1 ? 4 : 2);
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
            titleLabel.text = questionItem.QTitle;
            typeView.image = [self imageWithQuestionType:questionItem.QType];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:titleImageID forIndexPath:indexPath];
                UIImageView *questionView = (UIImageView *)[cell viewWithTag:1];
                questionView.hidden = questionItem.QShortImgUrl == NULL ? YES : NO;
                if (!questionView.hidden) {
                    UIImage *normalImage = [UIImage imageNamed:questionItem.QShortImgUrl];
                    normalImage = [self autoResizeImage:normalImage];
                    questionView.image = normalImage;
                    self.imgvQuestion.frame = CGRectMake(8, (ScreenHeight-normalImage.size.height)/2, normalImage.size.width, normalImage.size.height);
                    self.imgvQuestion.image = normalImage;
                }
            }
        } else if (indexPath.section == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:optionID forIndexPath:indexPath];
            UILabel *optionLabel = (UILabel *)[cell viewWithTag:1];
            UIButton *optionBtn = (UIButton *)[cell viewWithTag:2];
            switch (indexPath.row) {
                case 0:
                {
                    optionLabel.text = questionItem.QOption1;
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
                    optionLabel.text = questionItem.QOption2;
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
                    optionLabel.text = questionItem.QOption3;
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
                    optionLabel.text = questionItem.QOption4;
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
        optionLabel.text = questionItem.QExplain;
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
            titleLabel = questionItem.QTitle;
            height = [AppUtil contentHeightWithText:titleLabel constraintWidth:self.collectionView.frame.size.width - titleWidthDiffer fontSize:17] + 16;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:titleImageID];
            UIImageView *questionView = (UIImageView *)[cell viewWithTag:1];
            questionView.hidden = questionItem.QShortImgUrl == NULL ? YES : NO;
            if (!questionView.hidden) {
                UIImage *normalImage = [UIImage imageNamed:questionItem.QShortImgUrl];
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
                    titleLabel = questionItem.QOption1;
                    break;
                case 1:
                    titleLabel = questionItem.QOption2;
                    break;
                case 2:
                    titleLabel = questionItem.QOption3;
                    break;
                default:
                    titleLabel = questionItem.QOption4;
                    break;
            }
            height = [AppUtil contentHeightWithText:titleLabel constraintWidth:self.collectionView.frame.size.width - optionWidthDiffer fontSize:17] + 16;
        } else {
        titleLabel = questionItem.QExplain;
        height = [AppUtil contentHeightWithText:titleLabel constraintWidth:self.collectionView.frame.size.width- explainWidthDiffer fontSize:17] + 16 + 26;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTQuestionItem *questionItem = _questionList[_collectionViewRowNum];
    if (indexPath.section == 0 && indexPath.row == 1) {
        //点击问题的图片
#warning 图片的下载缓存问题待解决
//        self.largeImgMaskView.hidden = NO;
//        self.imgvQuestion.hidden = NO;
//        [UIView animateWithDuration:0.2 animations:^{
//            self.largeImgMaskView.alpha = 1.0;
//            
//        } completion:^(BOOL finished) {
//            bShowLargeImage = YES;
//        }];
        JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
        jzAlbumVC.currentIndex = 0;//这个参数表示当前图片的index，默认是0
        [self.arrImgQuestion removeAllObjects];
        if ([UserInfo sharedInstance].isOriginalDataBase) {
            [self.arrImgQuestion addObject:[UIImage imageNamed:questionItem.QLargeImgUrl]];
            jzAlbumVC.bUrlArray = NO;
        } else {
            [self.arrImgQuestion addObject:@"http://c.hiphotos.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=7fbeb14496ef76c6c4dff379fc7f969f/faedab64034f78f06d55f9967f310a55b3191c7c.jpg"];
            jzAlbumVC.bUrlArray = YES;
        }
        jzAlbumVC.imgArr = self.arrImgQuestion;//图片数组，可以是url，也可以是UIImage
        [self.navigationController presentViewController:jzAlbumVC animated:YES completion:^{
            
        }];
        
        
    }
    if (indexPath.section == 1 && !questionItem.isAnswered) {
        switch (indexPath.row) {
            case 0:
            {
                questionItem.isOption1Selected = YES;
                if ([questionItem.QOption1 isEqualToString:questionItem.QAnswer]) {
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
                if ([questionItem.QOption2 isEqualToString:questionItem.QAnswer]) {
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
                if ([questionItem.QOption3 isEqualToString:questionItem.QAnswer]) {
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
                if ([questionItem.QOption4 isEqualToString:questionItem.QAnswer]) {
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
        //答错则存入错题表
        if (!questionItem.isAnsweredRight) {
            [[YTDataBaseManager sharedInstance]saveWrongQuestionListDataBaseWithItem:questionItem];
            self.wrongQuesCount  += 1;
        } else {
            self.rightQuesCount  += 1;
        }
        [self refreshBottomBtnTitle];
        [self.answeredCollectionView reloadData];
    }
}

//根据题目类型选择相应的icon
- (UIImage *)imageWithQuestionType:(NSString *)qType
{
    if ([qType integerValue] == 1) {//选择题
        return [UIImage imageNamed:@"yuntu_practise_danxuanti"];
    } else {
        return [UIImage imageNamed:@"yuntu_practise_panduanti"];
    }
}

//刷新正确错误title
- (void)refreshBottomBtnTitle
{
    [self.correctBtn setTitle:[NSString stringWithFormat:@"正确%zd",self.rightQuesCount] forState:UIControlStateNormal];
    [self.wrongBtn setTitle:[NSString stringWithFormat:@"错误%zd",self.wrongQuesCount] forState:UIControlStateNormal];
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

//跳转到选择的题号对应的题目
- (void)scrollToSelectedQuestion:(UIButton *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag - 1000 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self setPageBtnTitleWithIndexPath:indexPath];
    [self didPressedMaskView];
}


//自动适应图片大小
- (UIImage *)autoResizeImage:(UIImage *)nativeImage
{
    if (nativeImage.size.width > self.collectionView.frame.size.width - titleImageWidthDiffer) {
        CGFloat imageWidth = self.collectionView.frame.size.width - titleImageWidthDiffer;
        CGFloat imageHeight = nativeImage.size.height * (imageWidth / nativeImage.size.width);
        nativeImage = [nativeImage resizeToSize:CGSizeMake(imageWidth, imageHeight)];
    }
    return nativeImage;
}

- (BOOL)judgeQuestionAnsweredWithQuestionItem:(YTQuestionItem *)questionItem option:(NSUInteger)option
{
    NSString *strOption;
    switch (option) {
        case 1:
            strOption = questionItem.QOption1;
            break;
        case 2:
            strOption = questionItem.QOption2;
            break;
        case 3:
            strOption = questionItem.QOption3;
            break;
        default:
            strOption = questionItem.QOption4;
            break;
    }
    if ([questionItem.QAnswer isEqualToString:strOption]) {
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

#pragma mark - 提交试卷
- (void)postExamScore
{
    __weak typeof(self) weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"stuNum"] = [UserInfo sharedInstance].stuNum;//学号必传
    paras[@"stuName"] = [UserInfo sharedInstance].stuName;//姓名必传
    paras[@"stuMajor"] = [UserInfo sharedInstance].stuNum;//专业
    // 实例化NSDateFormatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd"];
    paras[@"date"] = [formatter stringFromDate:[NSDate date]];//日期
    paras[@"score"] = [UserInfo sharedInstance].stuNum;//分数必传

    [manager POST:YTImportScoreUrl parameters:paras success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self show:@"提交成功！" icon:@"" view:self.view];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [self show:@"提交失败！" icon:@"" view:self.view];
    }];
}

- (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:0.7];
}

//删除某条错题
- (void)deleteQuestionItem
{
    YTQuestionItem *questionItem = self.questionList[_collectionViewRowNum];
    [[YTDataBaseManager sharedInstance] deleteWrongQuestionListWithItem:questionItem];
    [self show:@"删除成功！" icon:@"" view:self.view];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == DeleteAlertTag) {
        if (buttonIndex == 1) {
            [self deleteQuestionItem];
        }
    } else if (alertView.tag == HandInAlertTag) {
        if (buttonIndex == 1) {
            [self postExamScore];
        }
    }
    
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

- (void)didPressDelete
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定从错题集中删除本题？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = DeleteAlertTag;
    [alert show];
}

- (void)didPressExplain
{
    YTQuestionItem *questionItem = self.questionList[_collectionViewRowNum];
    questionItem.isShowAnswerExplain = YES;
    [self.collectionView reloadData];
}

//收藏
- (void)didPressStore
{
    YTQuestionItem *item = _questionList[_collectionViewRowNum];
    [[YTDataBaseManager sharedInstance] saveStoreQuestionListDataBaseWithItem:item];
    [self show:@"收藏成功！" icon:@"" view:self.view];
}

- (void)didPressedMaskView
{
    bShowBottomView = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.0;
        self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, self.view.frame.size.height/3*2);
    } completion:^(BOOL finished) {
//        self.maskView.hidden = YES;
    }];
    
}

- (void)didPressedLargeImgMaskView
{
    bShowLargeImage = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.largeImgMaskView.alpha = 0.0;
        self.imgvQuestion.hidden = YES;
    } completion:^(BOOL finished) {
        self.largeImgMaskView.hidden = YES;
    }];
}

- (void)didPressHandExams
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您已经回答了3题，考试得分0分，确定要交卷嘛？" delegate:self cancelButtonTitle:@"继续答题" otherButtonTitles:@"交卷", nil];
    alert.tag = HandInAlertTag;
    [alert show];
}

@end
