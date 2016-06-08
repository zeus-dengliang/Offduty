//
//  CollectionViewCell.m
//  Ｏffduty
//
//  Created by ios-dev on 16/5/30.
//  Copyright © 2016年 com.jl. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 20)];
        self.textLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.textLabel];
    }
    return self;
}


@end
