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
@property (assign, nonatomic) NSInteger currentImageNo;
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

    //设置pageControl的页数
    self.pageControl.numberOfPages = self.images.count;
    //图片宽度
    CGFloat width  = self.scrollView.frame.size.width;
    //图片高度
    CGFloat height = self.scrollView.frame.size.height;
    //设置默认首张图片编号为1
    self.currentImageNo = 1;

    CGFloat offsetX =  width, offsetY = height, offsetWidth = 0.0, offsetHeight = 0.0;
    self.dirction   == TNScrollViewDirectionHorizontal ? (offsetY     = 0)     : (offsetX      = 0);
    self.dirction   == TNScrollViewDirectionHorizontal ? (offsetWidth = width) : (offsetHeight = height);
    CGRect frame    =  CGRectMake(offsetWidth, offsetHeight, width, height);

    //设置显示的第一张图片
    if (self.images.count == 1) {
        self.scrollView.contentOffset = CGPointMake(width, 0);
        self.scrollView.scrollEnabled = NO;
    } else {
        //设置滚动范围
        if (self.dirction == TNScrollViewDirectionHorizontal) {
            [self.scrollView setContentSize:CGSizeMake(width * 3, height)];
            self.scrollView.contentOffset = CGPointMake(width, 0);
        } else if (self.dirction == TNScrollViewDirectionVertical) {
            [self.scrollView setContentSize:CGSizeMake(width, 3 * height)];
            self.scrollView.contentOffset = CGPointMake(0, height);
        }
        self.previousImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x-offsetX, frame.origin.y-offsetY, frame.size.width, frame.size.height)];
        self.lastImage     = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x+offsetX, frame.origin.y+offsetY, frame.size.width, frame.size.height)];
    }
    
    //设置第一张图片
    self.currentImage       = [[UIImageView alloc] initWithFrame:frame];
    self.currentImage.image = [UIImage imageNamed:self.images[0]];
    [self.scrollView addSubview:self.currentImage];
    //初始化previousImage
    self.previousImage.image = [UIImage imageNamed:self.images[self.images.count-1]];
    [self.scrollView addSubview:self.previousImage];

    //初始化lastImage
    if (self.images.count == 2) {
        self.lastImage.image = [UIImage imageNamed:self.images[self.images.count-1]];
    } else {
        self.lastImage.image = [UIImage imageNamed:self.images[1]];
    }
    [self.scrollView addSubview:self.lastImage];
    
    if (self.autoShow) {
        [self setTimeInterval: self.timeInterval];
    }

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
    if (self.scrollView.contentOffset.x < (self.scrollView.frame.size.width / 2)) {
        self.pageControl.currentPage --;
    }else if (self.scrollView.contentOffset.x < (self.scrollView.frame.size.width / 2)*5) {
        self.pageControl.currentPage --;
    }
    //重置定时器
    [self addTimer];
}

//手指开始滑动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //使定时器失效
    [self.timer invalidate];
}

#pragma mark - tool methods

-(void)changeOffset {
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    CGFloat offsetX = self.currentImage.frame.origin.x;
    CGFloat offsetY = self.currentImage.frame.origin.y;

    CGPoint contentOffset;
    CGFloat x = 0, y = 0;
    self.dirction == TNScrollViewDirectionVertical ? (y = height) : (x = width);

    contentOffset = (CGPoint) {offsetX + x, offsetY + y};
    //计算当前页是第几页
    self.pageControl.currentPage = self.currentImageNo % self.images.count;
    //设置当前指向第几张图片
    self.currentImageNo = (self.currentImageNo+1) % self.images.count;
    
    [UIView animateWithDuration:1.5 animations:^{
        self.scrollView.contentOffset = contentOffset;
    }];
    
    //重设scrollView中的各个image
    self.currentImage.image = [UIImage imageNamed:self.images[self.currentImageNo]];
    self.scrollView.contentOffset = (CGPoint){offsetX, offsetY};
    self.previousImage.image = [UIImage imageNamed:self.images[(self.currentImageNo-1+self.images.count) % self.images.count]];
    self.lastImage.image = [UIImage imageNamed:self.images[(self.currentImageNo+1) % self.images.count]];
    
    
}

-(void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(changeOffset) userInfo:nil repeats:YES];
}

@end
