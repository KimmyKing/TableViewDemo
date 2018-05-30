//
//  MainScrollView.m
//  TableViewDemo
//
//  Created by Cain on 2018/5/30.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

#import "MainView.h"
#import "ButtonView.h"
#import "BaseItemView.h"

@interface MainView () <UIScrollViewDelegate>

@property (nonatomic , strong)ButtonView *buttonView;

@property (nonatomic , strong)UIScrollView *scrollView;

@property (nonatomic , strong)NSArray *dataArray;

@property (nonatomic , strong)NSArray *titleArray;

@end

@implementation MainView

- (instancetype)initWithDataArray:(NSArray *)dataArray
{
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 60 - 60)]) {
        
        self.dataArray = dataArray;
        
        [self addSubview:self.buttonView];
        
        [self addSubview:self.scrollView];
    }
    return self;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, UIScreen.mainScreen.bounds.size.width, [UIScreen mainScreen].bounds.size.height - 60 - 60 - 45)];
        _scrollView.contentSize = CGSizeMake(self.dataArray.count * UIScreen.mainScreen.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate =self;
        
        for (int i = 0; i < self.dataArray.count; i++) {
            NSDictionary *dic = self.dataArray[i];
            NSString *className = dic[@"view"];
            Class class = NSClassFromString(className);
            BaseItemView *itemView = [[class alloc] initWithDic:dic];
            [_scrollView addSubview:itemView];
        }
        
    }
    return _scrollView;
}

- (ButtonView *)buttonView
{
    if (!_buttonView) {
        _buttonView = [[ButtonView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 45) titleArray:self.titleArray];
        __weak typeof(self) weakSelf = self;
        _buttonView.clickBtnBlock = ^(NSInteger tag) {
            [weakSelf.scrollView setContentOffset:CGPointMake(tag * UIScreen.mainScreen.bounds.size.width, 0)];
        };
    }
    return _buttonView;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        NSMutableArray *marr = [NSMutableArray array];
        for (int i = 0; i < self.dataArray.count; i++) {
            NSDictionary *dic = self.dataArray[i];
            [marr addObject:dic[@"title"]];
        }
        _titleArray = marr.copy;
    }
    return _titleArray;
}

@end
