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
@property (weak, nonatomic)   IBOutlet    UIScrollView   *scrollView ;
@property (weak, nonatomic)   IBOutlet    UIPageControl  *pageControl;
@property (strong, nonatomic) UIImageView *previousImage;
@property (strong, nonatomic) UIImageView *currentImage;
@property (strong, nonatomic) UIImageView *lastImage;
@property (retain, nonatomic) NSTimer     *timer;
@property (assign, nonatomic) NSInteger   currentImageNo;

@property(assign, nonatomic)  CGFloat     width   ;   
@property(assign, nonatomic)  CGFloat     height  ;  
@property(assign, nonatomic)  CGFloat     offsetX ; 
@property(assign, nonatomic)  CGFloat     offsetY ;
@property(assign, nonatomic)  NSInteger   count   ;
@end

@implementation TNScrollView

#pragma mark - init / calss factory method
+(instancetype)scrollView {
    TNScrollView *sc = [[TNScrollView alloc] init];
    return sc;
}

+(instancetype)scrollViewWithFrame:(CGRect)frame andDirection:(TNScrollViewDirection)direction{
    TNScrollView *sc = [[TNScrollView alloc] initWithFrame:frame andDirection:direction];
    return sc;
}

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
    _count = _images.count;

    //设置pageControl的页数
    self.pageControl.numberOfPages = _count;
    //imageView宽度
    _width   = self.scrollView.frame.size.width ;
    //imageView高度
    _height  = self.scrollView.frame.size.height;
    //设置默认首张图片编号为1
    self.currentImageNo = 0;

    CGFloat offsetX = _width, 
            offsetY = _height;
    self.dirction   == TNScrollViewDirectionHorizontal ? (offsetY = 0) : (offsetX = 0);
    CGRect frame    =  CGRectMake(offsetX, offsetY, _width, _height);

    //判断图片总数
    if (_count == 1) {
        self.scrollView.contentOffset = CGPointMake(_width, 0);
        self.scrollView.scrollEnabled = NO;
    } else {
        //设置滚动范围
        if (self.dirction == TNScrollViewDirectionHorizontal) {
            [self.scrollView setContentSize:CGSizeMake(_width * 3, _height)];
            self.scrollView.contentOffset = CGPointMake(_width, 0);
        } else if (self.dirction == TNScrollViewDirectionVertical) {
            [self.scrollView setContentSize:CGSizeMake(_width, 3 * _height)];
            self.scrollView.contentOffset = CGPointMake(0, _height);
        }
        self.previousImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x-offsetX, frame.origin.y-offsetY, frame.size.width, frame.size.height)];
        self.lastImage     = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x+offsetX, frame.origin.y+offsetY, frame.size.width, frame.size.height)];
    }
    
    //设置第一张图片
    self.currentImage       = [[UIImageView alloc] initWithFrame:frame];
    self.currentImage.image = [UIImage imageNamed:self.images[0]];
    [self.scrollView addSubview:self.currentImage];
    self.pageControl.currentPage = self.currentImageNo;
    
    if (_count >= 2) {
        //初始化previousImage
        self.previousImage.image = [UIImage imageNamed:self.images[_count-1]];
        [self.scrollView addSubview:self.previousImage];
        //初始化lastImage
        if (_count == 2) {
            self.lastImage.image = [UIImage imageNamed:self.images[_count-1]];
        } else {
            self.lastImage.image = [UIImage imageNamed:self.images[1]];
        }
        [self.scrollView addSubview:self.lastImage];
    }
    _offsetX = self.currentImage.frame.origin.x ;
    _offsetY = self.currentImage.frame.origin.y ;
    //设置定时器
    if (self.timeInterval != 0) {
        [self addTimer];
    }
}

//设置时间间隔
-(void)setTimeInterval:(CGFloat)timeInterval {
    _timeInterval = timeInterval;
    if (timeInterval != 0) {
        [self addTimer];
    }
}

#pragma mark - <UIScrollViewDelegate>
//手指滑动结束
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self fixImageView];
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
    CGPoint contentOffset;
    CGFloat x = 0, y = 0;
    self.dirction == TNScrollViewDirectionVertical ? (y = _height) : (x = _width);
    //下一页的offset
    contentOffset = (CGPoint) {_offsetX + x, _offsetY + y};
    //设置pagecontrol当前页是第几页
    self.pageControl.currentPage = self.currentImageNo;
    
    [UIView animateWithDuration:1.5 animations:^{
        self.scrollView.contentOffset = contentOffset;
    }];

    if (self.currentImageNo == (_count-1)) {
        self.currentImageNo = 0;
    }else {
        self.currentImageNo ++;
    }
    self.pageControl.currentPage = self.currentImageNo;
    
    [self fixImageView];
}

//修正图片视图
-(void)fixImageView {
    //重设scrollView中的各个image
    self.currentImage.image = [UIImage imageNamed:self.images[self.currentImageNo]];
    self.scrollView.contentOffset = (CGPoint){_offsetX, _offsetY};
    self.previousImage.image = [UIImage imageNamed:self.images[(self.currentImageNo-1+_count) % _count]];
    self.lastImage.image = [UIImage imageNamed:self.images[(self.currentImageNo+1) % _count]];
}

//添加计时器
-(void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(changeOffset) userInfo:nil repeats:YES];
}
@end
