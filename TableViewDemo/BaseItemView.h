//
//  BaseItemView.h
//  TableViewDemo
//
//  Created by Cain on 2018/5/30.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseItemView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong)UITableView *tableView;

@property (nonatomic , copy)NSDictionary *dic;

@property (nonatomic , assign)BOOL canScroll;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
