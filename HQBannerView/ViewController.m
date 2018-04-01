//
//  ViewController.m
//  HQBannerView
//
//  Created by admin on 2018/3/20.
//  Copyright © 2018年 HaiQiang. All rights reserved.
//

#import "ViewController.h"
#import "HQBannerView.h"

@interface ViewController ()<HQBannerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    HQBannerView *bannerView = [HQBannerView bannerViewWithFrame:CGRectMake(10, 20, self.view.bounds.size.width - 20, 200) delegate:self placeholderImage:[UIImage imageNamed:@"banner_placehold"]];
//    bannerView.backgroundColor = [UIColor blueColor];
    bannerView.imageURLArray = @[@"http://api.taohaohuo365.com/uploads/images/1UVKwCWlmd1521022901.png", @"http://api.taohaohuo365.com/uploads/images/vS2t4nzGO11520853221.png", @"http://api.taohaohuo365.com/uploads/images/1UVKwCWlmd1521022901.png"];
    bannerView.pageTextBackgroundColor = [UIColor lightTextColor];
    bannerView.pageTextFont = [UIFont systemFontOfSize:13];
    bannerView.pageTextColor = [UIColor grayColor];
    bannerView.pageTextAliment = HQBannerViewPageTextAlimentCenter;
    [self.view addSubview:bannerView];
    
    HQBannerView *bannerView1 = [HQBannerView bannerViewWithFrame:CGRectMake(10, 240, self.view.bounds.size.width - 20, 200) delegate:self placeholderImage:[UIImage imageNamed:@"banner_placehold"]];
    //    bannerView.backgroundColor = [UIColor blueColor];
    bannerView1.imageURLArray = @[@"http://api.taohaohuo365.com/uploads/images/1UVKwCWlmd1521022901.png", @"http://api.taohaohuo365.com/uploads/images/vS2t4nzGO11520853221.png", @"http://api.taohaohuo365.com/uploads/images/1UVKwCWlmd1521022901.png"];
    bannerView1.pageTextBackgroundColor = [UIColor lightTextColor];
    bannerView1.pageTextFont = [UIFont systemFontOfSize:13];
    bannerView1.pageTextColor = [UIColor grayColor];
    bannerView1.pageTextAliment = HQBannerViewPageTextAlimentRight;
    [self.view addSubview:bannerView1];
}

- (void)banner:(HQBannerView *)bannerView scrollToLastIndex:(NSInteger)lastIndex {
    NSLog(@"last%ld", lastIndex);
}

- (void)banner:(HQBannerView *)bannerView currentItemAtIndex:(NSInteger)index {
    NSLog(@"current%ld", index);
}

- (void)banner:(HQBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"selectedt%ld", index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
