//
//  RWPPageScrollView.m
//  RWPPageScrollView_Example
//
//  Created by a on 2020/5/3.
//  Copyright © 2020 rwpnyn@163.com. All rights reserved.
//

#import "RWPPageScrollView.h"

#import "ReactiveObjC.h"

#import "Masonry.h"

#import "RWPPageView.h"



@interface RWPPageScrollView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *scrollContentView;

@property (strong, nonatomic) RWPPageView *pageViewA;

@property (strong, nonatomic) RWPPageView *pageViewB;

@property (strong, nonatomic) RWPPageView *pageViewC;

@property (strong, nonatomic) NSTimer *timer;

@end


@implementation RWPPageScrollView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self __init];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self __init];
}

- (void)__init {
    [self addViews];
    [self makeLayouts];
    [self bindSignals];
}

- (void)addViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollContentView];
    [self.scrollContentView addSubview:self.pageViewA];
    [self.scrollContentView addSubview:self.pageViewB];
    [self.scrollContentView addSubview:self.pageViewC];
}

- (void)makeLayouts {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.scrollView.mas_height);
        make.width.mas_equalTo(self.scrollView.mas_width).multipliedBy(3);
        make.edges.mas_equalTo(self.scrollView);
    }];
    [self.pageViewA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView.mas_width);
    }];
    [self.pageViewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.pageViewA.mas_right);
        make.width.mas_equalTo(self.scrollView.mas_width);
    }];
    [self.pageViewC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.pageViewB.mas_right);
        make.width.mas_equalTo(self.scrollView.mas_width);
    }];
}

- (void)bindSignals {
    @weakify(self)
    [RACObserve(self, scrollAtIndex) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self refreshContent];
    }];
    
    [RACObserve(self, autoScrollTimeInterval) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self resetTimer];
    }];
    
    [RACObserve(self, edgeInsets) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.pageViewA.edgeInsets = self.edgeInsets;
        self.pageViewB.edgeInsets = self.edgeInsets;
        self.pageViewC.edgeInsets = self.edgeInsets;
    }];
    
    [RACObserve(self, urls) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.urls.count > 0) {
            self.scrollContentView.hidden = NO;
            [self refreshContent];
        } else {
            self.scrollContentView.hidden = NO;
        }
    }];
    
    [[self.pageViewA rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.clickAtIndex) {
            NSInteger index = self.scrollAtIndex-1;
            if (index < 0) {
                index = self.urls.count-1;
            }
            self.clickAtIndex(index);
        }
    }];
    
    [[self.pageViewB rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.clickAtIndex) {
            self.clickAtIndex(self.scrollAtIndex);
        }
    }];
    
    [[self.pageViewC rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.clickAtIndex) {
            NSInteger index = self.scrollAtIndex+1;
            if (index >= self.urls.count) {
                index = 0;
            }
            self.clickAtIndex(index);
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
}

- (void)refreshContent {
    
    if (self.scrollAtIndex < 0) {
        _scrollAtIndex = 0;
    }
    
    if (self.scrollAtIndex >= self.urls.count) {
        _scrollAtIndex = self.urls.count-1;
    }
    
    NSURL *urlA = nil;
    NSURL *urlB = nil;
    NSURL *urlC = nil;
    if (self.urls.count > 0) {
        NSInteger index1 = _scrollAtIndex-1;
        if (index1 < 0) {
            index1 = self.urls.count-1;
        }
        urlA = self.urls[index1];
        
        urlB = self.urls[_scrollAtIndex];
        
        NSInteger index3 = _scrollAtIndex+1;
        if (index3 >= self.urls.count) {
            index3 = 0;
        }
        urlC = self.urls[index3];
    }
    
    self.pageViewA.url = urlA;
    self.pageViewB.url = urlB;
    self.pageViewC.url = urlC;
}

- (void)nextPage {
    
    CGPoint p = self.scrollView.contentOffset;
    p.x += self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:p animated:YES];
}

- (void)previousPage {
    
    CGPoint p = self.scrollView.contentOffset;
    p.x -= self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:p animated:YES];
}

- (void)resetTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.autoScrollTimeInterval >= 0.5) {
        self.timer = [NSTimer timerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.scrollView.frame.size.width * 3 == self.scrollView.contentSize.width) {
        CGPoint offset = self.scrollView.contentOffset;
        CGFloat offsetX = self.scrollView.contentOffset.x;
        if (offsetX < self.scrollView.frame.size.width * 0.5) {
            offsetX += self.scrollView.frame.size.width;
            NSInteger index = self.scrollAtIndex-1;
            if (index < 0) {
                index = self.urls.count-1;
            }
            self.scrollAtIndex = index;
            offset.x = offsetX;
            self.scrollView.contentOffset = offset;
        }
        
        if (offsetX > self.scrollView.frame.size.width * 1.5) {
            offsetX -= self.scrollView.frame.size.width;
            NSInteger index = self.scrollAtIndex+1;
            if (index >= self.urls.count) {
                index = 0;
            }
            self.scrollAtIndex = index;
            offset.x = offsetX;
            self.scrollView.contentOffset = offset;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self resetTimer];
}

#pragma mark - getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIView alloc] init];
    }
    return _scrollContentView;
}

- (RWPPageView *)pageViewA {
    if (!_pageViewA) {
        _pageViewA = [[RWPPageView alloc] init];
    }
    return _pageViewA;
}

- (RWPPageView *)pageViewB {
    if (!_pageViewB) {
        _pageViewB = [[RWPPageView alloc] init];
    }
    return _pageViewB;
}

- (RWPPageView *)pageViewC {
    if (!_pageViewC) {
        _pageViewC = [[RWPPageView alloc] init];
    }
    return _pageViewC;
}

@end
