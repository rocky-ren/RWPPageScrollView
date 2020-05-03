//
//  RWPPageScrollView+PageContol.m
//  RWPPageScrollView_Example
//
//  Created by a on 2020/5/3.
//  Copyright © 2020 rwpnyn@163.com. All rights reserved.
//

#import "RWPPageScrollView+PageContol.h"

#import <objc/runtime.h>

#import "ReactiveObjC.h"

#import "Masonry.h"

@implementation RWPPageScrollView (PageContol)

- (void)showPageControl {
    if (!self.pageControl) {
        UIPageControl *pageContol = [[UIPageControl alloc] init];
        pageContol.enabled = NO;
        [self addSubview:pageContol];
        
        @weakify(pageContol)
        @weakify(self)
        [RACObserve(self, scrollAtIndex) subscribeNext:^(id  _Nullable x) {
            @strongify(pageContol)
            pageContol.currentPage = self.scrollAtIndex;
        }];
        
        [RACObserve(self, edgeInsets) subscribeNext:^(id  _Nullable x) {
            @strongify(pageContol)
            [pageContol mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.edgeInsets.left);
                make.right.mas_equalTo(-self.edgeInsets.right);
                make.bottom.mas_equalTo(-self.edgeInsets.bottom);
                make.height.mas_equalTo(40);
            }];
        }];
        
        [RACObserve(self, urls) subscribeNext:^(id  _Nullable x) {
            @strongify(pageContol)
            pageContol.numberOfPages = self.urls.count;
        }];
        
        [[pageContol rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(pageContol)
            @strongify(self)
            if (self.scrollAtIndex < pageContol.currentPage) {
                [self nextPage];
            }
            if (self.scrollAtIndex > pageContol.currentPage) {
                [self previousPage];
            }
        }];
        
        self.pageControl = pageContol;
    }
    self.pageControl.hidden = NO;
}


#pragma mark - getter setter
- (void)setPageControl:(UIPageControl *)pageControl {
    objc_setAssociatedObject(self, @selector(pageControl), pageControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPageControl *)pageControl {
    return objc_getAssociatedObject(self, @selector(pageControl));
}


@end
