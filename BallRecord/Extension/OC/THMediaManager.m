//
//  THMediaManager.m
//  BallRecord
//
//  Created by 买超 on 2020/3/9.
//  Copyright © 2020 maichao. All rights reserved.
//

#import "THMediaManager.h"
#import <AVFoundation/AVFoundation.h>


@implementation THMediaManager

+ (void)cropWithVideoUrlStr:(NSURL *)videoUrl start:(CGFloat)startTime end:(CGFloat)endTime completion:(void (^)(NSURL *outputURL, Float64 videoDuration, BOOL isSuccess))completionHandle
{
    AVURLAsset *asset =[[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    
    //获取视频总时长
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *outputFilePath = [NSString stringWithFormat:@"%@/%@.mp4", docDirPath , [self getCurrentTime]];
    NSURL *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
    {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                               initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
        
        NSURL *outputURL = outputFileUrl;
        
        exportSession.outputURL = outputURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        CMTime start = CMTimeMakeWithSeconds(startTime, asset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(endTime,asset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    NSLog(@"合成失败：%@", [[exportSession error] description]);
                    completionHandle(outputURL, endTime, NO);
                }
                    break;
                case AVAssetExportSessionStatusCancelled:
                {
                    completionHandle(outputURL, endTime, NO);
                }
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    completionHandle(outputURL, endTime, YES);
                }
                    break;
                default:
                {
                    completionHandle(outputURL, endTime, NO);
                } break;
            }
        }];
    }
}

//获取当前时间
+ (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}


@end
