//
//  MYContentView.m
//  魔颜
//
//  Created by Meiyue on 16/5/23.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYContentView.h"
#import "MYHeader.h"

@interface MYContentView ()<UIGestureRecognizerDelegate>

@end

@implementation MYContentView

- (void)injected
{
    NSLogFunc;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        [self setupUI];
    }
    return self;
}


- (void)setupUI
{
    UILabel *titleLabel = [UILabel addLabelWithFrame:CGRectMake(0, 15, self.width, 25) title:@"您未安装qq呦~请选择以下方式" titleColor:UIColorFromRGB(0x1a1a1a) font:MYSFont(15)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(MYMargin, self.height * 0.3, self.width - MYMargin * 2, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [self addSubview:lineView];

    NSArray *imageArr = @[@"dianhua",@"QQ",@"weChat"];
    NSArray *nameArr =  @[@"010-56011270",@"3308321066",@"my18810293258"];
    
    for (int i = 0 ; i < 3; i ++ ) {
        
        CGFloat imageH = self.height * 0.2;
        CGFloat imageY = lineView.bottom + self.height * 0.06 + i * imageH;
        
        UIImageView *image = [UIImageView addImaViewWithFrame:CGRectMake(self.width * 0.15, imageY, 30, 30) imageName:imageArr[i]];
        [self addSubview:image];
        
        UILabel *label = [UILabel addLabelWithFrame:CGRectMake(image.right + 30, image.y - self.height * 0.025, 130, imageH) title:nameArr[i] titleColor:UIColorFromRGB(0x4c4c4c) font:MYSFont(15)];
        label.userInteractionEnabled = YES;
        [self addSubview:label];
        
        if (i == 0) {
            
            UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(call)];
            tap.numberOfTapsRequired = 1;
            tap.delegate= self;
            [label addGestureRecognizer:tap];
            
        }
    }
    
}

- (void)call
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://010-56011270"]];
}


@end
