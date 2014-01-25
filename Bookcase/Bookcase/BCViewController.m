//
//  BCViewController.m
//  Bookcase
//
//  Created by CHENG POWEN on 2014/1/7.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import "BCViewController.h"
#import "BCBookcase.h"
#import "BCBookcaseCell.h"
#import "BCFileManager.h"
#import "AFNetworking.h"

@interface BCViewController ()<BCBookcaseDelegate>

@property (strong, nonatomic) BCBookcaseCell *bookcaseCell;
@property (strong, nonatomic) BCBookcase *bookcase;
@property (strong, nonatomic) BCFileManager *fileManager;
@property (strong, nonatomic) NSDictionary *response;
@property (strong, nonatomic) NSArray *bookInfos;

@end

@implementation BCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _bookcaseCell = [[BCBookcaseCell alloc]initWithFrame:CGRectMake(0, 0, 1024, 350)];
//    [self.view addSubview:_bookcaseCell];
	// Do any additional setup after loading the view, typically from a nib.
//    _fileManager = [[BCFileManager alloc]initWithFolderName:@"lwinFolder"];
//    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"file2" ofType:@"json"];
//    NSData *jsonFile = [NSData dataWithContentsOfFile:jsonFilePath];
//    _jsonParseResult = [_fileManager parseJson:jsonFile];
//    _booksInfo = _jsonParseResult[@"file"];
    NSLog(@"catagoryTitle:%@",_catagoryTitle);
    self.navigationItem.title = _catagoryTitle;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:@"http://www.lwin.com.tw/ted_temp/pdf_json.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *parameters = @{@"foo": @"bar"};
    [manager POST:@"http://www.lwin.com.tw/ted_temp/pdf_json.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _response = responseObject;
        _bookInfos = _response[@"file"];
        _bookcase = [[BCBookcase alloc]initWithFrame:CGRectMake(0, 64.0f, 1024.0f, 708.0f) superViewController:self response:_response];
        _bookcase.bookcaseDelegate = self;
        [self.view addSubview:_bookcase];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        _bookcase = [[BCBookcase alloc]initWithFrame:CGRectMake(0, 64.0f, 1024.0f, 708.0f) superViewController:self response:@{}];
        _bookcase.bookcaseDelegate = self;
        [self.view addSubview:_bookcase];
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

@end
