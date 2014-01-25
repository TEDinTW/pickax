//
//  BCFileManager.m
//  Bookcase
//
//  Created by CHENG POWEN on 2014/1/8.
//  Copyright (c) 2014年 CHENG POWEN. All rights reserved.
//

#import "BCFileManager.h"
#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface BCFileManager()

@property (strong, nonatomic) NSString *folderName;
@property (strong, nonatomic) NSString *baseFolderPath;
@property (strong, nonatomic) AFNetworkReachabilityManager *reachabilityManager;
@property (strong, nonatomic) UIAlertView *unreachableAlertView;
@property (strong, nonatomic) UIAlertView *failDownloadAlertView;

@end

dispatch_queue_t dispatch_queue_download;

@implementation BCFileManager

- (id)initWithFolderName:(NSString *)folderName {
    self = [super init];
    if (self) {
        _folderName = folderName;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *folderPath = [documentsPath stringByAppendingPathComponent:folderName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
            if ([[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil]) {
                _baseFolderPath = folderPath;
            }
        }else {
            _baseFolderPath = folderPath;
        }
        _reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [_reachabilityManager startMonitoring];
        dispatch_queue_download = dispatch_queue_create("com.twoyears44.download", NULL);
    }
    return self;
}

- (BOOL)isReachable {
    return [_reachabilityManager isReachableViaWiFi] || [_reachabilityManager isReachableViaWWAN];
}

- (BOOL)createFolderWithString:(NSString *)string {
    NSString *movieFolderPath = [_baseFolderPath stringByAppendingPathComponent:string];
    if (![[NSFileManager defaultManager]fileExistsAtPath:movieFolderPath]) {
        return [[NSFileManager defaultManager]createDirectoryAtPath:movieFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }else {
        return NO;
    }
    return YES;
}

- (void)loadBookCoverWithMovieId:(NSString *)movieId imageURL:(NSString *)imageURL paragram:(void(^)(UIImage *image))paragram {
    NSString *movieFolderPath = [_baseFolderPath stringByAppendingPathComponent:movieId];
    NSString *imagePath = [movieFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"cover%@.png",movieId]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        paragram([UIImage imageWithContentsOfFile:imagePath]);
    }else {
        __block UIImage *image;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imagePath atomically:YES];
                paragram(image);
            });
        });
    }
}

- (BOOL)videoExistsAtVidePath:(NSString *)videoPath {
    videoPath = [_baseFolderPath stringByAppendingPathComponent:videoPath];
    return [[NSFileManager defaultManager]fileExistsAtPath:videoPath];
}

- (NSString *)videoPathWithMovieId:(NSString *)movieId {
    return [_baseFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/video/%@.mp4",movieId,movieId]];
}

- (BOOL)pdfExistsAtFolderPath:(NSString *)folderPath numberOfPages:(NSNumber *)numberOfPages {
    folderPath = [_baseFolderPath stringByAppendingPathComponent:folderPath];
    NSString *pagePath = @"";
    for (int i=0; i<[numberOfPages integerValue]; i++) {
        pagePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"page%d.png",i]];
        if (![[NSFileManager defaultManager]fileExistsAtPath:pagePath]) {
            return NO;
        }
    }
    return YES;
}

- (NSArray *)pdfPathsAtFolderPath:(NSString *)folderPath numberOfPages:(NSNumber *)numberOfPages {
    folderPath = [_baseFolderPath stringByAppendingPathComponent:folderPath];
    NSMutableArray *pdfPaths = [[NSMutableArray alloc]init];
    for (int i=0; i<[numberOfPages integerValue]; i++) {
        NSString *pdfPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"page%d.png",i]];
        [pdfPaths addObject:pdfPath];
    }
    return pdfPaths;
}

