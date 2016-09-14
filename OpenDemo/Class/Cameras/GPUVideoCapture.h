//
//  GPUVideoCapture.h
//  OpenDemo
//
//  Created by QMTV on 16/9/14.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark ----GPUVideoConfiguration
@interface GPUVideoConfiguration : NSObject

@end

#pragma mark ----GPUVideoCapture

@interface GPUVideoCapture : NSObject

- (instancetype)initWithVideoConfiguration:(GPUVideoConfiguration *)configuration;

@end


