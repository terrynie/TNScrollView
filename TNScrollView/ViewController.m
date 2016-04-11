//
//  ViewController.m
//  TNScrollView
//
//  Created by Terry on 4/9/16.
//  Copyright © 2016 Terry. All rights reserved.
//

#import "ViewController.h"
#import "TNScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TNScrollView *scrollview = [[TNScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) andDirection:TNScrollViewDirectionHorizontal];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.view addSubview:scrollview];
    
    [array addObject:@"img_01"];
    [array addObject:@"img_04"];
    [array addObject:@"img_03"];
    [array addObject:@"img_02"];
    [scrollview setImages:array];
    [scrollview setTimeInterval:3.0];UIAlertView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
