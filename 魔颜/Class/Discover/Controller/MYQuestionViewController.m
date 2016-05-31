//
//  MYQuestionViewController.m
//  魔颜
//
//  Created by Meiyue on 16/5/16.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYQuestionViewController.h"
#import "MYPicModel.h"
#import "MYArticleModel.h"
#import "UIButton+Extension.h"
#import "MYCommentsModel.h"
#import "MYPublicView.h"
#import "MYTextView.h"
#import "MYCircleBtn.h"
#import "MYArticleCell.h"
#import "MYLoginViewController.h"
#import "MYHeader.h"
#import "DMHeartFlyView.h"


@interface MYQuestionViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
/** 导航条的背景view */
@property (nonatomic, strong) UIView  *navView;

/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;

@property (strong, nonatomic) UITableView *tableView;

/** 头部 */
@property (weak, nonatomic) UIView *headView;

@property (nonatomic, weak) UIImageView *imgView;

@property (nonatomic, assign) CGRect imgRect;

@property (nonatomic, assign) CGFloat previousY;

@property (strong, nonatomic) MYTextView *textView;
@property (weak, nonatomic) UIView  *commentView;
@property (weak, nonatomic) UIButton *praseBtn;
@property (weak, nonatomic) UIButton *commentBtn;
@property(strong,nonatomic) MYCircleBtn * sendBtn;

/** 发布 */
@property (strong, nonatomic) MYArticleModel *articleModel;
/**点赞小图片数组*/
@property (strong, nonatomic) NSMutableArray *picArr;
/**评论数组*/
@property (strong, nonatomic) NSMutableArray *commentArr;
/** 标题 */
@property (weak, nonatomic) UILabel *nameLabel;
/** 图片栏 */
@property (strong, nonatomic)  MYPublicView *picView;

/**
 *  <#Description#>
 */
@property(weak, nonatomic) UIImageView *iconView;
@property(weak, nonatomic) UILabel *titleName;
@property(weak, nonatomic) UILabel *timeLable;

/** 查看次数 */
@property (weak, nonatomic) UILabel *lookLabel;
@property(weak, nonatomic) UILabel *textLab;
@property(strong,nonatomic) UILabel *titleLabel;

/** 点赞图 */
@property (weak, nonatomic)  UIScrollView *praseView;

/** 收藏按钮 */
@property (weak, nonatomic) UIButton *collectBtn;
/** 删除按钮 */
@property (weak, nonatomic) UIButton *deleteBtn;

/** 帖子是否可以删除 */
@property (copy, nonatomic) NSString *isDelete;

@end

//顶部scrollHeadView 的高度,先给写死
static const CGFloat ScrollHeadViewHeight = 210;

@implementation MYQuestionViewController

- (NSMutableArray *)commentArr
{
    if (!_commentArr) {
        _commentArr = [NSMutableArray array];
    }
    return _commentArr;
    
}

- (NSMutableArray *)picArr
{
    if (!_picArr) {
        _picArr = [NSMutableArray array];
    }
    return _picArr;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化界面
    [self setUI];
    //初始化导航条上的内容
    [self setUpNavigtionBar];
    
    //请求数据
    [self setuprequestData];
    
    [self setupBoomView];
}

- (void)setUI
{
    //隐藏系统的导航条，由于需要自定义的动画，自定义一个view来代替导航条
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //将view的自动添加scroll的内容偏移关闭
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableview = [[UITableView alloc] init];
    tableview.frame = CGRectMake(0, 64, MYScreenW, self.view.height - 100);
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableView = tableview;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    [self setupTableViewHeadUI];
    
}

