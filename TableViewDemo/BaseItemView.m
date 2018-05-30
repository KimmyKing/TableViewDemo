//
//  BaseItemView.m
//  TableViewDemo
//
//  Created by Cain on 2018/5/30.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

#import "BaseItemView.h"

@implementation BaseItemView

- (instancetype)initWithDic:(NSDictionary *)dic
{
    NSNumber *position = dic[@"position"];
    if (self = [super initWithFrame:CGRectMake(position.integerValue * UIScreen.mainScreen.bounds.size.width, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - 60 - 60 - 45)]) {

        self.dic = dic;
        [self addSubview:self.tableView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMessage:) name:@"kMainTableViewHasScrollToSection2" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMessage:) name:@"kInnerTableViewHasScrollToTop" object:nil];
    }
    return self;
}

- (void)acceptMessage:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"kMainTableViewHasScrollToSection2"]) {

        if ([notification.userInfo[@"canScroll"] isEqualToString:@"1"]) {
            _canScroll = YES;
        }

    }

    if ([notification.name isEqualToString:@"kInnerTableViewHasScrollToTop"]) {
        self.tableView.contentOffset = CGPointZero;
        _canScroll = NO;
    }

}

//MARK: -
//MARK: -- UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_canScroll) {
        [self.tableView setContentOffset:CGPointZero];
    }

    //内层tableView滑到顶部时,通知外层tableView开始滑动,并将所有的内层tableView偏移量设为0
    if (scrollView.contentOffset.y < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kInnerTableViewHasScrollToTop" object:nil userInfo:@{@"canScroll" : @"1"}];
    }
}

//MARK: -
//MARK: -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
