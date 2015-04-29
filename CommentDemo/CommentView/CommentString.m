//
//  CommentString.m
//  CommentDemo
//
//  Created by 徐佳俊 on 15/4/29.
//  Copyright (c) 2015年 morrison. All rights reserved.
//

#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

#import "CommentString.h"

#import "common.h"

#define MENTIONED_NUM           3

@implementation CommentString

#pragma mark - 设置

- (void)setComment:(NSString *)comment {
    [self findMentionedRange:comment];
    [self addAttributesToString:comment];
}

#pragma mark - 功能函数

- (NSMutableAttributedString *)addAttributesToString:(NSString *)str {
    NSString *mentionedStr = [[str substringWithRange:_mentionedRange] stringByAppendingString:@" "];
    NSString *commentStr = [str substringWithRange:NSMakeRange(_mentionedRange.location +  _mentionedRange.length, str.length - _mentionedRange.length)];
    
    NSDictionary *attrMentioned = @{ NSForegroundColorAttributeName:NAVIGATION_COLOR };
    NSDictionary *attrComment = @{ NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSAttributedString *attrMentionedStr = [[NSAttributedString alloc] initWithString:mentionedStr attributes:attrMentioned];
    NSAttributedString *attrCommentStr = [[NSAttributedString alloc] initWithString:commentStr attributes:attrComment];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attrMentionedStr];
    [attrStr appendAttributedString:attrCommentStr];
    return  attrStr;
}

- (void)findMentionedRange:(NSString *)str {
    _mentionedRange = NSMakeRange(0, MENTIONED_NUM);
}

@end
