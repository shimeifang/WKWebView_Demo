
//
//  LxxSoundPlay.m
//  soundPlay
//
//  Created by  on 16/3/30.
//  Copyright © 2016年 smf. All rights reserved.
//



#import "LxxSoundPlay.h"
@implementation LxxSoundPlay
-(id)initForPlayingVibrate
{
    self = [super init];
    if (self) {
        soundID = kSystemSoundID_Vibrate;
    }
    return self;
}


-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:resourceName ofType:type];
        
        if (path) {
            
            SystemSoundID theSoundID;
            OSStatus error =  AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSoundID);
            if (error == kAudioServicesNoError) {
                
                soundID = theSoundID;
            }else {
                
                NSLog(@"Failed to create sound ");
            }
        }
    }
    return self;
}



-(id)initForPlayingSoundEffectWith:(NSString *)filename
{
    self = [super init];
    if (self) {
        
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (fileURL != nil)
        {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError){
                soundID = theSoundID;
            }else {
                NSLog(@"Failed to create sound ");
            }
        }
        
        /*
        //音效文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"message" ofType:@"wav"];
        NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
        AudioServicesPlaySystemSound(soundID);
        //声音停止
        AudioServicesDisposeSystemSoundID(soundID);
         */
    }
    return self;
}

-(void)play
{
    AudioServicesPlaySystemSound(soundID);
}

-(void)dealloc
{
    AudioServicesDisposeSystemSoundID(soundID);
}

@end
