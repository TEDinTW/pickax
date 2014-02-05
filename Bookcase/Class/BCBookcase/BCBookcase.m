//
//  BCBookcase.m
//  Bookcase
//
//  Created by CHENG POWEN on 2014/1/7.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import "BCBookcase.h"
#import "BCBookcaseCell.h"
#import "BCFileManager.h"
#import "DACircularProgressView.h"
#import "ReadingView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface BCBookcase()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic, readonly) UIViewController *superViewController;
@property (strong, nonatomic) UITableView *bookcaseTableView;
@property (strong, nonatomic) NSNumber *numberOfRowAtBookcase;
@property (strong, nonatomic) NSNumber *numberOfColumnAtLastRow;
@property (strong ,nonatomic) NSMutableArray *bookInfos;
@property (strong, nonatomic) BCFileManager *fileManager;
@property (strong, nonatomic) ReadingView *readingView;

@property (strong, nonatomic) NSString *basicMoiveURL;
@property (strong, nonatomic) NSString *basicPdfURL;
@property (strong, nonatomic) NSString *basicMovieImgURL;

@end

@implementation BCBookcase
{
    CGRect _frame;
    CGFloat _heightOfRow;
    CGFloat _heightOfHeader;
    CGFloat _heightOfFooter;
    BOOL _respondsToHeightForRowAtIndex;
    BOOL _respondsToHeightForHeader;
    BOOL _respondsToHeightForFooter;
}

- (id)initWithFrame:(CGRect)frame superViewController:(UIViewController *)superViewController response:(NSDictionary *)response {
    self = [super initWithFrame:frame];
    if (self) {
        _superViewController = superViewController;
        _frame = frame;
        _heightOfRow = 350.0f;
        _heightOfHeader = 35.0f;
        _heightOfFooter = 35.0f;
        // Initialization code
        _bookcaseTableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _bookcaseTableView.delegate = self;
        _bookcaseTableView.dataSource = self;
        [self addSubview:_bookcaseTableView];
        _fileManager = [[BCFileManager alloc]initWithFolderName:@"lwinStudying"];
        _readingView = [[ReadingView alloc]initWithFrame:self.bounds];
        
        _basicMoiveURL = [NSString stringWithFormat:@"http://%@",response[@"basic_movie_url"]];
        _basicPdfURL = [NSString stringWithFormat:@"http://%@",response[@"basic_pdf_url"]];
        _basicMovieImgURL = [NSString stringWithFormat:@"http://%@",response[@"basic_movie_img_url"]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _frame = frame;
        _heightOfRow = 350.0f;
        _heightOfHeader = 35.0f;
        _heightOfFooter = 35.0f;
        // Initialization code
        _bookcaseTableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _bookcaseTableView.delegate = self;
        _bookcaseTableView.dataSource = self;
        [self addSubview:_bookcaseTableView];
        _fileManager = [[BCFileManager alloc]initWithFolderName:@"lwinStudying"];
        _readingView = [[ReadingView alloc]initWithFrame:self.bounds];
    }
    return self;
}

- (void)setBookcaseDelegate:(id<BCBookcaseDelegate>)bookcaseDelegate {
    if (_bookcaseDelegate != bookcaseDelegate) {
        _bookcaseDelegate = bookcaseDelegate;
        _respondsToHeightForRowAtIndex = [bookcaseDelegate respondsToSelector:@selector(bookcase:heightForRowAtIndex:)];
        _respondsToHeightForHeader = [bookcaseDelegate respondsToSelector:@selector(heightForHeaderInBookcase:)];
        _respondsToHeightForFooter = [bookcaseDelegate respondsToSelector:@selector(heightForFooterInBookcase:)];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
//    [self setFrame:_frame];
}

- (IBAction)downloadVideoButton:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if ([sender.titleLabel.text isEqualToString:@"暫無影片"]) {
        return;
    }
    if ([sender.titleLabel.text isEqualToString:@"下載影片"]) {
        if (![[[sender subviews]lastObject]isKindOfClass:[DACircularProgressView class]]) {
            NSDictionary *bookInfo = _bookInfos[tag];
            NSString *movieId = bookInfo[@"movieID"];
            if (![movieId isEqualToString:@"0"]) {
                NSString *moviePath = [movieId stringByAppendingPathComponent:[NSString stringWithFormat:@"video/%@.mp4",movieId]];
                
                CGFloat progressViewSpace = 5.0f;
                CGFloat progressViewWidth = CGRectGetHeight(sender.frame)-progressViewSpace;
                CGFloat progressViewX = CGRectGetWidth(sender.frame)-progressViewWidth-progressViewSpace;
                CGFloat progressViewY = (CGRectGetHeight(sender.frame)-progressViewWidth)/2;
                __block DACircularProgressView *downloadProgressView = [[DACircularProgressView alloc]initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewWidth, progressViewWidth)];
                downloadProgressView.roundedCorners = YES;
                downloadProgressView.trackTintColor = [UIColor lightGrayColor];
                downloadProgressView.progressTintColor = [UIColor whiteColor];
                downloadProgressView.thicknessRatio = 0.3f;
                [sender addSubview:downloadProgressView];
                
                NSString *movieURL = [_basicMoiveURL stringByAppendingPathComponent:bookInfo[@"movieURL"]];
                [_fileManager downloadVideoWithURL:movieURL saveToVideoPath:moviePath progress:^(CGFloat rateOfDidWriteData) {
                    //                NSLog(@"%f",rateOfDidWriteData);
                    [downloadProgressView setProgress:rateOfDidWriteData animated:YES];
                } completionHandler:^(BOOL success) {
                    if (success) {
                        [sender setTitle:@"播放影片" forState:UIControlStateNormal];
                        [sender setBackgroundImage:[UIImage imageNamed:@"bottom02_videoPlay"] forState:UIControlStateNormal];
                    }
                    [downloadProgressView removeFromSuperview];
                }];
            }else {
                
            }
        }
    }else {
        NSDictionary *bookInfo = _bookInfos[tag];
        NSString *movieId = bookInfo[@"movieID"];
        NSString *moviePath = [_fileManager videoPathWithMovieId:movieId];
        NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
        
        MPMoviePlayerViewController *moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:movieURL];
        [_superViewController presentMoviePlayerViewControllerAnimated:moviePlayerVC];
    }
}

