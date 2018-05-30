//
//  MainTableView.m
//  TableViewDemo
//
//  Created by Cain on 2018/5/30.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

#import "MainTableView.h"

@implementation MainTableView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    //如果交互事件发生在tableHeaderView上,就继续向下传递
    if (self.tableHeaderView && CGRectContainsPoint(self.tableHeaderView.frame, point)) {
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

//MARK: -
//MARK: -- 主要是为了让外层的UITableView能够显示外层UITableView的滑动事件。我们需要实现以下代理方法。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
