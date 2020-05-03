# RWPPageScrollView

[![CI Status](https://img.shields.io/travis/rwpnyn@163.com/RWPPageScrollView.svg?style=flat)](https://travis-ci.org/rwpnyn@163.com/RWPPageScrollView)
[![Version](https://img.shields.io/cocoapods/v/RWPPageScrollView.svg?style=flat)](https://cocoapods.org/pods/RWPPageScrollView)
[![License](https://img.shields.io/cocoapods/l/RWPPageScrollView.svg?style=flat)](https://cocoapods.org/pods/RWPPageScrollView)
[![Platform](https://img.shields.io/cocoapods/p/RWPPageScrollView.svg?style=flat)](https://cocoapods.org/pods/RWPPageScrollView)

## Example

    // 设置内容与边框的间距
    self.scrollPageView.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // 设置图片的URL
    self.scrollPageView.urls = @[
        [NSURL URLWithString:@"http://0.image.al.okbuycdn.com/org/static/b581859748a126ead2419b3ffddcc1a3.jpg"],
        [NSURL URLWithString:@"http://0.image.al.okbuycdn.com/org/static/1efd3dc2efd0c74cf496e7f7955a6445.jpg"],
        [NSURL URLWithString:@"http://0.image.al.okbuycdn.com/org/static/170b2a13ad6fdfafb5cb1581aad9694a.jpg"],
        [NSURL URLWithString:@"http://0.image.al.okbuycdn.com/org/static/8f05b91b98c41e7035d11a0125c9a393.jpg"],
        [NSURL URLWithString:@"http://0.image.al.okbuycdn.com/org/static/9625e86b00cbaf90410d4656c8f0bbf1.jpg"]];
    
    // 设置自动轮播时间
    self.scrollPageView.autoScrollTimeInterval = 3;
    
    // 监听点击事件
    @weakify(self)
    [self.scrollPageView setClickAtIndex:^(NSInteger index) {
        @strongify(self)
        // do something
    }];



## Requirements

## Installation

RWPPageScrollView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RWPPageScrollView', :git => 'https://github.com/rocky-ren/RWPPageScrollView.git'
```

## Author

rwpnyn@163.com, rwpnyn@163.com

## License

禁制强制996的公司使用！
RWPPageScrollView is available under the MIT license. See the LICENSE file for more info.
