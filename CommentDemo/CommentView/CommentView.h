//
//  CommentView.h
//  CommentDemo
//
//  Created by 徐佳俊 on 15/4/26.
//  Copyright (c) 2015年 morrison. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JDTextView.h"

@interface CommentView : UIView

@property (nonatomic, readonly)UITableView *tvContent;
@property (nonatomic, readonly)UIView *vReply;
// In Panel
@property (nonatomic, readonly)UIView *vSep;
@property (nonatomic, readonly)JDTextView *tvInput;
@property (nonatomic, readonly)UIButton *btSend;

@end
