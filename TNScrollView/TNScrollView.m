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
@property (strong, nonatomic) UIImageView *previousImage;
@property (strong, nonatomic) UIImageView *currentImage;
@property (strong, nonatomic) UIImageView *lastImage;
@property (retain, nonatomic) NSTimer *timer;
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
    CGFloat width, height;
    self.dirction == TNScrollViewDirectionHorizontal ? (height = 0) : (width = 0);
    
    self.previousImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x-width, frame.origin.y-height, frame.size.width, frame.size.height)];
    self.previousImage = [[UIImageView alloc] initWithFrame:frame];
    self.previousImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x+width, frame.origin.y+height, frame.size.width, frame.size.height)];
  
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
    if (self.images.count==1) {
        [self.scrollView setContentSize:(CGSize){width, height}];
        self.scrollView.contentOffset = CGPointMake(width, 0);
    }else if (self.images.count == 2) {
        if (self.dirction == TNScrollViewDirectionVertical) {
            [self.scrollView setContentSize:(CGSize){width, 2*height}];
            self.scrollView.contentOffset = CGPointMake(width, 0);
        }else {
            [self.scrollView setContentSize:(CGSize){2*width, height}];
        }
    }else {
        if (self.dirction == TNScrollViewDirectionVertical) {
            [self.scrollView setContentSize:(CGSize){width, 3*height}];
            self.scrollView.contentOffset = CGPointMake(width, 0);
        }else {
            [self.scrollView setContentSize:(CGSize){3*width, height}];
        }
    }
    
//    //load images
//    for (int i = 0; i < self.images.count; i++) {
//        UIImageView *imageView;
//        
//        //scroll on horizen or vertica direction
//        if (self.dirction == TNScrollViewDirectionVertical) {
//            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, i * height, width, height)];
//        }else {
//            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
//        }
//        
//        //add imageView to ScrollView
//        imageView.image = [UIImage imageNamed:self.images[i]];
//        [self.scrollView addSubview:imageView];
//    }
    
    self.previousImage.image = [UIImage imageNamed:self.images[self.images.count-1]];
    [self.scrollView addSubview:self.previousImage];
//    if (self.images.count == 2) {
//        self.currentImage.image = [UIImage imageNamed:self.images[0]];
//        [self.scrollView addSubview:self.currentImage];
//    }else if (self.images.count > 2) {
//        self.lastImage.image = [UIImage imageNamed:self.images[1]];
//        [self.scrollView addSubview:self.lastImage];
//    }
}

//设置时间间隔
-(void)setTimeInterval:(CGFloat)timeInterval {
    _timeInterval = timeInterval;
    [self addTimer];
}

#pragma mark - <UIScrollViewDelegate>
//手指滑动结束
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //计算当前页号
    NSInteger currentPageIndex = (self.scrollView.contentOffset.x + (self.scrollView.frame.size.width / 2)) / self.scrollView.frame.size.width;
    self.pageControl.currentPage = currentPageIndex;
    //重置定时器
    [self addTimer];
}

//手指开始滑动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //使定时器失效
    [self.timer invalidate];
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

//-(void)scrollViewScrollWithStyle:(TNScrollViewScrollStyle)style {
//    if (style == TNScrollViewScrollStyleInfinite) {
//        //水平方向布局
//        if (self.dirction == TNScrollViewDirectionHorizontal) {
//            [self changeOffset];
//        }else if (self.dirction == TNScrollViewDirectionVertical) {
//            //垂直布局
//            [self changeOffset];
//        }
//    }else if (style == TNScrollViewScrollStyleReverse) {
//        
//    }
//}

-(void)changeOffset {
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGPoint contentOffset;
    CGFloat x = 0, y = 0;
    self.dirction == TNScrollViewDirectionVertical ? (y = height) : (x = width);

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

-(void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(changeOffset) userInfo:nil repeats:YES];
}

@end
