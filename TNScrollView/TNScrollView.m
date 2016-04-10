//
//  TNScrollView.m
//  TNScrollView
//
//  Created by Terry on 4/9/16.
//  Copyright © 2016 Terry. All rights reserved.
//

#import "TNScrollView.h"

#pragma mark - extension

@interface TNScrollView () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@end


@implementation TNScrollView

#pragma mark - calss factory method

+(instancetype)scrollView {
    TNScrollView *sc = [[TNScrollView alloc] init];
    return sc;
}

+(instancetype)scrollViewWithFrame:(CGRect)frame{
    TNScrollView *sc = [[TNScrollView alloc] initWithFrame:frame];
    return sc;
}

+(instancetype)scrollViewWithFrame:(CGRect)frame andDirection:(TNScrollViewDirection)direction{
    TNScrollView *sc = [[TNScrollView alloc] initWithFrame:frame andDirection:direction];
    return sc;
}

#pragma mark - init

-(instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TNScrollView" owner:nil options:nil] lastObject];
        //set TNScrollView as scrollView's delegate
        self.scrollView.delegate = self;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TNScrollView" owner:nil options:nil] lastObject];
        self.frame = frame;
        self.scrollView.frame = self.bounds;
        //set TNScrollView as scrollView's delegate
        self.scrollView.delegate = self;
    }
    return self;
}

/*!
 *  init with direction
 *  @return TNScrollView
 */
-(instancetype)initWithFrame:(CGRect)frame andDirection:(TNScrollViewDirection)direction {
    self = [self initWithFrame:frame];
    self.dirction = direction;
    return self;
}

#pragma mark - setMethod

-(void)setImages:(NSArray *)images {
    _images = images;
    
    //set pageControl's pages number
    self.pageControl.numberOfPages = self.images.count;
    //content width
    CGFloat width = self.scrollView.frame.size.width;
    //content height
    CGFloat height = self.scrollView.frame.size.height;
    
    //set scroll content size
    if (self.dirction == TNScrollViewDirectionVertical) {
        [self.scrollView setContentSize:(CGSize){width, height * self.images.count}];
    }else {
        [self.scrollView setContentSize:(CGSize){width * self.images.count, height}];
    }
    
    //load images
    for (int i = 0; i < self.images.count; i++) {
        UIImageView *imageView;
        
        //scroll on horizen or vertica direction
        if (self.dirction == TNScrollViewDirectionVertical) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, i * height, width, height)];
        }else {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        }
        
        //add imageView to ScrollView
        imageView.image = [UIImage imageNamed:self.images[i]];
        [self.scrollView addSubview:imageView];
    }
}

-(void)setTimeInterval:(CGFloat)timeInterval {
    _timeInterval = timeInterval;
    [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(changeOffset) userInfo:nil repeats:YES];
}

#pragma mark - <UIScrollViewDelegate>

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //calculate the current page's index
    NSInteger currentPageIndex = (self.scrollView.contentOffset.x + (self.scrollView.frame.size.width / 2)) / self.scrollView.frame.size.width;
    self.pageControl.currentPage = currentPageIndex;
}

#pragma mark - tool methods

/*!
 *  set subviews of scroll view to avoid memory leak
 *  @param subviews subviews of scrollView
 *  @param array    images array
 */
-(void)setSubviews:(NSMutableArray *)subviews fromIndex:(NSInteger)start toIndex:(NSInteger)end withArray:(NSArray *)array {
    for (; start < end; start++) {
        [subviews[start] setImage:[UIImage imageNamed:array[start]]];
    }
}

-(void)scrollViewScrollAutomaticallyInTimeInterval:(NSInteger)timeInterval withScrollStyle:(TNScrollViewScrollStyle)style {
    if (self.timeInterval > 0 && style == TNScrollViewScrollStyleInfinite) {
        
    }else if (self.timeInterval > 0 && style == TNScrollViewScrollStyleReverse){
        
    }
}

-(void)scrollViewScrollWithStyle:(TNScrollViewScrollStyle)style {
    if (style == TNScrollViewScrollStyleInfinite) {
        //水平方向布局
        if (self.dirction == TNScrollViewDirectionHorizontal) {
            [self changeOffset];
        }else if (self.dirction == TNScrollViewDirectionVertical) {
            //垂直布局
            [self changeOffset];
        }
    }else if (style == TNScrollViewScrollStyleReverse) {
        
    }
}

-(void)changeOffset {
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGPoint contentOffset;
    CGFloat x , y;
    if (_dirction == TNScrollViewDirectionVertical) {
        x = 0;
        y = height;
    }else {
        x = width;
        y = 0;
    }
    //判断当前页是否为最后一页
    if (offsetX < width * (self.images.count-1) && offsetY < height * (self.images.count-1)) {
        contentOffset = (CGPoint){offsetX + x, offsetY + y};
        self.pageControl.currentPage += 1;
    }else {
        contentOffset = (CGPoint){0,0};
        self.pageControl.currentPage = 0;
    }
    [UIView animateWithDuration:1.5 animations:^{
        self.scrollView.contentOffset = contentOffset;
    }];
}

@end
