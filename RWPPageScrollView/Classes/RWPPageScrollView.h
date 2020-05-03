//
//  RWPPageScrollView.h
//  RWPPageScrollView_Example
//
//  Created by a on 2020/5/3.
//  Copyright © 2020 rwpnyn@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RWPPageScrollView : UIView

/// 当前滑动到了第几页
@property (assign, nonatomic) NSInteger scrollAtIndex;

/// 自动滑动的间隔时间，小于0.5表示不自动滑动
@property (assign, nonatomic) NSTimeInterval autoScrollTimeInterval;

/// 内容的上下左右边距
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

/// 图片链接
@property (strong, nonatomic) NSArray<NSURL *> *urls;

/// 点击图片回调
@property (copy, nonatomic) void(^clickAtIndex)(NSInteger index);

/// 下一页
- (void)nextPage;

/// 上一页
- (void)previousPage;

@end