- (void)setupTableViewHeadUI
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, MYScreenW, 10);
    view.backgroundColor = [UIColor whiteColor];
    self.headView = view;
    self.tableView.tableHeaderView = view;
    
    
    //用户头像
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.frame = CGRectMake(kMargin, kMargin, 30, 30);
    self.iconView = iconView;
    [view addSubview:iconView];
    
    //用户名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(iconView.right + 8, iconView.y, 100, 15);
    nameLabel.font = MYFont(14);
    self.nameLabel = nameLabel;
    nameLabel.textColor = UIColorFromRGB(0x333333);
    [view  addSubview:nameLabel];
    
    //时间
    UILabel *timeLable = [[UILabel alloc]init];
    timeLable.frame = CGRectMake(iconView.right + 8, nameLabel.bottom + 3, 150, 15);
    timeLable.font = MYFont(12);
    timeLable.textColor = subTitleColor;
    self.timeLable = timeLable;
    [view addSubview:timeLable];
    
    //查看
    UIImageView *image = [UIImageView addImaViewWithFrame:CGRectMake(MYScreenW - 120, 17, 20, 12) imageName:@"eye"];
    [view addSubview:image];
    
    UILabel *lookLabel = [UILabel addLabelWithFrame:CGRectMake(image.right + 5, image.y, 30, 15) title:nil titleColor:titlecolor font:leftFont];
    self.lookLabel = lookLabel;
    [view addSubview:lookLabel];
    
    //收藏
    UIButton *collectionBtn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 50, image.y - 4, 40, 20) title:@"收藏" backgroundColor:nil titleColor:MYRedColor font:leftFont Target:self action:@selector(clickCollection)];
    collectionBtn.layer.borderColor = MYRedColor.CGColor;
    collectionBtn.layer.borderWidth = 1.0;
    collectionBtn.layer.cornerRadius = 3;
    collectionBtn.layer.masksToBounds = YES;
    self.collectBtn = collectionBtn;
    [view addSubview:collectionBtn];
    
    //删除
    UIButton *deleteBtn = [UIButton addButtonWithFrame:CGRectZero title:@"删除" backgroundColor:nil titleColor:MYRedColor font:leftFont Target:self action:@selector(clickDeleteBtn)];
    deleteBtn.layer.borderColor = MYRedColor.CGColor;
    deleteBtn.layer.borderWidth = 1.0;
    deleteBtn.layer.cornerRadius = 3;
    deleteBtn.layer.masksToBounds = YES;
    self.deleteBtn = deleteBtn;
    [view addSubview:deleteBtn];
    
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, iconView.bottom + kMargin, MYScreenW, 10)];
    bgview.backgroundColor = MYBgColor;
    [view addSubview:bgview];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(kMargin, bgview.bottom + kMargin, MYScreenW, 20);
    titleLabel.font = ThemeFont;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel = titleLabel;
    titleLabel.textColor = UIColorFromRGB(0x1a1a1a);
    [view addSubview:titleLabel];
    
    //正文
    UILabel *textLab = [[UILabel alloc] init];
    textLab.font = MYFont(14);
    textLab.numberOfLines = 0;
    self.textLab = textLab;
    textLab.textColor = titlecolor;
    [view addSubview:textLab];
    
    //发布的图片
    MYPublicView *picView = [[MYPublicView alloc] init];
    [view addSubview:picView];
    self.picView = picView;
    
}

//请求数据
-(void)setuprequestData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"publishId"] = self.id;
    params[@"type"] = @"1";
    params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/publish/queryPublishInfo",kOuternet1] params:params success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"success"])  {
            
            self.isDelete = responseObject[@"isDelete"];//0是可以删除的
        
            self.articleModel = [MYArticleModel objectWithKeyValues:responseObject[@"publish"]];
            [self setHeadData];
            
            for (NSArray *arr in responseObject[@"comments"]) {
                [self.commentArr addObject:[MYCommentsModel objectArrayWithKeyValuesArray:arr]];
            }
            [self.tableView reloadData];
         }
        
    } failure:^(NSError *error) {
        
        [self.tableView.header endRefreshing];
        
    }];
}

