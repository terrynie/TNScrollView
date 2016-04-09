//
//  TNScrollView.m
//  TNScrollView
//
//  Created by Terry on 4/9/16.
//  Copyright © 2016 Terry. All rights reserved.
//

#import "TNScrollView.h"

@interface TNScrollView ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@end

@implementation TNScrollView


-(instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TNScrollView" owner:nil options:nil] lastObject];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TNScrollView" owner:nil options:nil] lastObject];
    }
    return self;
}

-(void)setImages:(NSArray *)images {
    _images = images;
    //refresh the scrollView after set images
    [self layoutSubviews];
}

-(void)layoutSubviews {
    
    //content width
    CGFloat width = self.scrollView.contentSize.width;
    //content height
    CGFloat height = self.scrollView.contentSize.height;
    
    //加载图片
    for (int i = 0; i < self.images.count; i++) {
        UIImageView *imageView;
        if (self.dirction == TNScrollViewDirectionVertical) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, i * height, width, height)];
        }else {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        }
        imageView.image = [UIImage imageNamed:self.images[i]];
        [self.scrollView addSubview:imageView];
    }
}
@end
