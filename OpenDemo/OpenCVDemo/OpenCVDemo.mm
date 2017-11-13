//
//  OpenCVDemo.m
//  OpenDemo
//
//  Created by QMTV on 16/9/18.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "OpenCVDemo.h"

@interface OpenCVDemo ()

@end

@implementation OpenCVDemo

- (cv::Mat)creatMat {
    cv::Mat M(10, 2, CV_8UC3, cvScalar(0.0, 125.0, 125.0));
    
//    std::cout << "M = " << std::endl << "  " << M << std::endl << std::endl;
    std::cout << "M (csv) = " << std::endl << format(M,"csv"   ) << std::endl << std::endl;
    
    return M;
}

- (void)lookUpTableTest {
    int divideWith = 10; // convert our input string to number - C++ style
    uchar table[256];
    for (int i = 0; i < 256; ++i) {
        table[i] = divideWith* (i/divideWith);
    }
    cv::Mat I, J;
    
    I = [self creatMat];
    
    cv::Mat lookUpTable(1, 256, CV_8U);
    uchar *p = lookUpTable.data;
    
    for (int i = 0; i < 256; ++i) {
        p[i] = table[i];
    }
    
    cv::LUT(I, lookUpTable, J);
    
//    std::cout << "lookUpTable = " << std::endl << lookUpTable << std::endl;
}

@end
