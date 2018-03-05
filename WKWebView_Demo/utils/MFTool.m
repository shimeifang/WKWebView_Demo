//
//  MFTool.m
//  WorkFrameDemo
//
//  Created by admin on 2017/11/10.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "MFTool.h"

@implementation MFTool

+(id)jsonWithString:(NSString *)jsonString{
    NSAssert(jsonString, @"数据不能为空");
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    NSAssert(!err, @"json解析失败");
    return dic;
    
}

+ (NSString *)dataToJson:(id)data{
    NSAssert(data, @"数据不能为空!");
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonStr;
    
}

+ (BOOL)getBoolWithKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:key];
}
+(void)setBoolWithKey:(NSString *)key value:(BOOL)value{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:value forKey:key];
    [userDefault synchronize];
    
}
+ (NSDictionary *)getDicWithKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults dictionaryForKey:key];
}
+(NSString*)getStringWithKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}
+(void)setStringWithKey:(NSString*)key value:(NSString*)value{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}
+(NSInteger)getIntegerWithKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:key];
}
+(void)setIntegerWithKey:(NSString*)key value:(NSInteger)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}

+ (UIImage *)getImageWithBase64:(NSString *)imageBase64{
    NSData *decodedImageData   = [[NSData alloc] initWithBase64EncodedString:imageBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:decodedImageData];
}
+ (UIImage *)getImageWithURL:(NSString *)imageURL{
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    NSString *database64 = [data base64EncodedStringWithOptions:0];
    NSData *_decodedImageData   = [[NSData alloc] initWithBase64EncodedString:database64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:_decodedImageData];
}

+ (BOOL)isBlankData:(id)data {
    
    if([data isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic = data;
        if(dic.count == 0 || [dic isEqual:[NSNull null]] || dic==nil){
            return YES;
        }
        
    }
    if([data isKindOfClass:[NSArray class]]){
        NSArray *arr = data;
        if(arr==nil || [arr isKindOfClass:[NSNull class]] || arr.count==0){
            return YES;
        }
    }
    if([data isKindOfClass:[NSString class]]){
        NSString *string = data;
        if (string == nil || string == NULL) {
            return YES;
        }
        if ([string isKindOfClass:[NSNull class]]) {
            return YES;
        }
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            return YES;
        }
    }
    
    return NO;
}
+ (BOOL)isBlankString:(NSString *)str {
    
    NSString *string = str;
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}

@end
