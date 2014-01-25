//
//  BCFileManager.h
//  Bookcase
//
//  Created by CHENG POWEN on 2014/1/8.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCFileManager : NSObject

- (id)initWithFolderName:(NSString *)folderName;
- (BOOL)isReachable;

- (BOOL)createFolderWithString:(NSString *)string;
- (void)loadBookCoverWithMovieId:(NSString *)movieId imageURL:(NSString *)imageURL paragram:(void(^)(UIImage *image))paragram;

- (BOOL)videoExistsAtVidePath:(NSString *)videoPath;
- (NSString *)videoPathWithMovieId:(NSString *)movieId;

- (BOOL)pdfExistsAtFolderPath:(NSString *)folderPath numberOfPages:(NSNumber *)numberOfPages;
- (NSArray *)pdfPathsAtFolderPath:(NSString *)folderPath numberOfPages:(NSNumber *)numberOfPages;

- (void)downloadVideoWithURL:(NSString *)URL saveToVideoPath:(NSString *)videoPath progress:(void(^)(CGFloat rateOfDidWriteData))progress completionHandler:(void(^)(BOOL success))completionHandler;
- (void)downloadPdfWithBasicURL:(NSString *)basicURL pdfURLs:(NSArray *)pdfURLs saveToPdfFolder:(NSString *)pdfFolder progress:(void(^)(CGFloat rateOfDidWriteData))progress completionHandler:(void(^)(BOOL success))completionHandler;

- (NSDictionary *)parseJson:(id)json;

@end
