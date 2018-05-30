//
//  ButtonView.h
//  TableViewDemo
//
//  Created by Cain on 2018/5/30.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonView : UIView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;

@property (nonatomic , copy)void(^clickBtnBlock)(NSInteger tag);

@end
