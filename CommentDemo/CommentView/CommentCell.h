//
//  CommentCell.h
//  CommentDemo
//
//  Created by 徐佳俊 on 15/4/26.
//  Copyright (c) 2015年 morrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (nonatomic, readonly)UILabel *lbReplier;
@property (nonatomic, readonly)UILabel *lbMentioned;
@property (nonatomic, readonly)UILabel *lbMessage;

@end