- (void)playMovieAtURL:(NSURL *)movieURL
{
    MPMoviePlayerViewController *moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:movieURL];
    [_superViewController presentMoviePlayerViewControllerAnimated:moviePlayerVC];
}

- (IBAction)downloadPdfButton:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if ([sender.titleLabel.text isEqualToString:@"下載文件"]) {
        if (![[[sender subviews]lastObject]isKindOfClass:[DACircularProgressView class]]) {
            NSDictionary *bookInfo = _bookInfos[tag];
            NSString *bookId = bookInfo[@"pdf_id"];
            NSString *pdfFolder = [bookId stringByAppendingPathComponent:@"pdf"];
            NSArray *pdfURLs = bookInfo[@"pdfURL"];
            
            CGFloat progressViewSpace = 5.0f;
            CGFloat progressViewWidth = CGRectGetHeight(sender.frame)-progressViewSpace;
            CGFloat progressViewX = CGRectGetWidth(sender.frame)-progressViewWidth-progressViewSpace;
            CGFloat progressViewY = (CGRectGetHeight(sender.frame)-progressViewWidth)/2;
            __block DACircularProgressView *downloadProgressView = [[DACircularProgressView alloc]initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewWidth, progressViewWidth)];
            downloadProgressView.roundedCorners = YES;
            downloadProgressView.trackTintColor = [UIColor lightGrayColor];
            downloadProgressView.progressTintColor = [UIColor whiteColor];
            downloadProgressView.thicknessRatio = 0.3f;
            [sender addSubview:downloadProgressView];
            
            [_fileManager downloadPdfWithBasicURL:_basicPdfURL pdfURLs:pdfURLs  saveToPdfFolder:pdfFolder progress:^(CGFloat rateOfDidWriteData) {
//                NSLog(@"%f",rateOfDidWriteData);
                [downloadProgressView setProgress:rateOfDidWriteData animated:YES];
            } completionHandler:^(BOOL success) {
                if (success) {
                    [sender setTitle:@"閱讀文獻" forState:UIControlStateNormal];
                    [sender setBackgroundImage:[UIImage imageNamed:@"bottom03_pdf_study"] forState:UIControlStateNormal];
                }
                double delayInSeconds = 0.5f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [downloadProgressView removeFromSuperview];
                });
            }];
        }
    }else {
        NSDictionary *bookInfo = _bookInfos[tag];
        NSString *bookId = bookInfo[@"pdf_id"];
        NSString *pdfFolder = [bookId stringByAppendingPathComponent:@"pdf"];
        NSNumber *numberOfPages = bookInfo[@"pdfNum"];
        NSArray *pdfPaths = [_fileManager pdfPathsAtFolderPath:pdfFolder numberOfPages:numberOfPages];
        [_readingView setPdfPaths:pdfPaths];
        _readingView.alpha = 0.0f;
        [self addSubview:_readingView];
        [UIView animateWithDuration:1.0f animations:^{
            _readingView.alpha = 1.0f;
        }];
    }
}

