//
//  ViewController.h
//  TesseractProject
//
//  Created by Charlie Wang on 7/16/15.
//  Copyright (c) 2015 Charlie Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TesseractOCR/TesseractOCR.h"

@interface ViewController : UIViewController <G8TesseractDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;


@end
