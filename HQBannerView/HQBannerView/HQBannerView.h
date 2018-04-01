//
//  HQBannerView.h
//  HQBannerView
//
//  Created by admin on 2018/3/20.
//  Copyright © 2018年 HaiQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HQBannerViewPageTextAlimentRight = 1,
    HQBannerViewPageTextAlimentCenter
}HQBannerViewPageTextAliment;

@class HQBannerView;

@protocol HQBannerViewDelegate <NSObject>

@optional
//点击banner图
- (void)banner:(HQBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index;
//当前的banner图
- (void)banner:(HQBannerView *)bannerView currentItemAtIndex:(NSInteger)index;
//滑动到最后一页
- (void)banner:(HQBannerView *)bannerView scrollToLastIndex:(NSInteger)lastIndex;

@end

@interface HQBannerView : UIView

/** 初始轮播图（推荐使用） */
+ (instancetype)bannerViewWithFrame:(CGRect)frame delegate:(id<HQBannerViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;

+ (instancetype)bannerViewWithFrame:(CGRect)frame imageURLArray:(NSArray *)imageURLArray;


@property (nonatomic, assign) id<HQBannerViewDelegate> delegate;
/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray *imageURLArray;
/** 默认进入第几张图 */
@property (nonatomic, assign) NSInteger currentPageIndex;
/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;
/** 页数颜色 */
@property (nonatomic, strong) UIColor *pageTextColor;
/** 页数背景色 */
@property (nonatomic, strong) UIColor *pageTextBackgroundColor;
/** 页数文字大小 */
@property (nonatomic, strong) UIFont  *pageTextFont;
/** 页数文字位置 */
@property (nonatomic, assign) HQBannerViewPageTextAliment pageTextAliment;
/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property (nonatomic, assign) BOOL hidesForSinglePage;

@end
