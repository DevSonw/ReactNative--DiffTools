//
//  ViewController.m
//  ReactNativeDiffTools
//
//  Created by Hao on 16/4/14.
//  Copyright © 2016年 RainbowColors. All rights reserved.
//

#import "ViewController.h"
#import "DiffMatchPatch.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)creatBtnClick:(id)sender {
    if (self.oldBundleTextField.stringValue.length==0) {
        self.messageLabel.stringValue = @"Please input old bundle file!";
        return;
    }
    if (self.bundleTextField.stringValue.length==0) {
        self.messageLabel.stringValue = @"Please input new bundle file";
        return;
    }

    NSString *oldBundleString = [self getFileContent:self.oldBundleTextField.stringValue];
    NSString *bundleString = [self getFileContent:self.bundleTextField.stringValue];
    
    //生成Patch
    DiffMatchPatch *match = [[DiffMatchPatch alloc]init];
    
    NSArray *diffArray = [match patch_makeFromOldString:oldBundleString andNewString:bundleString];
    NSData *diffData = [NSKeyedArchiver archivedDataWithRootObject:diffArray];
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSArray * paths = NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES);
    NSString * desktopPath = [paths objectAtIndex:0];
    NSString *filePath =[desktopPath stringByAppendingPathComponent:@"bundle.diff"];
    
    BOOL res =  [fileManger createFileAtPath:filePath contents:diffData attributes:nil];
    if(res)
        self.messageLabel.stringValue = @"Creat Success!";
    else
        self.messageLabel.stringValue = @"Creat Failed!";
    
    //使用Path
    NSArray *currentArray = [match patch_apply:diffArray toString:oldBundleString];
    NSString *currentString = currentArray[0];
    NSLog(@"current:%@",currentString);
    
}

- (NSString*)getFileContent:(NSString*)fileName{
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    NSString *contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return contentString;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

@end
