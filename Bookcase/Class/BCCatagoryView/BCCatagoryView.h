//
//  BCCatagoryView.h
//  Bookcase
//
//  Created by CHENG POWEN on 2014/1/22.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCCatagoryView : UIView

@property (strong, nonatomic) NSString *clickCatagoryName;

- (id)initWithFrame:(CGRect)frame superViewController:(UIViewController *)superVuewController;

- (void)setCatagories:(NSArray *)catagories;

@end
