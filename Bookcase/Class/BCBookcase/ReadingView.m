//
//  ReadingView.m
//  Bookcase
//
//  Created by CHENG POWEN on 2014/1/13.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import "ReadingView.h"

@interface ReadingView()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *border;
@property (strong, nonatomic) UILabel *pageLabel;
@property (strong ,nonatomic) NSArray *pdfPaths;
@property (strong, nonatomic) UIButton *removeReadingViewButton;

@end

@implementation ReadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _border = [[UIView alloc]initWithFrame:CGRectInset(self.bounds, 30, 30)];
        _border.layer.borderWidth = 1.0f;
        _border.layer.borderColor = [[UIColor blackColor] CGColor];
        _border.userInteractionEnabled = NO;
        [self addSubview:_border];
        
        _pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _pageLabel.center = self.center;
        _pageLabel.frame = CGRectMake(_pageLabel.frame.origin.x, CGRectGetHeight(self.frame)-_pageLabel.frame.size.height, _pageLabel.frame.size.width, _pageLabel.frame.size.height);
        _pageLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_pageLabel];
        
        _removeReadingViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _removeReadingViewButton.frame = CGRectMake(CGRectGetWidth(self.frame)-30.0f, 0, 30, 30);
        _removeReadingViewButton.frame = CGRectOffset(_removeReadingViewButton.frame, -20, 20);
        [_removeReadingViewButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [_removeReadingViewButton addTarget:self action:@selector(removeReadingViewButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_removeReadingViewButton];
    }
    return self;
}

- (void)setPdfPaths:(NSArray *)pdfPaths {
    if (_pdfPaths != pdfPaths) {
        _pdfPaths = pdfPaths;
        NSInteger numberOfPages = [pdfPaths count];
        
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        [_scrollView setContentSize:CGSizeMake(width, height*numberOfPages)];
        
        _pageLabel.text = [NSString stringWithFormat:@"%d/%ld",1,(long)numberOfPages];
        
        [pdfPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectInset(self.frame, 50, 50)];
            imageView.center = CGPointMake(self.center.x, self.center.y+idx*CGRectGetHeight(self.frame));
            imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:obj]];
            [_scrollView addSubview:imageView];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.frame.size.height;
    NSInteger currentPage = ((scrollView.contentOffset.y - height / 2) / height) + 1;
//    NSLog(@"currentPage:%d",currentPage);
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat scrollViewHeight = scrollView.frame.size.height;
    if (contentOffsetY == scrollViewHeight*currentPage) {
//        _pageLabel.frame = CGRectMake(_pageLabel.frame.origin.x, CGRectGetHeight(self.frame)-_pageLabel.frame.size.height+currentPage*CGRectGetHeight(self.frame), _pageLabel.frame.size.width, _pageLabel.frame.size.height);
        _pageLabel.text = [_pageLabel.text stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%d",currentPage+1]];
//        _removeReadingViewButton.frame = CGRectMake(_removeReadingViewButton.frame.origin.x, contentOffsetY+20, _removeReadingViewButton.frame.size.width, _removeReadingViewButton.frame.size.height);
    }
}

- (void)removeReadingViewButtonAction {
    NSArray *subviews = [_scrollView subviews];
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    _scrollView.contentOffset = CGPointMake(0, 0);
    [UIView animateWithDuration:1.0f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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
