//
//  BCRootViewController.m
//  Bookcase
//
//  Created by CHENG POWEN on 2014/1/22.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import "BCRootViewController.h"
#import "BCCatagoryView.h"
#import "BCViewController.h"

@interface BCRootViewController ()

@property (strong, nonatomic) NSString *catagoryTitles;
@property (strong, nonatomic) BCCatagoryView *catagoryView;

@end

@implementation BCRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _catagoryTitles = @"AA,BB,CC,DD,EE,FF,GG,HH,II,JJ,KK,LL,MM";
    NSArray *catagories = [_catagoryTitles componentsSeparatedByString:@","];
    CGRect frame = CGRectMake(0, 0, 1024.0f, 768.0f);
    _catagoryView = [[BCCatagoryView alloc]initWithFrame:frame superViewController:self];
    [_catagoryView setCatagories:catagories];
    [self.view addSubview:_catagoryView];
	// Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToBookcase"]) {
        NSLog(@"go to bookcase");
        BCViewController *bcViewController = [segue destinationViewController];
        bcViewController.catagoryTitle = sender;
    }
}

//- (void)viewDidAppear:(BOOL)animated {
//    [self.view addSubview:_catagoryView];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
