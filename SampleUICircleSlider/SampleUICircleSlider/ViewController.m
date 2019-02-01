//
//  ViewController.m
//  SampleUICircleSlider
//
//  Created by Kid Young on 2/1/19.
//  Copyright © 2019 Yang XiHong. All rights reserved.
//

#import "ViewController.h"
#import <UICircleSlider.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)valueChanged:(id)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"%f", ((UICircleSlider *)sender).value);
}

@end
