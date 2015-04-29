//
//  CommentCell.m
//  CommentDemo
//
//  Created by 徐佳俊 on 15/4/26.
//  Copyright (c) 2015年 morrison. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self create];
    }
    return self;
}

#pragma mark - 构建页面

- (void)create {
    // Replier
    _lbReplier = [[UILabel alloc] init];
    
    // Mentioned
    
    // Message
}

#pragma mark - 设置

- (void)setFrame:(CGRect)frame {
    
}

@end