- (void)setHeadData
{
    self.titleName.text = self.articleModel.title;
    [self.iconView setCircleHeaderWithURL:[NSString stringWithFormat:@"%@%@",kOuternet1,self.articleModel.userPic]];
    self.nameLabel.text = self.articleModel.name;
    self.timeLable.text = self.articleModel.createTime;
    self.lookLabel.text = self.articleModel.readNumber;
    
    if ([self.isDelete isEqualToString:@"0"]) {
        
        self.collectBtn.frame = CGRectMake(MYScreenW - 50, 3, 40, 20);
        self.deleteBtn.frame = CGRectMake(MYScreenW - 50, 28, 40, 20);
        
    }
    
    self.titleLabel.text = self.articleModel.title;
    
    self.textLab.text = _articleModel.comment;
    [self.textLab setRowSpace:5.0];
    
    //正文设置
    CGFloat width = MYScreenW - 2 * kMargin;
    CGFloat height = [self.textLab heightWithWidth:width];
    self.textLab.frame = CGRectMake(kMargin, self.titleLabel.bottom + kMargin, width, height);
    
    //图片
    if (![self.articleModel.commentPic isEqualToString:@""]) {
            NSArray *pictures = [self.articleModel.commentPic componentsSeparatedByString:@","];
            self.picView.pictures = pictures;
            CGSize picViewSize = [MYPublicView sizeWithPicturesCount:pictures.count];
            CGFloat picViewX = kMargin;
            CGFloat picViewY = kMargin + self.textLab.bottom;
            
            CGFloat postionViewW = picViewSize.width;
            CGFloat postionViewH = picViewSize.height;
            
            self.picView.frame = (CGRect){picViewX,picViewY,postionViewW,postionViewH};
    }
    
    UIView *bgSview = [[UIView alloc] initWithFrame:CGRectMake(0, _textLab.bottom + self.picView.height + kMargin, MYScreenW, 10)];
    bgSview.backgroundColor = MYBgColor;
    [self.headView addSubview:bgSview];
    
    //点赞,评论
    UILabel *sLabel = [UILabel addLabelWithFrame:CGRectMake(self.view.width / 3 * 2 - kMargin , bgSview.bottom + 5, self.view.width / 3, 15) title:nil titleColor:subTitleColor font:leftFont];
    sLabel.text = [NSString stringWithFormat:@"共%@个赞,%@条评论",self.articleModel.likeNumber,self.articleModel.anwserNumber];
    sLabel.textAlignment = NSTextAlignmentRight;
    [self.headView addSubview:sLabel];
    
    CGFloat tableHeight = sLabel.bottom + self.praseView.height + kMargin;
    [self.tableView.tableHeaderView setHeight:tableHeight];
    self.tableView.tableHeaderView = self.headView;
    
    
}

//初始化导航条上的内容
- (void)setUpNavigtionBar
{
    //初始化山寨导航条
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MYScreenW, 64)];
    self.navView.backgroundColor = [UIColor whiteColor];
    self.navView.alpha = 0.0;
    
    CGFloat titleW = MYScreenW - 50;
    UILabel *titleLabel = [UILabel addLabelWithFrame:CGRectMake((MYScreenW - titleW)/ 2, 20, titleW, 44) title:nil titleColor:titlecolor font:MYFont(12)];
    self.titleName = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:titleLabel];
    [self.view addSubview:self.navView];
    
    //添加返回按钮
    UIImageView *imageView = [UIImageView addImaViewWithFrame:CGRectMake(15, 32, 12, 18) imageName:@"back-1"];
    [self.view addSubview:imageView];
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(kMargin, MYMargin, 40, 40);
    [self.backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    [self.navView addSubview:[UIView addLineWithLineTopValue:62]];
    
}

//返回上个控制器
- (void)backButtonClick:(UIButton *)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - ************* tableViewDelegate *************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.commentArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.commentArr[section];
    return arr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYArticleCell *cell = [MYArticleCell cellWithTableView:tableView indexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.type = @"1";
    }
    
    MYCommentsModel *model = self.commentArr[indexPath.section][indexPath.row];
    cell.commentsModel = model;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MYCommentsModel *commentModel = self.commentArr[indexPath.section][indexPath.row];
    
    if (indexPath.row == 0) {
        self.textView.placeHoledr = [NSString stringWithFormat:@"回复了 %@",commentModel.name];
    }else{
        self.textView.placeHoledr = [NSString stringWithFormat:@"回复了 %@",commentModel.name];
    }
    self.sendBtn.tag = indexPath.section;
    self.sendBtn.ID = indexPath.row;
    
    [self.textView becomeFirstResponder];
    
}

