//
//  THMediaManager.h
//  BallRecord
//
//  Created by 买超 on 2020/3/9.
//  Copyright © 2020 maichao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THMediaManager : NSObject

+ (void)cropWithVideoUrlStr:(NSURL *)videoUrl start:(CGFloat)startTime end:(CGFloat)endTime completion:(void (^)(NSURL *outputURL, Float64 videoDuration, BOOL isSuccess))completionHandle;

@end

NS_ASSUME_NONNULL_END
