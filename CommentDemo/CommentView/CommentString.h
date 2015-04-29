//
//  CommentString.h
//  CommentDemo
//
//  Created by 徐佳俊 on 15/4/29.
//  Copyright (c) 2015年 morrison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentString : NSObject {
    NSRange _mentionedRange;
    
    NSMutableAttributedString *_strComment;
}

- (void)setComment:(NSString *)comment;
- (void)commentDidChanged;

@end
