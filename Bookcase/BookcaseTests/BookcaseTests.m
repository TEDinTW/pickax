//
//  BookcaseTests.m
//  BookcaseTests
//
//  Created by CHENG POWEN on 2014/1/7.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCFileManager.h"

@interface BookcaseTests : XCTestCase

@property (strong, nonatomic) BCFileManager *fileManager;

@end

@implementation BookcaseTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _fileManager = [[BCFileManager alloc]init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testParseJson {
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"file2" ofType:@"json"];
    NSData *jsonFile = [NSData dataWithContentsOfFile:jsonFilePath];
    NSDictionary *jsonParseResult = [_fileManager parseJson:jsonFile];
    NSString *version = jsonParseResult[@"version"];
    XCTAssertTrue([version isEqualToString:@"1.0"], @"success");
}

@end
