//
//  BCBookcase.h
//  Bookcase
//
//  Created by CHENG POWEN on 2014/1/7.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BCBookcaseDelegate;

@interface BCBookcase : UIView

@property (weak, nonatomic) id<BCBookcaseDelegate>bookcaseDelegate;

- (id)initWithFrame:(CGRect)frame superViewController:(UIViewController *)superViewController response:(NSDictionary *)response;

@end

@protocol BCBookcaseDelegate <NSObject>

@required
- (NSInteger)numberOfBooksInBookcase:(BCBookcase *)bookcase;
- (NSDictionary *)bookcase:(BCBookcase *)bookcase bookAtRow:(NSInteger)row column:(NSInteger)column;

@optional
- (CGFloat)bookcase:(BCBookcase *)bookcase heightForRowAtIndex:(NSInteger)index;
- (CGFloat)heightForHeaderInBookcase:(BCBookcase *)bookcase;
- (CGFloat)heightForFooterInBookcase:(BCBookcase *)bookcase;
- (NSArray *)titleAndSerialOfBookcase:(BCBookcase *)bookcase;

@end