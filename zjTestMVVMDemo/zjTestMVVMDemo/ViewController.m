//
//  ViewController.m
//  zjTestMVVMDemo
//
//  Created by MACMINI on 16/2/23.
//  Copyright © 2016年 LZJ. All rights reserved.
//

#import "ViewController.h"
#import "GoodsListViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)testaction:(id)sender {
    GoodsListViewController *dv = [[GoodsListViewController alloc] init];
    [self.navigationController pushViewController:dv animated:YES];
}

@end
