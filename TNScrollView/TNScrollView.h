//
//  TNScrollView.h
//  TNScrollView
//
//  Created by Terry on 4/9/16.
//  Copyright © 2016 Terry. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, TNScrollViewDirection) {
    TNScrollViewDirectionVertical,   //scrollView scroll on vertical
    TNScrollViewDirectionHorizontal  //scrollView scroll on horizontal
};

typedef NS_ENUM(NSInteger, TNScrollViewScrollStyle) {
    TNScrollViewScrollStyleInfinite, //infinite loop. when scroll to last view, next is first.
    TNScrollViewScrollStyleReverse   //scroll from first to last one by one, then reverse the dirction, scroll from last one by one to first.
};


@interface TNScrollView : UIView
//the images in ScrollView
@property(nonatomic, retain)               NSArray *images;
@property(nonatomic, assign) TNScrollViewDirection dirction;      //the scrollView scroll direction
@property(nonatomic, assign)               CGFloat timeInterval;  //please set timeInterval >0 ; scrollview change pages automatically after every timeInterval. 0 is not change automatically .
@property(nonatomic, assign) BOOL autoShow;                       //auto scroll or not


+(instancetype)scrollViewWithFrame:(CGRect)frame andDirection:(TNScrollViewDirection)direction;
-(instancetype)initWithFrame:(CGRect)frame andDirection:(TNScrollViewDirection)direction;
@end
