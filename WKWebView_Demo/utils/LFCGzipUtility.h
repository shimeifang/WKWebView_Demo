//
//  LFCGzipUtility.h
//  WorkFrameDemo
//
//  Created by admin on 2017/10/27.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zlib.h"
@interface LFCGzipUtility : NSObject

/*
 数据压缩参考:http://www.clintharris.net/2009/how-to-gzip-data-in-memory-using-objective-c/
 +(NSData*) gzipData: (NSData*)pUncompressedData;//数据压缩
 */
// 数据压缩

//+ (NSData *)compressData:(NSData*)uncompressedData;

// 数据解压缩

//+ (NSData *)decompressData:(NSData *)compressedData;

+(LFCGzipUtility*)shareGzip;
//压缩
+ (NSString *)gzipDicData:(NSDictionary *)dicData;
- (NSData *)gzipData:(NSData *)pUncompressedData;

// 数据解压
+(NSDictionary *)uncompressZippedStr:(NSString *)gzipStr;
- (NSData *)uncompressZippedData:(NSData *)compressedData;
#pragma mark -- md5加密
+ (NSString *) md5:(NSString *) input;
@end