- (void)downloadVideoWithURL:(NSString *)URL saveToVideoPath:(NSString *)videoPath progress:(void(^)(CGFloat rateOfDidWriteData))progress completionHandler:(void(^)(BOOL success))completionHandler {
    if ([self isReachable]) {
        videoPath = [_baseFolderPath stringByAppendingPathComponent:videoPath];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
            return [documentsDirectoryPath URLByAppendingPathComponent:[targetPath lastPathComponent]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSURL *targetPath = [NSURL fileURLWithPath:videoPath];
            if (!error && filePath) {
                NSError *errorOfFileManager;
                [[NSFileManager defaultManager]copyItemAtURL:filePath toURL:targetPath error:&errorOfFileManager];
                if (errorOfFileManager) {
                    if (!_failDownloadAlertView) {
                        _failDownloadAlertView = [[UIAlertView alloc]initWithTitle:@"下載失敗" message:@"請在網路順暢或wifi狀態下進行下載作業" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles: nil];
                    }
                    [_failDownloadAlertView show];
                    completionHandler(NO);
                }else {
                    [[NSFileManager defaultManager]removeItemAtURL:filePath error:nil];
                    completionHandler(YES);
                }
            }else {
                if (!_failDownloadAlertView) {
                    _failDownloadAlertView = [[UIAlertView alloc]initWithTitle:@"下載失敗" message:@"請在網路順暢或wifi狀態下進行下載作業" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles: nil];
                }
                completionHandler(NO);
                [_failDownloadAlertView show];
            }
        }];
        
        [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            CGFloat rateOfDidWriteData = (CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite;
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(rateOfDidWriteData);
            });
        }];
        
        [downloadTask resume];
    }else {
        if (!_unreachableAlertView) {
            _unreachableAlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"需要網路，請在有3G或WiFi情況下在執行這個動作。" delegate:NULL cancelButtonTitle:@"確定" otherButtonTitles: nil];
        }
        [_unreachableAlertView show];
        completionHandler(NO);
    }
}
#warning 浮水印參數
- (void)downloadPdfWithBasicURL:(NSString *)basicURL pdfURLs:(NSArray *)pdfURLs saveToPdfFolder:(NSString *)pdfFolder progress:(void(^)(CGFloat rateOfDidWriteData))progress completionHandler:(void(^)(BOOL success))completionHandler {
    if ([self isReachable]) {
        __block CGFloat numberOfTotoalPdfs = [pdfURLs count];
        __block int numberOfDidCompleteDownload = 0;
        dispatch_queue_t queue = dispatch_queue_create("com.twoyears44.download", NULL);
        [pdfURLs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            dispatch_async(queue, ^{
                NSString *pdfPath = [_baseFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/page%lu.png",pdfFolder,(unsigned long)idx]];
                NSString *pdfURL = [basicURL stringByAppendingPathComponent:obj];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:pdfURL]]];
                image = [self image:image addWatermarkWithString:[NSString stringWithFormat:@"Bowen\n%@",[self dateString]]];
                if ([UIImageJPEGRepresentation(image, 1.0f) writeToFile:pdfPath atomically:NO]) {
                    numberOfDidCompleteDownload++;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        progress(numberOfDidCompleteDownload/numberOfTotoalPdfs);
                    });
                    if (numberOfDidCompleteDownload == numberOfTotoalPdfs) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionHandler(YES);
                        });
                    }
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!_failDownloadAlertView) {
                            _failDownloadAlertView = [[UIAlertView alloc]initWithTitle:@"下載失敗" message:@"請在網路順暢或wifi狀態下進行下載作業" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles: nil];
                        }
                        [_failDownloadAlertView show];
                        completionHandler(NO);
                    });
                }
            });
        }];
    }else {
        if (!_unreachableAlertView) {
            _unreachableAlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"需要網路，請在有3G或WiFi情況下在執行這個動作。" delegate:NULL cancelButtonTitle:@"確定" otherButtonTitles: nil];
        }
        [_unreachableAlertView show];
        completionHandler(NO);
    }
}

#pragma mark - private

- (UIImage *)image:(UIImage *)image addWatermarkWithString:(NSString *)string {
    
    UIGraphicsBeginImageContext(image.size);
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    [image drawInRect:rect];
    
    CGFloat maxTextHeight = image.size.height/2;
    CGFloat maxTextWidth = image.size.width;
    NSInteger numberOfCharacter = [[[string componentsSeparatedByString:@"\n"] objectAtIndex:1] length];
//    NSLog(@"maxTextHeight:%f maxTextWidth:%f numberOfC:%d",maxTextHeight,maxTextWidth,numberOfCharacter);
    CGFloat fontSize = maxTextHeight;
    if (fontSize*numberOfCharacter > maxTextWidth) {
        fontSize = maxTextWidth/numberOfCharacter;
    }
    
    [[UIColor colorWithRed:0.42 green:0.82 blue:1 alpha:0.5f] set];
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
//    NSLog(@"pointSize:%f \n capHeight:%f \n xHeight:%f lineHeight:%f",font.pointSize,font.capHeight,font.xHeight, font.lineHeight);
    
    [string drawInRect:CGRectInset(rect, 0, image.size.height/4) withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSString *)dateString {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-M-d"];
    return [formatter stringFromDate:date];
}

//- (UIImage *)burnTextIntoImage:(NSString *)text :(UIImage *)img {
//    
//    UIGraphicsBeginImageContext(img.size);
//    
//    CGRect aRectangle = CGRectMake(0,0, img.size.width, img.size.height);
//    [img drawInRect:aRectangle];
//    
//    [[UIColor redColor] set];           // set text color
//    NSInteger fontSize = 14;
//    if ( [text length] > 200 ) {
//        fontSize = 10;
//    }
//    UIFont *font = [UIFont boldSystemFontOfSize: fontSize];     // set text font
//    
//    [ text drawInRect : aRectangle                      // render the text
//             withFont : font
//        lineBreakMode : UILineBreakModeTailTruncation  // clip overflow from end of last line
//            alignment : UITextAlignmentCenter ];
//    
//    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();   // extract the image
//    UIGraphicsEndImageContext();     // clean  up the context.
//    return theImage;
//}

- (NSDictionary *)parseJson:(id)json {
    NSError *error;
    NSDictionary *jsonParseResult = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
    if (!error) {
        return jsonParseResult;
    }
    return @{@"file": @"empty"};
}

- (void)dealloc {
    
}

@end
