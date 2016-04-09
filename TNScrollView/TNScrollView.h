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


@interface TNScrollView : UIView
//the images in ScrollView
@property(nonatomic, retain) NSArray *images;
//the scrollView scroll direction
@property(nonatomic, assign) TNScrollViewDirection dirction;

-(instancetype)init;
-(instancetype)initWithFrame:(CGRect)frame;
@end
