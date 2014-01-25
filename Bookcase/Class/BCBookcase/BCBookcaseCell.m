//
//  BCBookcaseCell.m
//  Bookcase
//
//  Created by CHENG POWEN on 2014/1/7.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import "BCBookcaseCell.h"

@implementation BCBookcaseCell

- (id)initWithOwner:(id)owner {
    self = [[[NSBundle mainBundle]loadNibNamed:@"BCBookcaseCell" owner:owner options:0]lastObject];
    if (self) {
        // Initialization code
        [self reset];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"BCBookcaseCell" owner:nil options:0]lastObject];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
//    [self setFrame:newSuperview.bounds];
}

- (void)reset {
    [_bookCovers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *bookCover = obj;
        bookCover.image = NULL;
    }];
    [_bookDescriptions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UITextView *bookDescription = obj;
        bookDescription.text = @"";
        bookDescription.hidden = YES;
    }];
    [_downloadVideoButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        button.hidden = YES;
    }];
    [_downloadPdfButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        button.hidden = YES;
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
