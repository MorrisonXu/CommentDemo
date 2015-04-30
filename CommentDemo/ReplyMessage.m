//
//  ReplyMessage.m
//  RegularExpressionDemo
//
//  Created by 徐佳俊 on 15/4/29.
//  Copyright (c) 2015年 morrison. All rights reserved.
//

#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

#import "ReplyMessage.h"

#import "common.h"

#define REG_SEARCH_PATTERN          @"@([0-9a-f]{24})\\s"

@implementation ReplyMessage

- (id)init {
    self = [super init];
    if (self) {
        _uidToNames = [[NSMutableArray alloc] init];
        _originRanges = [[NSMutableArray alloc] init];
        _originMsg = [[NSMutableString alloc] init];
        _displayRanges = [[NSMutableArray alloc] init];
        _displayMsg = [[NSMutableAttributedString alloc] init];
    }
    return self;
}

#pragma mark - 方法

- (void)setOriginMsg:(NSString *)originMsg {
    _originMsg = [originMsg mutableCopy];
    [self originToDisplay];
}

- (void)showDetail {
    NSLog(@"===DISPLAY:");
    for (NSValue *v in _displayRanges) {
        NSRange r = [v rangeValue];
        NSLog(@"%@", [[_displayMsg string] substringWithRange:r]);
    }
    
    NSLog(@"===ORIGIN:");
    for (NSValue *v in _originRanges) {
        NSRange r = [v rangeValue];
        NSLog(@"%@", [_originMsg substringWithRange:r]);
    }
}

- (void)originToDisplay {
    NSArray *results = [ReplyMessage searchPattern:_originMsg];
    NSUInteger begin = 0;
    NSUInteger end = 0;
    for (NSTextCheckingResult *res in results) {
        // 非@内容
        end = res.range.location;
        [_displayMsg appendAttributedString:[[NSAttributedString alloc] initWithString:[ReplyMessage escapeSinglePartToDisplay:_originMsg withRange:NSMakeRange(begin, end - begin)]]];
        // @内容
        NSString *uid = [self getUIDFromRegResult:[_originMsg substringWithRange:res.range]];
        NSString *name = [self uidToName:uid];
        [_uidToNames addObject:@{ uid : name}];
        
        NSString *displayMention = [NSString stringWithFormat:@"@%@ ", name];
        [_originRanges addObject:[NSValue valueWithRange:res.range]];
        [_displayRanges addObject:[NSValue valueWithRange:NSMakeRange(_displayMsg.length, displayMention.length)]];
        
        [_displayMsg appendAttributedString:[ReplyMessage addAttribute:displayMention]];
        begin = end + res.range.length;
    }
    // 非@内容
    end = _originMsg.length;
    [_displayMsg appendAttributedString:[[NSAttributedString alloc] initWithString:[ReplyMessage escapeSinglePartToDisplay:_originMsg withRange:NSMakeRange(begin, end - begin)]]];
    
    [self showDetail];
}

- (void)displayToOrigin {
    NSString *displayString = [_displayMsg string];
    
    NSRange range;
    NSUInteger begin = 0;
    NSUInteger end = 0;
    for (NSValue *value in _displayRanges) {
        range = [value rangeValue];
        // 非@内容
        end = range.location;
        [_originMsg appendString:[ReplyMessage escapeSinglePartToOrigin:displayString withRange:NSMakeRange(begin, end - begin)]];
        // @内容
        NSString *uid = [_uidToNames[[_displayRanges indexOfObject:value]] allKeys][0];
        NSString *originMention = [NSString stringWithFormat:@"@%@ ", uid];
        [_originRanges addObject:[NSValue valueWithRange:NSMakeRange(_originMsg.length, originMention.length)]];
        [_originMsg appendString:originMention];
        
        begin = end + range.length;
    }
    // 非@内容
    end = displayString.length;
    [_originMsg appendString:[ReplyMessage escapeSinglePartToOrigin:displayString withRange:NSMakeRange(begin, end - begin)]];
    
    [self showDetail];
}

