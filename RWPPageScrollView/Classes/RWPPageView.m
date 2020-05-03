//
//  RWPPageView.m
//  RWPPageScrollView_Example
//
//  Created by a on 2020/5/3.
//  Copyright © 2020 rwpnyn@163.com. All rights reserved.
//

#import "RWPPageView.h"

#import "ReactiveObjC.h"

#import "Masonry.h"

#import "SDWebImage.h"


@interface RWPPageView ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation RWPPageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
        [self makeLayouts];
        [self bindSignals];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.imageView];
}

- (void)makeLayouts {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.edgeInsets.left);
        make.top.mas_equalTo(self.edgeInsets.top);
        make.right.mas_equalTo(self.edgeInsets.right);
        make.bottom.mas_equalTo(self.edgeInsets.bottom);
    }];
}

- (void)bindSignals {
    @weakify(self)
    [RACObserve(self, edgeInsets) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.edgeInsets.left);
            make.top.mas_equalTo(self.edgeInsets.top);
            make.right.mas_equalTo(-self.edgeInsets.right);
            make.bottom.mas_equalTo(-self.edgeInsets.bottom);
        }];
    }];
    [RACObserve(self, url) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.imageView sd_setImageWithURL:self.url placeholderImage:[UIImage imageNamed:@""]];
    }];
}


#pragma mark - getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}


@end
