//
//  HQBannerView.m
//  HQBannerView
//
//  Created by admin on 2018/3/20.
//  Copyright © 2018年 HaiQiang. All rights reserved.
//

#import "HQBannerView.h"
#import "UIImageView+WebCache.h"

#define KScreenWidth [[UIScreen mainScreen]bounds].size.width

@interface HQBannerPageText : UIView
@property (nonatomic,   copy) NSString *PageText;
@property (nonatomic, strong) UILabel *fontBannerPageTextLabel;
@property (nonatomic, strong) UILabel *backBannerPageTextLabel;
@end

@implementation HQBannerPageText

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor] ;
        self.layer.cornerRadius = self.bounds.size.height/2;
        self.layer.masksToBounds = YES;
        
        self.fontBannerPageTextLabel = [[UILabel alloc] initWithFrame:[self bounds]];
        self.fontBannerPageTextLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.fontBannerPageTextLabel];
        
        self.backBannerPageTextLabel = [[UILabel alloc] initWithFrame:[self bounds]];
        self.backBannerPageTextLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.backBannerPageTextLabel];
        
        self.backBannerPageTextLabel.hidden = YES;
        
    }
    return self;
}
- (void)setPageText:(NSString *)PageText{
    _PageText = PageText;
    NSInteger gangLoc = [PageText rangeOfString:@"/"].location;
    BOOL isHas =  gangLoc == NSNotFound;
    NSAssert(isHas == NO, @"文字显示格式要带/");
    NSMutableAttributedString *muString = [[NSMutableAttributedString alloc] initWithString:PageText];
    [muString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, gangLoc)];
    [muString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(gangLoc, PageText.length-gangLoc)];
    self.fontBannerPageTextLabel.attributedText = muString;
    self.backBannerPageTextLabel.attributedText = muString;
}

@end

@interface HQCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation HQCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = self.bounds;
    self.imageView = imageView;
    [self.contentView addSubview:imageView];
}
@end

NSString * const reuseID = @"bannerCell";

@interface HQBannerView () <UIScrollViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) HQBannerPageText *bannerPageText;
@end

@implementation HQBannerView

+ (instancetype)bannerViewWithFrame:(CGRect)frame delegate:(id<HQBannerViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage {
    HQBannerView *bannerView = [[HQBannerView alloc] initWithFrame:frame];
    bannerView.delegate = delegate;
    bannerView.placeholderImage = placeholderImage;
    return bannerView;
}

+ (instancetype)bannerViewWithFrame:(CGRect)frame imageURLArray:(NSArray *)imageURLArray {
    HQBannerView *bannerView = [[HQBannerView alloc] initWithFrame:frame];
    bannerView.imageURLArray = imageURLArray;
    return bannerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupMainView];
        
    }
    return self;
}

// 设置显示图片的collectionView
- (void)setupMainView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = self.bounds.size;
    _flowLayout = flowLayout;
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[HQCollectionViewCell class] forCellWithReuseIdentifier:reuseID];
    mainView.dataSource = self;
    mainView.delegate = self;
    mainView.scrollsToTop = NO;
    [self addSubview:mainView];
    _mainView = mainView;
}

- (void)setupPageText {
    CGFloat width = 45;
    CGFloat height = 25;
    HQBannerPageText *bannerPageText = [[HQBannerPageText alloc] initWithFrame:CGRectMake(self.frame.size.width - 15-width, self.frame.size.height - 15 - height, width, height)];
    _bannerPageText = bannerPageText;
    bannerPageText.PageText = [NSString stringWithFormat:@"1/%ld",(unsigned long)self.imageURLArray.count];
    [self setPageText];
    [self addSubview:_bannerPageText];
}

- (void)setPageTextAliment:(HQBannerViewPageTextAliment)pageTextAliment {
    if (_bannerPageText) {
        [_bannerPageText removeFromSuperview];// 重新加载数据时调整
    }
    if (self.imageURLArray.count == 0) return;
    if ((self.imageURLArray.count == 1) && self.hidesForSinglePage) return;
    CGFloat width = 45;
    CGFloat height = 25;
    switch (pageTextAliment) {
        case HQBannerViewPageTextAlimentRight: {
            _bannerPageText = [[HQBannerPageText alloc] initWithFrame:CGRectMake(self.frame.size.width - 15-width, self.frame.size.height - 15 - height, width, height)];
            _bannerPageText.PageText = [NSString stringWithFormat:@"1/%ld",(unsigned long)self.imageURLArray.count];
            [self addSubview:_bannerPageText];
        }
            break;
        case HQBannerViewPageTextAlimentCenter: {
            _bannerPageText = [[HQBannerPageText alloc] initWithFrame:CGRectMake((self.frame.size.width-width)/2, self.frame.size.height - 15 - height, width, height)];
            _bannerPageText.PageText = [NSString stringWithFormat:@"1/%ld",(unsigned long)self.imageURLArray.count];
            [self addSubview:_bannerPageText];
        }
            break;
        default:
            break;
    }
    [self setPageText];
}