- (void)addMentionToDisplayWithUID:(NSString *)uid andName:(NSString *)name {
    [_uidToNames addObject:@{ uid : name }];
    
    NSString *displayMention = [NSString stringWithFormat:@"@%@ ", name];
    [_displayRanges addObject:[NSValue valueWithRange:NSMakeRange(_displayMsg.length, displayMention.length)]];
    [_displayMsg appendAttributedString:[ReplyMessage addAttribute:displayMention]];
    
    [self displayToOrigin];
}

/**
 *  将正则表达式匹配的<@"@uid ">（最后有一个space）中提取uid
 */
- (NSString *)getUIDFromRegResult:(NSString *)regRes {
    NSString *trimmed = [regRes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [trimmed substringFromIndex:1];
}
                          
- (NSString *)uidToName:(NSString *)uid {
    if ([uid isEqualToString:TEST_UID_1]) {
        return TEST_NAME_1;
    } else if ([uid isEqualToString:TEST_UID_2]) {
        return TEST_NAME_2;
    } else if ([uid isEqualToString:TEST_UID_3]) {
        return TEST_NAME_3;
    } else {
        return nil;
    }
}

//- (void)analyzeAndSetDisplayMsg {
//    [self analyze];
//    [self setDisplayMsg];
//}
//
//- (void)analyze {
//    NSArray *results = [ReplyMessage searchPattern:_originMsg];
//    for (NSTextCheckingResult *result in results) {
//        NSString *uid = [_originMsg substringWithRange:result.range];
//        Mentioned *mentionedPart = [[Mentioned alloc] initWithRange:result.range
//                                                                UID:uid
//                                                               Name:[self getNameFromUID:uid]];
//        [_arrMentioned addObject:mentionedPart];
//    }
//}
//
//- (void)setDisplayMsg {
//    NSUInteger partBegin = 0;
//    NSUInteger partEnd = 0;
//    for (Mentioned *item in _arrMentioned) {
//        partEnd = item.range.location;
//        [escaped appendString:[ReplyMessage escapeSinglePart:str withRange:NSMakeRange(partBegin, partEnd - partBegin)]];
//        partBegin = partEnd + result.range.length;
//        [escaped appendString:[str substringWithRange:result.range]];
//    }
//}
//
//- (NSString *)getNameFromUID:(NSString *)uid {
//    return uid;
//}
//
+ (NSMutableAttributedString *)addAttribute:(NSString *)str {
    NSDictionary *attrDic = @{ NSForegroundColorAttributeName:NAVIGATION_COLOR };
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:attrDic];
    return [[NSMutableAttributedString alloc] initWithAttributedString:attrStr];
}

#pragma mark - 公用方法

//+ (NSString *)escapeString:(NSString *)str {
//    NSArray *results = [ReplyMessage searchPattern:str];
//    NSUInteger partBegin = 0;
//    NSUInteger partEnd = 0;
//    NSMutableString *escaped = [[NSMutableString alloc] init];
//    for (NSTextCheckingResult *result in results) {
//        partEnd = result.range.location;
//        [escaped appendString:[ReplyMessage escapeSinglePart:str withRange:NSMakeRange(partBegin, partEnd - partBegin)]];
//        partBegin = partEnd + result.range.length;
//        [escaped appendString:[str substringWithRange:result.range]];
//    }
//    partEnd = str.length - 1;
//    [escaped appendString:[ReplyMessage escapeSinglePart:str withRange:NSMakeRange(partBegin, partEnd - partBegin + 1)]];
//    return escaped;
//}

+ (NSArray *)searchPattern:(NSString *)str {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:REG_SEARCH_PATTERN
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    return [regex matchesInString:str
                          options:0
                            range:NSMakeRange(0, str.length)];
}

+ (NSString *)escapeSinglePartToOrigin:(NSString *)str withRange:(NSRange)range {
    NSString *part = [str substringWithRange:range];
    return [part stringByReplacingOccurrencesOfString:@"@" withString:@"@@"];
}

+ (NSString *)escapeSinglePartToDisplay:(NSString *)str withRange:(NSRange)range {
    NSString *part = [str substringWithRange:range];
    return [part stringByReplacingOccurrencesOfString:@"@@" withString:@"@"];
}

@end