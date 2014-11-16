//
//  ViewController.m
//  Test
//
//  Created by Андрей Ежов on 15.11.14.
//  Copyright (c) 2014 Ezhov Andrey. All rights reserved.
//

#import "ViewController.h"
#import "EAAnimAgent.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EAAnimAgent* appleAnimation = [[EAAnimAgent alloc] initWithFrame:self.view.bounds];
    [appleAnimation getAnimation:[NSDictionary dictionaryWithContentsOfFile:@"/Users/andrejezov/Desktop/AnimationTest/Test/Test/Source/game1_table_apple_one.plist"]];
    [self.view addSubview:appleAnimation];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
