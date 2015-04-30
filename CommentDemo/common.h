//
//  common.h
//  CommentDemo
//
//  Created by 徐佳俊 on 15/4/26.
//  Copyright (c) 2015年 morrison. All rights reserved.
//

#ifndef CommentDemo_common_h
#define CommentDemo_common_h

#define RGBCOLOR(r,g,b)                 [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define NAVIGATION_COLOR                RGBCOLOR(0, 188, 212)

#define DEFAULT_FONT(fontSize)          [UIFont fontWithName:@"STHeitiSC-Light" size:fontSize]
#define DEFAULT_FONT_BOLD(fontSize)     [UIFont fontWithName:@"STHeitiTC-Medium" size:fontSize]
#define FONT_PX2PT(px)                  (px / 2.0)

#define TEST_UID_ME                     @"00dd350b15ddd6000e9fb4df"
#define TEST_NAME_ME                    @"佳俊"

#define TEST_UID_1                      @"54ab350b15ddd6000e9fb4df"
#define TEST_NAME_1                     @"老姜"

#define TEST_UID_2                      @"1233350b15ddd6000e9fb4df"
#define TEST_NAME_2                     @"弘哥"

#define TEST_UID_3                      @"1df3350b15ddd6000e9fb4df"
#define TEST_NAME_3                     @"总管"

#endif