#pragma mark - UITableView(bookcaseTableView) datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfBooks = [_bookcaseDelegate numberOfBooksInBookcase:self];
    NSInteger numberOfRows = numberOfBooks/4;
    NSInteger numberOfLastRow = numberOfBooks%4;
    if (numberOfLastRow) {
        _numberOfColumnAtLastRow = [NSNumber numberWithInteger:numberOfLastRow];
        numberOfRows++;
    }else {
        _numberOfColumnAtLastRow = [NSNumber numberWithInteger:0];
    }
    _numberOfRowAtBookcase = [NSNumber numberWithInteger:numberOfRows];
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger numberOfColumn;
    if (row<[_numberOfRowAtBookcase integerValue]-1 || [_numberOfColumnAtLastRow integerValue]==0) {
        numberOfColumn = 4;
    }else {
        numberOfColumn = [_numberOfColumnAtLastRow integerValue];
    }
    
    static NSString *reusedId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
    BCBookcaseCell *bookcaseCell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
        bookcaseCell = [[BCBookcaseCell alloc]initWithOwner:self];
        [cell.contentView addSubview:bookcaseCell];
    }else {
        bookcaseCell = [[cell.contentView subviews]lastObject];
        [bookcaseCell reset];
    }
    for (int column=0; column<numberOfColumn; column++) {
        NSDictionary *bookInfo = [_bookcaseDelegate bookcase:self bookAtRow:row column:column];
        if (!_bookInfos) {
            _bookInfos = [[NSMutableArray alloc]init];
        }
        [_bookInfos addObject:bookInfo];
        NSString *bookId = bookInfo[@"pdf_id"];
        [_fileManager createFolderWithString:bookId];
        
        //設定 book cover
        NSString *movieImgURL = bookInfo[@"movieImgURL"];
        movieImgURL = [_basicMovieImgURL stringByAppendingPathComponent:movieImgURL];
        __block UIImageView *bookcover = bookcaseCell.bookCovers[column];
        [_fileManager loadBookCoverWithMovieId:bookId imageURL:movieImgURL paragram:^(UIImage *image) {
            bookcover.image = image;
        }];
        
        //設定 book description
        NSString *bookDescriptionString = bookInfo[@"desr"];
        UITextView *bookDescription = bookcaseCell.bookDescriptions[column];
        bookDescription.hidden = NO;
        bookDescription.text = bookDescriptionString;
        
        //設定 downloadViewButton
        UIButton *downloadVideoButton = bookcaseCell.downloadVideoButtons[column];
        downloadVideoButton.hidden = NO;
        downloadVideoButton.tag = row*4+column;
        
        NSString *movieId = bookInfo[@"movieID"];
        if ([movieId isEqualToString:@"0"]) {
            [downloadVideoButton setTitle:@"暫無影片" forState:UIControlStateNormal];
        }else {
            [_fileManager createFolderWithString:movieId];
            NSString *videoFolderPath = [movieId stringByAppendingPathComponent:@"video"];
            [_fileManager createFolderWithString:videoFolderPath];
            NSString *videoPath = [videoFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",movieId]];
            if ([_fileManager videoExistsAtVidePath:videoPath]) {
                [downloadVideoButton setTitle:@"播放影片" forState:UIControlStateNormal];
                [downloadVideoButton setBackgroundImage:[UIImage imageNamed:@"bottom02_videoPlay"] forState:UIControlStateNormal];
            }else {
                [downloadVideoButton setTitle:@"下載影片" forState:UIControlStateNormal];
            }
        }
        
        //設定 downloadPdfButton
        UIButton *downloadPdfButton = bookcaseCell.downloadPdfButtons[column];
        downloadPdfButton.hidden = NO;
        downloadPdfButton.tag = row*4+column;
        NSString *pdfFolderPath = [bookId stringByAppendingPathComponent:@"pdf"];
        [_fileManager createFolderWithString:pdfFolderPath];
        NSNumber *numberOfPages = bookInfo[@"pdfNum"];
        if ([_fileManager pdfExistsAtFolderPath:pdfFolderPath numberOfPages:numberOfPages]) {
            [downloadPdfButton setTitle:@"閱讀文件" forState:UIControlStateNormal];
            [downloadPdfButton setBackgroundImage:[UIImage imageNamed:@"bottom03_pdf_study"] forState:UIControlStateNormal];
        }else {
            [_fileManager createFolderWithString:bookId];
            [downloadPdfButton setTitle:@"下載文件" forState:UIControlStateNormal];
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _frame.size.width, _heightOfHeader)];
    imageView.image = [UIImage imageNamed:@"bookcase_bg_01_top"];
    return imageView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _frame.size.width, _heightOfHeader)];
    imageView.image = [UIImage imageNamed:@"bookcase_bg_01_bottom"];
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_respondsToHeightForRowAtIndex) {
        _heightOfRow = [_bookcaseDelegate bookcase:self heightForRowAtIndex:indexPath.row];
    }
    return _heightOfRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_respondsToHeightForHeader) {
        _heightOfHeader = [_bookcaseDelegate heightForHeaderInBookcase:self];
    }
    return _heightOfHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_respondsToHeightForFooter) {
        _heightOfFooter = [_bookcaseDelegate heightForFooterInBookcase:self];
    }
    return _heightOfFooter;
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
