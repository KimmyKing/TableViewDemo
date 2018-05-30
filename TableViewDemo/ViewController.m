//
//  ViewController.m
//  TableViewDemo
//
//  Created by Cain on 2018/5/30.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

/**
 逻辑:
    1.先把图片添加到控制器view的最下层,再添加透明色的tableView(数据源有三组,每组1个,最后一组的cell高度占满整个屏幕:屏幕高度 - 导航栏高度 - 标签栏高度),这样滑动到第三组的时候,就滑到底了,且屏幕上显示的正好也是第三组的整个cell内容
    2.第三组的cell由复数个按钮的视图和一个scrollView组成
    3.scrollView上添加了按钮数量个数的BaseItemView(里面带有一个同样size的tableView)
 
 */




#import "ViewController.h"
#import "MainTableView.h"
#import "MainView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong)MainTableView *tableView;

@property (nonatomic , strong)UIView *headerView;

@property (nonatomic , strong)UIImageView *imgView;

@property (nonatomic , strong)UIView *navBarView;

@property (nonatomic , strong)UIView *tabBarView;

@property (nonatomic , assign)BOOL canScroll;

@property (nonatomic , assign)BOOL isHover; //buttonView是否悬停

@property (nonatomic , assign)BOOL isHoverPre; //记录buttonView上次的悬停状态

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.imgView];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.navBarView];
    
    [self.view addSubview:self.tabBarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMessage:) name:@"kInnerTableViewHasScrollToTop" object:nil];
}

- (void)tapImgView
{
    NSLog(@"点击了图片");
}

- (void)acceptMessage:(NSNotification *)notification
{
    NSString *canScroll = notification.userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

//MARK: -
//MARK: -- UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //记录之前的状态
    _isHoverPre = _isHover;
    CGFloat secondSectionY = [self.tableView rectForSection:2].origin.y - 60;
    CGFloat offsetY = self.tableView.contentOffset.y;

    //滑动到第二组时
    if (offsetY >= secondSectionY) {
        //固定tableView的位置
        self.tableView.contentOffset = CGPointMake(0, secondSectionY);
        _isHover = YES;
    }else{
        _isHover = NO;
    }

    //当悬停状态切换时
    if (_isHover != _isHoverPre) {
        //不悬停切换到悬停时(滑动到buttonView悬停的位置时)
        if (!_isHoverPre && _isHover) {
            //通知内层tableView可以滑动
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kMainTableViewHasScrollToSection2" object:nil userInfo:@{@"canScroll" : @"1"}];
            _canScroll = NO;
            NSLog(@"滑动到顶端");
        }

        //悬停切换到不悬停时(取消悬停状态)
        if (_isHoverPre && !_isHover && !_canScroll) {
            scrollView.contentOffset = CGPointMake(0, secondSectionY);
            NSLog(@"离开顶端");
        }

    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0.;
    if (indexPath.section == 0) {
        height = 160.;
    }else if(indexPath.section == 1){
        height = 60.;
    }else if(indexPath.section == 2){
        height = [UIScreen mainScreen].bounds.size.height - 60 - 60;
    }
    return height;
}

//MARK: -
//MARK: -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.view.frame), 20)];
        [cell.contentView addSubview:textlabel];
        textlabel.text = @"价格区";
        textlabel.textAlignment = NSTextAlignmentCenter;
    }else if (indexPath.section == 1){
        UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.view.frame), 20)];
        [cell.contentView addSubview:textlabel];
        textlabel.text = @"sku区";
        textlabel.textAlignment = NSTextAlignmentCenter;
    }
    else if (indexPath.section == 2) {
        NSArray *tabConfigArray = @[@{
                                        @"title":@"图文介绍",
                                        @"view":@"FirstItemView",
                                        @"data":@"图文介绍的数据",
                                        @"position":@0
                                        },
                                    @{
                                        @"title":@"商品详情",
                                        @"view":@"SecondItemView",
                                        @"data":@"商品详情的数据",
                                        @"position":@1
                                        },
                                    @{
                                        @"title":@"评价(273)",
                                        @"view":@"ThirdItemView",
                                        @"data":@"评价的数据",
                                        @"position":@2
                                        }];
        MainView *mainView = [[MainView alloc] initWithDataArray:tabConfigArray];
        [cell.contentView addSubview:mainView];
    }
    return cell;
}

- (MainTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[MainTableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 60)];
        _tableView.tableHeaderView = self.headerView;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColor.clearColor;
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
//        _headerView.backgroundColor = UIColor.clearColor;
    }
    return _headerView;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
        _imgView.image = [UIImage imageNamed:@"item"];
        _imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgView)];
        [_imgView addGestureRecognizer:tap];
    }
    return _imgView;
}

- (UIView *)navBarView
{
    if (!_navBarView) {
        _navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        _navBarView.backgroundColor = [UIColor orangeColor];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:_navBarView.bounds];
        textLabel.text = @"顶部BAR";
        textLabel.textAlignment = NSTextAlignmentCenter;
        [_navBarView addSubview:textLabel];
    }
    return _navBarView;
}

- (UIView *)tabBarView
{
    if (!_tabBarView) {
        _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60, [UIScreen mainScreen].bounds.size.width, 60)];
        _tabBarView.backgroundColor = UIColor.orangeColor;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:_tabBarView.bounds];
        textLabel.text = @"底部BAR";
        textLabel.textAlignment = NSTextAlignmentCenter;
        [_tabBarView addSubview:textLabel];
    }
    return _tabBarView;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
