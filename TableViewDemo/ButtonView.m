//
//  ButtonView.m
//  TableViewDemo
//
//  Created by Cain on 2018/5/30.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

#import "ButtonView.h"

@interface ButtonView ()

@property (nonatomic , strong)UIView *line;

@end

@implementation ButtonView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.magentaColor;
        
        CGFloat btnW = UIScreen.mainScreen.bounds.size.width / 3;
        for (int i = 0; i < titleArray.count; i++) {
            CGFloat btnX = btnW * i;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, 0, btnW, 45)];
            btn.tag = i;
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
            [btn setTitleColor:UIColor.redColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            if (btn.tag == 0) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
            
        }
    }
    return self;
}

- (void)clickBtn:(UIButton *)sender
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isKindOfClass:UIButton.class]) {
            UIButton *btn = (UIButton *)obj;
            if (btn.tag == sender.tag) {
                btn.selected = YES;
                if (self.clickBtnBlock) {
                    self.clickBtnBlock(sender.tag);
                }
            }else{
                btn.selected = NO;
            }
        }
        
    }];
}

@end
