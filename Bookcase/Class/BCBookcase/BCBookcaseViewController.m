//
//  BCBookcaseViewController.m
//  Bookcase
//
//  Created by CHENG POWEN on 2014/2/6.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import "BCBookcaseViewController.h"
#import "BCBookcase.h"
#import "BCBookcaseCell.h"
#import "BCFileManager.h"
#import "AFNetworking.h"

@interface BCBookcaseViewController ()<BCBookcaseDelegate>

@property (strong, nonatomic) BCBookcaseCell *bookcaseCell;
@property (strong, nonatomic) BCBookcase *bookcase;
@property (strong, nonatomic) BCFileManager *fileManager;
@property (strong, nonatomic) NSDictionary *response;
@property (strong, nonatomic) NSArray *bookInfos;

@end

@implementation BCBookcaseViewController

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
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *postURLStr=[NSString stringWithFormat:@"http://www.lwin.com.tw/ted_temp/pdf_json.php?catagory=%@",_bookcaseSerial];
    NSLog(@"BCBookcaseVC postURL = %@",postURLStr);
    [manager POST:postURLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _response = responseObject;
        _bookInfos = _response[@"file"];
        if (![_bookInfos isKindOfClass:[NSNull class]]) {
            _bookcase = [[BCBookcase alloc]initWithFrame:self.view.bounds superViewController:self response:_response];
            _bookcase.bookcaseDelegate = self;
            [self.view addSubview:_bookcase];
        }else {
            UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200.0f, 80.0f)];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.adjustsFontSizeToFitWidth = YES;
            messageLabel.font = [UIFont fontWithName:@"Asia" size:80.0f];
            messageLabel.center = self.view.center;
            messageLabel.text = @"目前暫無此項目";
            [self.view addSubview:messageLabel];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.navigationController popViewControllerAnimated:YES];
//        _bookcase = [[BCBookcase alloc]initWithFrame:CGRectMake(0, 20.0f, 1024.0f, 708.0f) superViewController:self response:@{}];
//        _bookcase.bookcaseDelegate = self;
//        [self.view addSubview:_bookcase];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BCBookcase protocol
- (NSInteger)numberOfBooksInBookcase:(BCBookcase *)bookcase {
    return [_bookInfos count];
}

- (NSArray *)bookcase:(BCBookcase *)bookcase bookAtRow:(NSInteger)row column:(NSInteger)column {
    return _bookInfos[row*4+column];
}

- (NSArray *)titleAndSerialOfBookcase:(BCBookcase *)bookcase{
    return @[_bookcaseTitle,_bookcaseSerial];
}

@end
