//
//  MFTool.h
//  WorkFrameDemo
//
//  Created by admin on 2017/11/10.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MFTool : NSObject
/**
 json字符转转json格式数据
 */
+(id _Nonnull)jsonWithString:(NSString* _Nonnull)jsonString;
/**
 字典转json字符 .
 */
+(NSString* _Nonnull)dataToJson:(id _Nonnull)data;

/**
 NSUserDefaults封装使用函数.
 */
+(BOOL)getBoolWithKey:(NSString* _Nonnull)key;
+(void)setBoolWithKey:(NSString* _Nonnull)key value:(BOOL)value;
+(NSString* _Nonnull)getStringWithKey:(NSString* _Nonnull)key;
+(NSDictionary* _Nonnull)getDicWithKey:(NSString* _Nonnull)key;
+(void)setStringWithKey:(NSString* _Nonnull)key value:(NSString* _Nonnull)value;
+(NSInteger)getIntegerWithKey:(NSString* _Nonnull)key;
+(void)setIntegerWithKey:(NSString* _Nonnull)key value:(NSInteger)value;
/**
 图片网址转换成图片
 */
+ (UIImage * _Nonnull)getImageWithURL:(NSString * _Nonnull)imageURL;
/**
 Base64字符串转换成图片
 */
+ (UIImage *)getImageWithBase64:(NSString *)imageBase64;

/**
 判断对象是否为空
 */
+ (BOOL)isBlankData:(id)data;
/**
 判断字符串是否为空
 */
+ (BOOL)isBlankString:(NSString *)str;

@end