//底部菜单
-(void)setupBoomView
{
    UIView *boomview = [[UIView alloc]initWithFrame:CGRectMake(0, MYScreenH - 50, MYScreenW, 50)];
    boomview.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.view addSubview:boomview];
    self.commentView = boomview;
    
    
    //点赞按钮
    UIButton *praiseBtn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 35, kMargin, 30, 30) backgroundColor:nil Target:self action:@selector(ClickDianzanBtn)];
    [praiseBtn setImage:[UIImage imageNamed:@"prase_normal"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"prase_press"] forState:UIControlStateSelected];
    self.praseBtn = praiseBtn;
    [boomview addSubview:praiseBtn];
    
    //发送按钮
    MYCircleBtn *sendBtn = [[MYCircleBtn alloc] initWithFrame:CGRectMake(praiseBtn.x - 65, kMargin, 60, 30)];
    [sendBtn setTitle:@"发布评论"];
    [sendBtn addTarget:self action:@selector(sendMessage:)];
    self.sendBtn = sendBtn;
    sendBtn.tag = - 1;
    [self.commentView addSubview:sendBtn];
    
    //内容视图
    MYTextView *textView = [[MYTextView alloc] initWithFrame:CGRectMake(kMargin, 10, sendBtn.x - MYMargin, 30)];
    // 滚动textView,出发方法，里面退下键盘
    textView.delegate = self;
    textView.layer.cornerRadius = 3;
    textView.layer.masksToBounds = YES;
    textView.font = MYFont(14);
    textView.placeHoledr = @"别拦我，让我说句话";
    self.textView = textView;
    [self.commentView addSubview:textView];
    
    // 监听键盘的弹出的隐藏
    // 监听键盘弹出和退下
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

/** 点赞数据 */
- (void)ClickDianzanBtn
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"publishId"] = self.id;
    
    DMHeartFlyView* heart = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(self.view.frame.size.width-50 + 36/2.0, self.view.bounds.size.height - 36/2.0 - 10);
    heart.center = fountainSource;
    [heart animateInView:self.view];

    /**收藏*/
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@publish/reLike",kOuternet1] params:params success:^(id responseObject) {
        
    } failure:^(NSError *error) {
    }];
    self.praseBtn.selected = YES;
}
/** 删除 */
- (void)clickDeleteBtn
{
    
    [UIAlertViewTool showAlertView:self title:nil message:@"确认删除" cancelTitle:@"取消" otherTitle:@"确认" cancelBlock:^{
        
    } confrimBlock:^{
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"publishId"] = self.id;
        
        [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/publish/deletePublish",kOuternet1] params:param success:^(id responseObject) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            if (self.deleteBlock) {
                self.deleteBlock();
            }
            
            
        } failure:^(NSError *error) {
            
            
        }];
    }
     ];
    
}

