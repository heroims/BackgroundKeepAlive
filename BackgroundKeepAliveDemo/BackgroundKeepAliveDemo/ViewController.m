//
//  ViewController.m
//  BackgroundKeepAliveDemo
//
//  Created by Admin on 2023/7/17.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
    associateBundleURL = [associateBundleURL URLByAppendingPathComponent:@"BackgroundKeepAlive"];
    associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
    NSBundle *associateBundle = [NSBundle mainBundle];
    if([[NSFileManager defaultManager] fileExistsAtPath:associateBundleURL.path]){
        associateBundle = [NSBundle bundleWithURL:associateBundleURL];
    }
    associateBundleURL = [associateBundle URLForResource:@"BackgroundKeepAlive" withExtension:@"bundle"];
    
    NSString *filePath = [[NSBundle bundleWithURL:associateBundleURL] pathForResource:@"keep_alive" ofType:@"wav"];

    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSLog(@"存在");
    }
    else{
        NSLog(@"不存在");
    }
}


@end
