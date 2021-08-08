//
//  ExtAudioConverter.h
//  ExtAudioConverter
//
//  Created by 李 行 on 15/4/9.
//  Copyright (c) 2015年 lixing123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

enum BitDepth{
    BitDepth_8  = 8,
    BitDepth_16 = 16,
    BitDepth_24 = 24,
    BitDepth_32 = 32
};

//TODO:Add delegate

@interface ExtAudioConverter : NSObject

//Must set
@property(nonatomic,retain)NSString* inputFile;//Absolute path
@property(nonatomic,retain)NSString* outputFile;//Absolute path

//optional
@property(nonatomic,assign)int outputSampleRate;//Default 44100.0
@property(nonatomic,assign)int outputNumberChannels;//Default 2
@property(nonatomic,assign)enum BitDepth outputBitDepth;//Default BitDepth_16
@property(nonatomic,assign)AudioFormatID outputFormatID;//Default Linear PCM
@property(nonatomic,assign)AudioFileTypeID outputFileType;//Default kAudioFileCAFType
//TODO:add bit rate parameter

-(BOOL)convert;

@end
