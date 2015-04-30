//
//  ReplyMessage.h
//  RegularExpressionDemo
//
//  Created by 徐佳俊 on 15/4/29.
//  Copyright (c) 2015年 morrison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyMessage : NSObject

@property (nonatomic, strong)NSDictionary *senderUidToName;

@property (nonatomic, strong)NSMutableArray *uidToNames;

// Escaped
@property (nonatomic, strong)NSMutableArray *originRanges;
@property (nonatomic, strong)NSMutableString *originMsg;
// Displayed
@property (nonatomic, strong)NSMutableArray *displayRanges;
@property (nonatomic, strong)NSMutableAttributedString *displayMsg;

- (void)setOriginMsg:(NSString *)originMsg;

- (void)addMentionToDisplayWithUID:(NSString *)uid andName:(NSString *)name;

//- (void)analyzeAndSetDisplayMsg;
//+ (NSString *)escapeString:(NSString *)str;

@end