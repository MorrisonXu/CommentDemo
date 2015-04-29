//
//  CommentView.m
//  CommentDemo
//
//  Created by 徐佳俊 on 15/4/26.
//  Copyright (c) 2015年 morrison. All rights reserved.
//

#import "CommentView.h"

#import "layout_comment.h"

@implementation CommentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self create];
    }
    return self;
}

#pragma mark - 构建页面

- (void)create {
    [self createContent];
    [self createComment];
}

- (void)createContent {
    _tvContent = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - REPLY_HEIGHT)];
    
    [self addSubview:_tvContent];
}

- (void)createComment {
    // Panel
    _vReply = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - REPLY_HEIGHT, self.frame.size.width, REPLY_HEIGHT)];
    [_vReply setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_vReply];
    // Sep
    _vSep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _vReply.frame.size.width, REPLY_SEP_HEIGHT)];
    [_vSep setBackgroundColor:REPLY_SEP_COLOR];
    [_vReply addSubview:_vSep];
    // Input
    CGFloat inputWidth = _vReply.frame.size.width - REPLY_INPUT_MARGIN_LEFT - REPLY_SEND_MARGIN_LEFT - REPLY_SEND_MARGIN_RIGHT - REPLY_SEND_WIDTH;
    _tvInput = [[UITextView alloc] initWithFrame:CGRectMake(REPLY_INPUT_MARGIN_LEFT, REPLY_INPUT_MARGIN_TOP, inputWidth, REPLY_INPUT_HEIGHT)];
    CALayer *layerInput = [_tvInput layer];
    layerInput.cornerRadius = REPLY_CORNER_RADIUS;
    layerInput.borderColor = [REPLY_SEP_COLOR CGColor];
    layerInput.borderWidth = 1;
    [_vReply addSubview:_tvInput];
    // Send
    _btSend = [[UIButton alloc] initWithFrame:CGRectMake(_vReply.frame.size.width - REPLY_SEND_MARGIN_RIGHT - REPLY_SEND_WIDTH, REPLY_SEND_MARGIN_TOP, REPLY_SEND_WIDTH, REPLY_SEND_HEIGHT)];
    CALayer *layerSend = [_btSend layer];
    layerSend.cornerRadius = REPLY_CORNER_RADIUS;
    layerSend.borderColor = [REPLY_SEP_COLOR CGColor];
    layerSend.borderWidth = 1;
    _btSend.titleLabel.font = DEFAULT_FONT(FONT_PX2PT(REPLY_SEND_FONT_SIZE_PX));
    _btSend.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btSend setTitle:NSLocalizedStringFromTable(@"Send", @"CommentView", nil) forState:UIControlStateNormal];
    [_btSend setTitleColor:REPLY_SEND_FONT_COLOR forState:UIControlStateNormal];
    [_vReply addSubview:_btSend];
}

@end
