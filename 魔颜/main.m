//
//  main.m
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

// From here to end of file added by Injection Plugin //

#ifdef DEBUG
static char _inMainFilePath[] = __FILE__;
static const char *_inIPAddresses[] = {"192.168.1.159", "192.168.1.17", "127.0.0.1", 0};

#define INJECTION_ENABLED
#import "/tmp/injectionforxcode/BundleInjection.h"
#endif
