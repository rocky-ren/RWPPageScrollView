//
//  RWPViewController.m
//  RWPPageScrollView
//
//  Created by rwpnyn@163.com on 05/03/2020.
//  Copyright (c) 2020 rwpnyn@163.com. All rights reserved.
//

#import "RWPViewController.h"

#import "RWPPageScrollView.h"

#import "ReactiveObjC.h"

#import "Masonry.h"

#import "RWPPageScrollView+PageContol.h"

@interface RWPViewController ()

@property (weak, nonatomic) IBOutlet RWPPageScrollView *scrollPageView;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;

@end

@implementation RWPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollPageView.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.scrollPageView.urls = @[
    [NSURL URLWithString:@"http://0.image.al.okbuycdn.com/org/static/b581859748a126ead2419b3ffddcc1a3.jpg"],
    [NSURL URLWithString:@"http://0.image.al.okbuycdn.com/org/static/1efd3dc2efd0c74cf496e7f7955a6445.jpg"],
    [NSURL URLWithString:@"http://0.image.al.okbuycdn.com/org/static/170b2a13ad6fdfafb5cb1581aad9694a.jpg"],
    [NSURL URLWithString:@"http://0.image.al.okbuycdn.com/org/static/8f05b91b98c41e7035d11a0125c9a393.jpg"],
    [NSURL URLWithString:@"http://0.image.al.okbuycdn.com/org/static/9625e86b00cbaf90410d4656c8f0bbf1.jpg"]
    ];
    self.scrollPageView.autoScrollTimeInterval = 3;
    
    @weakify(self)
    [RACObserve(self.scrollPageView, scrollAtIndex) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.lbl.text = @(self.scrollPageView.scrollAtIndex).stringValue;
    }];
    
    [self.scrollPageView setClickAtIndex:^(NSInteger index) {
        @strongify(self)
        self.lbl1.text = @(index).stringValue;
    }];
    
    [self.scrollPageView showPageControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
