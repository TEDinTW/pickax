//
//  BCCatagoryContentView.h
//  Bookcase
//
//  Created by CHENG POWEN on 2014/1/22.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCCatagoryContentView : UIView

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *clickCatagoryButtons;

- (id)initWithFrame:(CGRect)frame owner:(id)owner;

@end
