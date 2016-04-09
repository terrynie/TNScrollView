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
    TNScrollView *scrollview = [[TNScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:@"img_00"];
    [array addObject:@"img_01"];
    [scrollview setImages:array];
    [self.view addSubview:scrollview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
