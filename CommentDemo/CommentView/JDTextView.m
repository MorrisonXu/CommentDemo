//
//  JDTextView.m
//  CommentDemo
//
//  Created by 徐佳俊 on 15/4/30.
//  Copyright (c) 2015年 morrison. All rights reserved.
//

#import "JDTextView.h"

@implementation JDTextView

//- (void)deleteBackward {
//    [super deleteBackward];
//    
//    if ([_jdDelegate respondsToSelector:@selector(textViewDidDelete:)]) {
//        [_jdDelegate textViewDidDelete:self];
//    }
//}

- (BOOL)keyboardInputShouldDelete:(UITextView *)textView {
    BOOL shouldDelete = YES;
    
    if ([UITextView instancesRespondToSelector:_cmd]) {
        BOOL (*keyboardInputShouldDelete)(id, SEL, UITextView *) = (BOOL (*)(id, SEL, UITextView *))[UITextView instanceMethodForSelector:_cmd];
        
        if (keyboardInputShouldDelete) {
            shouldDelete = keyboardInputShouldDelete(self, _cmd, textView);
        }
    }
    
    BOOL isIos8 = ([[[UIDevice currentDevice] systemVersion] intValue] == 8);
    BOOL isLessThanIos8_3 = ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.3f);
    
    if (![textView.text length] && isIos8 && isLessThanIos8_3) {
        [self deleteBackward];
    }
    
    return shouldDelete;
}

- (void)deleteBackward {
    BOOL shouldDismiss = [self.text length] == 0;
    
    [super deleteBackward];
    
    if (shouldDismiss) {
        if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            [self.delegate textView:self shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@""];
        }
    }
}

@end
