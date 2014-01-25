//
//  BCCatagoryContentView.m
//  Bookcase
//
//  Created by CHENG POWEN on 2014/1/22.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import "BCCatagoryContentView.h"

@implementation BCCatagoryContentView

- (id)initWithFrame:(CGRect)frame owner:(id)owner {
    self = [[[NSBundle mainBundle]loadNibNamed:@"BCCatagoryView" owner:owner options:0]lastObject];
    if (self) {
        // Initialization code
        [self setFrame:frame];
        [self reset];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)reset {
    [_clickCatagoryButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *clickButton = obj;
        clickButton.hidden = YES;
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
