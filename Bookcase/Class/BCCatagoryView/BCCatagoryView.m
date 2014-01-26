//
//  BCCatagoryView.m
//  Bookcase
//
//  Created by CHENG POWEN on 2014/1/22.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import "BCCatagoryView.h"
#import "BCCatagoryContentView.h"

@interface BCCatagoryView()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIViewController *superVuewController;

@end

@implementation BCCatagoryView

- (id)initWithFrame:(CGRect)frame superViewController:(UIViewController *)superVuewController
{
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    if (self) {
        _superVuewController = superVuewController;
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];//modified by TED
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        // Initialization code
    }
    return self;
}

- (void)setCatagories:(NSArray *)catagories {
    
    CGFloat scrollViewWidth = _scrollView.frame.size.width;
    CGFloat scrollViewHeight = _scrollView.frame.size.height;
    
    int numberOfCatagories = catagories.count;
    int numberOfPages = numberOfCatagories/9;
    if (numberOfCatagories%9!=0) {
        numberOfPages++;
    }
    [_scrollView setContentSize:CGSizeMake(scrollViewWidth*numberOfPages, scrollViewHeight)];
    
    [catagories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int currentPage = idx/9;
        int currentClickButtonIdx = idx%9;
        NSString *catagory = obj;
        BCCatagoryContentView *catagoryContentView = (BCCatagoryContentView *)[self viewWithTag:currentPage+1];
        if (!catagoryContentView) {
            catagoryContentView = [[BCCatagoryContentView alloc]initWithFrame:CGRectMake(scrollViewWidth*currentPage, 0, scrollViewWidth, scrollViewHeight) owner:self];
            [_scrollView addSubview:catagoryContentView];
            catagoryContentView.tag = currentPage+1;
        }
        UIButton *currentClickButton = catagoryContentView.clickCatagoryButtons[currentClickButtonIdx];
        currentClickButton.hidden = NO;
        [currentClickButton setTitle:catagory forState:UIControlStateNormal];
        
        UILabel *currentClickLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 268, 50)];
        [currentClickLabel setCenter:CGPointMake(currentClickButton.center.x, currentClickButton.center.y-10)];


        [catagoryContentView addSubview:currentClickLabel];
        currentClickLabel.text=currentClickButton.titleLabel.text;
        currentClickLabel.font=[UIFont systemFontOfSize:29];
        currentClickLabel.textColor=[UIColor whiteColor];
        [currentClickLabel setTextAlignment:NSTextAlignmentCenter];
        
    }];
}

- (IBAction)clickCatagoryButtonAction:(UIButton *)sender {
    NSLog(@"%@",sender.titleLabel.text);
    [_superVuewController performSegueWithIdentifier:@"goToBookcase" sender:sender.titleLabel.text];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
