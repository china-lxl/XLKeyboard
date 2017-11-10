//
//  ViewController.m
//  Keyboard
//
//  Created by lixinglu on 2017/11/10.
//  Copyright © 2017年 lxl. All rights reserved.
//

#import "ViewController.h"

#import "XLKeyboardView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnCliecked:(id)sender {
    XLKeyboardView *view = [XLKeyboardView shareKeyBoard];
    [view showView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
