//
//  ViewController.m
//  TesseractDemo
//
//  Created by Kai Banks on 7/15/15.
//  Copyright (c) 2015 Simply Hired. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Charlie: set up labels, etc here
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                              delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        [myAlertView show];
    }
    
}

-(void) viewDidAppear:(BOOL)animated
{
    // called when the view shows up
    
    UIImage *imageToRecognize = [UIImage imageNamed:@"testingImage.png"];
    
    /*
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng" engineMode:G8OCREngineModeTesseractOnly];
    tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;
    tesseract.charBlacklist =@"";
    tesseract.charWhitelist = @"";
    tesseract.delegate = self;
    
    tesseract.image = [self gs_convert_image:imageToRecognize];
    [tesseract recognize];
    
    NSString *recognizedText = tesseract.recognizedText;
    NSLog(@"%@", recognizedText);
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// this does the trick to have tesseract accept the UIImage.
- (UIImage *) gs_convert_image: (UIImage *) src_img
{
    CGColorSpaceRef d_colorSpace = CGColorSpaceCreateDeviceRGB();
    /*
     * Note we specify 4 bytes per pixel here even though we ignore the
     * alpha value; you can't specify 3 bytes per-pixel.
     */
    size_t d_bytesPerRow = src_img.size.width * 4;
    unsigned char * imgData = (unsigned char*)malloc(src_img.size.height*d_bytesPerRow);
    CGContextRef context =  CGBitmapContextCreate(imgData, src_img.size.width,
                                                  src_img.size.height,
                                                  8, d_bytesPerRow,
                                                  d_colorSpace,
                                                  (CGBitmapInfo) kCGImageAlphaNoneSkipFirst);
    
    UIGraphicsPushContext(context);
    // These next two lines 'flip' the drawing so it doesn't appear upside-down.
    CGContextTranslateCTM(context, 0.0, src_img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    // Use UIImage's drawInRect: instead of the CGContextDrawImage function, otherwise you'll have issues when the source image is in portrait orientation.
    [src_img drawInRect:CGRectMake(0.0, 0.0, src_img.size.width, src_img.size.height)];
    UIGraphicsPopContext();
    
    /*
     * At this point, we have the raw ARGB pixel data in the imgData buffer, so
     * we can perform whatever image processing here.
     */
    
    
    // After we've processed the raw data, turn it back into a UIImage instance.
    CGImageRef new_img = CGBitmapContextCreateImage(context);
    UIImage * convertedImage = [[UIImage alloc] initWithCGImage:
                                new_img];
    
    CGImageRelease(new_img);
    CGContextRelease(context);
    CGColorSpaceRelease(d_colorSpace);
    free(imgData);
    return convertedImage;
}

/**
 *  This function is part of Tesseract's delegate. It will be called
 *  periodically as the recognition happens so you can observe the progress.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 */
- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract
{
    NSLog(@"Progress: %lu percent", (unsigned long)tesseract.progress);
}

/**
 *  This function is part of Tesseract's delegate. It will be called
 *  periodically as the recognition happens so you can cancel the recogntion
 *  prematurely if necessary.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 *
 *  @return Whether or not to cancel the recognition.
 */
- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    return NO;  // return YES, if you need to cancel recognition prematurely
}
- (IBAction)clearCache:(id)sender
{
    [G8Tesseract clearCache];
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController: picker animated: YES completion: NULL];
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController: picker animated: YES completion: NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
