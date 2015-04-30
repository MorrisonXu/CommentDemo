//
//  JDTextView.h
//  CommentDemo
//
//  Created by 徐佳俊 on 15/4/30.
//  Copyright (c) 2015年 morrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JDTextViewDelegate <NSObject>

@optional
//- (void)textViewDidDelete:(JDTextView *)textView;
- (BOOL)keyboardInputShouldDelete:(UITextView *)textView;

@end

@interface JDTextView : UITextView <UIKeyInput>

@property (nonatomic, strong)id<JDTextViewDelegate> jdDelegate;

@end
