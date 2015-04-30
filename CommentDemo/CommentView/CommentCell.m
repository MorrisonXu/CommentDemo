//
//  CommentCell.m
//  CommentDemo
//
//  Created by 徐佳俊 on 15/4/26.
//  Copyright (c) 2015年 morrison. All rights reserved.
//

#import "CommentCell.h"

#import "layout_comment_cell.h"

#define MENTIONED_NUM           3

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
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Replier
    
    // Mentioned
    
    // Message
}

#pragma mark - 设置

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

#pragma mark - 功能函数

- (NSMutableAttributedString *)addAttributesToString:(NSString *)str {
    NSString *mentionedStr = [self findMentionedString:str];
    NSString *commentStr = [self findCommentString:str];
    
    NSDictionary *attrMentioned = @{ NSForegroundColorAttributeName:NAVIGATION_COLOR };
    NSDictionary *attrComment = @{ NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSAttributedString *attrMentionedStr = [[NSAttributedString alloc] initWithString:mentionedStr attributes:attrMentioned];
    NSAttributedString *attrCommentStr = [[NSAttributedString alloc] initWithString:commentStr attributes:attrComment];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attrMentionedStr];
    [attrStr appendAttributedString:attrCommentStr];
    return  attrStr;
}

- (NSString *)findMentionedString:(NSString *)str {
    if (str.length > MENTIONED_NUM)
        return [[str substringToIndex:MENTIONED_NUM] stringByAppendingString:@" "];
    else
        return str;
}

- (NSString *)findCommentString:(NSString *)str {
    if (str.length > MENTIONED_NUM)
        return [str substringFromIndex:MENTIONED_NUM];
    else
        return @"";
}

@end
