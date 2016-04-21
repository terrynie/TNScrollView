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
    TNScrollView *scrollview = [[TNScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) andDirection: TNScrollViewDirectionHorizontal];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"img_01",@"img_02", @"img_03", @"img_04", nil];
    [self.view addSubview:scrollview];

    [scrollview setImages:array];
    [scrollview setTimeInterval:5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
