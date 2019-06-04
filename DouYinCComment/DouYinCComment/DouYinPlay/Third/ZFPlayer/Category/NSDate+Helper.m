//
//  NSDate+Helper.m
//  DouYinCComment
//
//  Created by 唐天成 on 2019/5/29.
//  Copyright © 2019 唐天成. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

//传一个字符串日期 比如 2017-10-16 19:14:58,返回几分钟前这样的
+ (NSString *)intervalFromNoewDateWithString:(NSString *)dateString {
    
    @try {
        // ------实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里的格式必须和DateString格式一致
        
        NSDate * nowDate = [NSDate date];
        
        // ------将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        
        // ------取当前时间和转换时间两个日期对象的时间间隔
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //            NSLog(@"time----%f",time);
        // ------再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = [[NSString alloc] init];
        
        if (time<=60) {  //1分钟以内的
            
            dateStr = @"刚刚";
            
        }else if(time<=60*60){  //一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        }else if(time<=60*60*24){  //在两天内的
            
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else{
                //昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                //在同一年
                [dateFormatter setDateFormat:@"MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}


@end
