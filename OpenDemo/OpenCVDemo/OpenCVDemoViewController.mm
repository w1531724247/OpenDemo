//
//  OpenCVDemoViewController.m
//  OpenDemo
//
//  Created by QMTV on 16/9/18.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "OpenCVDemoViewController.h"
#import "OpenCVDemo.h"
#import "UIImage+OpenCV.h"

@interface OpenCVDemoViewController ()

@property (nonatomic, strong) OpenCVDemo *cvDemo;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation OpenCVDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.imageView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self demo1];
//    [self demo2];
    [self demo3];
}

- (void)demo1 {
    cv::Mat mat = [self.cvDemo creatMat];
    UIImage *image = [UIImage imageFromCVMat:mat];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imageView];
    imageView.center = self.view.center;
}

- (void)demo2 {
    [self.cvDemo lookUpTableTest];
}

/**
 *  获取图像中任意像素的值,并改变该像素的值
 */
- (void)demo3 {
    UIImage *image = [UIImage imageNamed:@"meinv.jpg"];
    
    cv::Mat mat = [image cvMatFromUIImage:image];
    
    NSLog(@"mat.rows = %d", mat.rows);
    NSLog(@"mat.cols = %d", mat.cols);
    
    for (int row = 0; row < mat.rows; row++)
    {
        for (int col = 0; col < mat.cols; col++)
        {
            /* 注意 Mat::at 函数是个模板函数, 需要指明参数类型, 因为这张图是具有红蓝绿三通道的图,
             所以它的参数类型可以传递一个 Vec3b, 这是一个存放 3 个 uchar 数据的 Vec(向量). 这里
             提供了索引重载, [2]表示的是返回第三个通道, 在这里是 Red 通道, 第一个通道(Blue)用[0]返回 */
            if(row > 50 && row < 100 && col > 50 && col < 100) {
                mat.at<cv::Vec4b>(row, col) = cv::Vec4b(255, 0, 0, 1);
            }
        }
    }
    
    UIImage *newImage = [UIImage imageFromCVMat:mat];
    
    self.imageView.image = newImage;
    self.imageView.bounds = CGRectMake(0.0, 0.0, mat.cols, mat.rows);
    self.imageView.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---- getter 

- (OpenCVDemo *)cvDemo {
    if (!_cvDemo) {
        _cvDemo = [[OpenCVDemo alloc] init];
    }
    return _cvDemo;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
