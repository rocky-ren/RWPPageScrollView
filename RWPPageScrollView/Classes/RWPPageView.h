//
//  RWPPageView.h
//  RWPPageScrollView_Example
//
//  Created by a on 2020/5/3.
//  Copyright © 2020 rwpnyn@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RWPPageView : UIControl

/// 内容的上下左右边距
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

@property (strong, nonatomic) NSURL *url;

@end

