//
//  ViewController.h
//  CommentDemo
//
//  Created by 徐佳俊 on 15/4/26.
//  Copyright (c) 2015年 morrison. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommentView.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
    CommentView *_viewMain;
    
    // Data Source
    NSMutableArray *_comments;
}


@end