/**请求收藏数据*/
-(void)clickCollection
{
    if (!MYAppDelegate.isLogin) {
        
        
        MYLoginViewController *loginVC = [[MYLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }else{
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
        params[@"type"] = @"1";
        params[@"collectId"] = self.id;
        params[@"collectTitle"] = self.articleModel.title;
        params[@"collectPic"] = self.articleModel.homePic;
        
        /**收藏*/
        [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@publish/collect",kOuternet1] params:params success:^(id responseObject) {
            
            if ([responseObject[@"status"] isEqualToString:@"-201"]) {
                [MBProgressHUD showHUDWithTitle:@"您已收藏" andImage:nil andTime:1.0];
            }
            
            if ([responseObject[@"status"] isEqualToString:@"success"]) {
                [MBProgressHUD showHUDWithTitle:@"收藏成功" andImage:nil andTime:1.0];
            }
            
        } failure:^(NSError *error) {
        }];
    }
}
/** 发帖子 */
- (void)sendMessage:(MYCircleBtn *)btn
{
    if (!MYAppDelegate.isLogin) {
        
        
        MYLoginViewController *loginVC = [[MYLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return ;
    
    }
        
       if(NULLString(self.textView.text)){
            [MBProgressHUD showHUDWithTitle:@"请输入评论内容" andImage:nil andTime:1.0];
            return ;
       }else if ([NSString stringContainsEmoji:self.textView.text]){
               
               [MBProgressHUD showHUDWithTitle:@"暂不支持表情" andImage:nil andTime:1.0];
               return;
      }else{
    
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"publishId"] = self.id;
        params[@"comment"] = self.textView.text;
        params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
        
        if (btn.tag != -1) {
            
            MYCommentsModel *commentModel = self.commentArr[btn.tag][btn.ID];
            params[@"fatherCommentId"] = commentModel.id;
            params[@"fatherCommentUserName"] = commentModel.name;
            if (btn.ID == 0) {
                params[@"totalCommentId"] = commentModel.id;
            }else{
                params[@"totalCommentId"] = commentModel.totalCommentId;
            }
        }
        
        [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@publish/recomments",kOuternet1] params:params success:^(id responseObject) {
            
            if ([responseObject[@"status"] isEqualToString:@"success"]) {
                
                MYCommentsModel *model = [[MYCommentsModel alloc] init];
                model.comment = self.textView.text;
                model.createTime = @"刚刚";
                
                if (btn.tag == -1) {
                    
                    model.pic = [MYUserDefaults objectForKey:@"userPic"];
                    model.userid = [MYUserDefaults objectForKey:@"id"];
                    model.name = [MYUserDefaults objectForKey:@"name"];
                    model.id = responseObject[@"id"];
                    NSMutableArray *arr = [NSMutableArray array];
                    [arr addObject:model];
                    [self.commentArr addObject:arr];
                    
                }else{
                    
                    MYCommentsModel *commentModel = self.commentArr[btn.tag][btn.ID];
                    model.userid = commentModel.userid;
                    model.name = commentModel.name;
                    model.publishId = commentModel.publishId;
                    model.fatherCommentId = commentModel.fatherCommentId;
                    model.id = responseObject[@"id"];
                    model.totalCommentId = responseObject[@"totalCommentId"];
                    model.fatherCommentUserName = commentModel.name;
                    [self.commentArr[btn.tag] addObject:model];
                    
                }
                
                [self.tableView reloadData];
                [self.view endEditing:YES];
                
            }
            
            else if ([responseObject[@"status"] isEqualToString: @"-110"]){
                
                [MBProgressHUD showHUDWithTitle:@"暂不支持表情" andImage:nil andTime:1.0];
            }

            
            MYLog(@"%@",responseObject);
            
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)keyboardWillShow:(NSNotification *)noti
{
    
    // 取出键盘弹出的时间
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 取出键盘高度
    CGRect keyBoardRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardRect.size.height;
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        self.commentView.transform = CGAffineTransformMakeTranslation(0, -keyBoardHeight );
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti
{
    // 取出键盘隐藏的时间
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 清空transform
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        self.commentView.transform = CGAffineTransformIdentity;
        [self.textView setText:@""];
        self.textView.placeHoledr = @"别拦我,让我说句话";
        self.textView.placeLabel.hidden = NO;
        self.sendBtn.tag = -1;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.view endEditing:YES];
    
    if (scrollView) {//说明是tableView在滚动
        
        //记录出上一次滑动的距离，因为是在tableView的contentInset中偏移的ScrollHeadViewHeight，所以都得加回来
        CGFloat offsetY = scrollView.contentOffset.y;
        
        //根据偏移量算出alpha的值,渐隐,当偏移量大于-180开始计算消失的值
        CGFloat startF = -180;
        //初始的偏移量Y值为 顶部控件的高度
        CGFloat initY = ScrollHeadViewHeight;
        //缺少的那一段渐变Y值
        CGFloat lackY = initY + startF;
        //自定义导航条高度
        CGFloat naviH = 64;
        
        //渐现alph值
        CGFloat alphaScaleShow = (offsetY + initY - lackY) /  (initY - naviH - lackY);
        
        if (alphaScaleShow >= 0.98) {
            //显示导航条
            [UIView animateWithDuration:0.04 animations:^{
                self.navView.alpha = 1;
            }];
        } else {
            self.navView.alpha = 0;
        }
        self.navView.alpha = alphaScaleShow;
        
    }
    
    // 往上下滚动
    if (self.previousY < scrollView.contentOffset.y) {
        [UIView animateWithDuration:1.0 animations:^{
            
         self.titleName.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }];
        
    }else{
        
        [UIView animateWithDuration:1.0 animations:^{
            self.titleName.transform = CGAffineTransformIdentity;
        }];
    }
    self.previousY = scrollView.contentOffset.y;
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
// 将要拖拽的时候调一次
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.commentView endEditing:YES];
    
}

@end