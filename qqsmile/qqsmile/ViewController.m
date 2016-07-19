//
//  ViewController.m
//  qqsmile
//
//  Created by zhangqi on 12/7/2016.
//  Copyright (c) 2016 zhangqi. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
@property (nonatomic,strong) AVCaptureSession *avCaptureSession;
@property (nonatomic,strong) AVCaptureDevice *captureDevice;
@property (nonatomic,strong) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic,strong) AVCaptureMovieFileOutput *captureMovieFileOutput;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@end

@implementation ViewController

- (AVCaptureSession *)avCaptureSession
{
    if (!_avCaptureSession) {
        _avCaptureSession = [[AVCaptureSession alloc] init];
        _captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
        NSError *error = nil;
        _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
        _captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        
        if ([_avCaptureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            _avCaptureSession.sessionPreset = AVCaptureSessionPreset1280x720;
        }
        
        if ([_avCaptureSession canAddInput:_captureDeviceInput]) {
            [_avCaptureSession addInput:_captureDeviceInput];
        }
        
        AVCaptureConnection *captureConnection=[_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported ]) {
            captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
        }
        
        if ([_avCaptureSession canAddOutput:_captureMovieFileOutput]) {
            [_avCaptureSession addOutput:_captureMovieFileOutput];
        }
    }
    return _avCaptureSession;
}

- (AVCaptureVideoPreviewLayer *)captureVideoPreviewLayer
{
    if (!_captureMovieFileOutput) {
        _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.avCaptureSession];
    }
    return _captureVideoPreviewLayer;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *layer = self.view.layer;
    layer.masksToBounds = YES;
    self.captureVideoPreviewLayer.frame = layer.bounds;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResize;
    [layer insertSublayer:self.captureVideoPreviewLayer below:self.view.layer];
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.avCaptureSession startRunning];
}

-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
            
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
