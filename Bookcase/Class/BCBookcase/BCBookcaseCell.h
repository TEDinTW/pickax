//
//  BCBookcaseCell.h
//  Bookcase
//
//  Created by CHENG POWEN on 2014/1/7.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCBookcaseCell : UIView

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *bookCovers;
@property (strong, nonatomic) IBOutletCollection(UITextView) NSArray *bookDescriptions;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *downloadVideoButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *downloadPdfButtons;

- (id)initWithOwner:(id)owner;

- (void)reset;

@end