//调用setPageText后后显示默认的字体、颜色、背景色，需要调用次方法
- (void)setPageText {
    if (self.pageTextBackgroundColor) {
        _bannerPageText.backgroundColor = self.pageTextBackgroundColor;
    }
    if (self.pageTextFont) {
        self.bannerPageText.fontBannerPageTextLabel.font = self.pageTextFont;
        self.bannerPageText.backBannerPageTextLabel.font = self.pageTextFont;
    }
    if (self.pageTextColor) {
        self.bannerPageText.fontBannerPageTextLabel.textColor = self.pageTextColor;
        self.bannerPageText.backBannerPageTextLabel.textColor = self.pageTextColor;
    }
}

//设置图片数组
- (void)setImageURLArray:(NSArray *)imageURLArray {
    _imageURLArray = imageURLArray;
    [self.mainView reloadData];
    [self setupPageText];
}

//设置当前的index
- (void)setCurrentPageIndex:(NSInteger)currentPageIndex{
    _currentPageIndex = currentPageIndex;
    
    self.bannerPageText.PageText = [NSString stringWithFormat:@"%@/%@",@(_currentPageIndex+1),@(self.imageURLArray.count)];
    if (_currentPageIndex%2==0) {
        //如果是偶数
        self.bannerPageText.fontBannerPageTextLabel.hidden = NO;
        self.bannerPageText.backBannerPageTextLabel.hidden = YES;
    }else{
        //如果是奇数
        self.bannerPageText.fontBannerPageTextLabel.hidden = YES;
        self.bannerPageText.backBannerPageTextLabel.hidden = NO;
    }
    
    [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentPageIndex inSection:0]
                          atScrollPosition:UICollectionViewScrollPositionNone
                                  animated:NO];
}

- (void)setPageTextBackgroundColor:(UIColor *)pageTextBackgroundColor {
    _pageTextBackgroundColor = pageTextBackgroundColor;
    self.bannerPageText.backgroundColor = pageTextBackgroundColor;
}

- (void)setPageTextColor:(UIColor *)pageTextColor {
    _pageTextColor = pageTextColor;
    self.bannerPageText.fontBannerPageTextLabel.textColor = pageTextColor;
    self.bannerPageText.backBannerPageTextLabel.textColor = pageTextColor;
}

- (void)setPageTextFont:(UIFont *)pageTextFont {
    _pageTextFont = pageTextFont;
    self.bannerPageText.fontBannerPageTextLabel.font = pageTextFont;
    self.bannerPageText.backBannerPageTextLabel.font = pageTextFont;
}

- (int)currentIndex {
    if (_mainView.bounds.size.width == 0 || _mainView.bounds.size.height == 0) {
        return 0;
    }
    
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    } else {
        index = (_mainView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    return MAX(0, index);
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageURLArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HQCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    NSString *imagePath = self.imageURLArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(banner:didSelectItemAtIndex:)]) {
        [self.delegate banner:self didSelectItemAtIndex:indexPath.row];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.imageURLArray.count) return;
    int itemIndex = [self currentIndex];
    int indexOnPageControl = itemIndex % self.imageURLArray.count;
    self.bannerPageText.PageText = [NSString stringWithFormat:@"%@/%@",@(indexOnPageControl+1),@(self.imageURLArray.count)];
    [self setPageText];
}

//减速停止的时候开始执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / KScreenWidth;
    if ([self.delegate respondsToSelector:@selector(banner:currentItemAtIndex:)]) {
        [self.delegate banner:self currentItemAtIndex:index];
    }
}
//停止拖拽的时候开始执行
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger count_for_image = self.imageURLArray.count;
    CGFloat total_value = (float)(count_for_image-1)*self.bounds.size.width;
    if (offsetX >= total_value) {
        if ([self.delegate respondsToSelector:@selector(banner:scrollToLastIndex:)]) {
            [self.delegate banner:self scrollToLastIndex:count_for_image];
        }
    }
}

@end
