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

- (id)initWithSenderInfo:(NSDictionary *)info {
    self = [super init];
    if (self) {
        _senderUidToName = [[NSDictionary alloc] initWithDictionary:info];
        _uidToNames = [[NSMutableArray alloc] init];
        _originRanges = [[NSMutableArray alloc] init];
        _originMsg = [[NSMutableString alloc] init];
        _displayRanges = [[NSMutableArray alloc] init];
        _displayMsg = [[NSMutableString alloc] init];
    }
    return self;
}

#pragma mark - 方法

- (NSRange)locationInDisplayRanges:(NSUInteger)loc {
    NSRange range;
    for (NSValue *v in _displayRanges) {
        range = [v rangeValue];
        if ([self location:loc isInRange:range])
            return range;
    }
    return NSMakeRange(0, 0);
}

- (BOOL)location:(NSUInteger)loc isInRange:(NSRange)range {
    return loc >= (range.location + 1) && loc < (range.location + range.length);
}

- (void)setOriginMsg:(NSMutableString *)originMsg {
    _originMsg = [originMsg mutableCopy];
    [self originToDisplay];
}

- (void)setDisplayMsg:(NSMutableString *)displayMsg {
    _displayMsg = [displayMsg mutableCopy];
    
    // 同步origin
    [self displayToOrigin];
}

- (NSAttributedString *)getAttributedDisplayMsg {
    NSRange range;
    NSUInteger begin = 0;
    NSUInteger end = 0;

    NSMutableAttributedString *ret = [[NSMutableAttributedString alloc] init];
    
    for (NSValue *v in _displayRanges) {
        range = [v rangeValue];
        end = range.location;
        [ret appendAttributedString:[[NSAttributedString alloc] initWithString:[_displayMsg substringWithRange:NSMakeRange(begin, end - begin)]]];
        
        [ret appendAttributedString:[ReplyMessage addAttribute:[_displayMsg substringWithRange:range]]];
        begin = end + range.length;
    }
    end = _displayMsg.length;
    [ret appendAttributedString:[[NSAttributedString alloc] initWithString:[_displayMsg substringWithRange:NSMakeRange(begin, end - begin)]]];
    
    return ret;
}

- (void)showMsgs {
    NSLog(@"ORIGIN: %@", _originMsg);
    NSLog(@"DISPLAY: %@", _displayMsg);
}

- (void)showDetail {
    NSLog(@"===ORIGIN:");
    for (NSValue *v in _originRanges) {
        NSRange r = [v rangeValue];
        NSLog(@"%@", [_originMsg substringWithRange:r]);
    }
    NSLog(@"===", nil);
    
    NSLog(@"===DISPLAY:");
    for (NSValue *v in _displayRanges) {
        NSRange r = [v rangeValue];
        NSLog(@"%@", [_displayMsg substringWithRange:r]);
    }
    NSLog(@"===", nil);
}

- (void)originToDisplay {
    NSArray *results = [ReplyMessage searchPattern:_originMsg];
    NSUInteger begin = 0;
    NSUInteger end = 0;
    for (NSTextCheckingResult *res in results) {
        // 非@内容
        end = res.range.location;
        [_displayMsg appendString:[ReplyMessage escapeSinglePartToDisplay:_originMsg withRange:NSMakeRange(begin, end - begin)]];
        // @内容
        NSString *uid = [self getUIDFromRegResult:[_originMsg substringWithRange:res.range]];
        NSString *name = [self uidToName:uid];
        [_uidToNames addObject:@{ uid : name}];
        
        NSString *displayMention = [NSString stringWithFormat:@"@%@ ", name];
        [_originRanges addObject:[NSValue valueWithRange:res.range]];
        [_displayRanges addObject:[NSValue valueWithRange:NSMakeRange(_displayMsg.length, displayMention.length)]];
        
        [_displayMsg appendString:displayMention];
        begin = end + res.range.length;
    }
    // 非@内容
    end = _originMsg.length;
    [_displayMsg appendString:[ReplyMessage escapeSinglePartToDisplay:_originMsg withRange:NSMakeRange(begin, end - begin)]];
    
//    [self showDetail];
//    [self showMsgs];
}

- (void)displayToOrigin {
    [_originMsg setString:@""];
    [_originRanges removeAllObjects];
    
    NSRange range;
    NSUInteger begin = 0;
    NSUInteger end = 0;
    for (NSValue *value in _displayRanges) {
        range = [value rangeValue];
        // 非@内容
        end = range.location;
        [_originMsg appendString:[ReplyMessage escapeSinglePartToOrigin:_displayMsg withRange:NSMakeRange(begin, end - begin)]];
        // @内容
        NSString *uid = [_uidToNames[[_displayRanges indexOfObject:value]] allKeys][0];
        NSString *originMention = [NSString stringWithFormat:@"@%@ ", uid];
        [_originRanges addObject:[NSValue valueWithRange:NSMakeRange(_originMsg.length, originMention.length)]];
        [_originMsg appendString:originMention];
        
        begin = end + range.length;
    }
    // 非@内容
    end = _displayMsg.length;
    [_originMsg appendString:[ReplyMessage escapeSinglePartToOrigin:_displayMsg withRange:NSMakeRange(begin, end - begin)]];
    
//    [self showDetail];
    [self showMsgs];
}

- (void)addMentionToDisplayWithUID:(NSString *)uid andName:(NSString *)name {
    [_uidToNames addObject:@{ uid : name }];
    
    NSString *displayMention = [NSString stringWithFormat:@"@%@ ", name];
    [_displayRanges addObject:[NSValue valueWithRange:NSMakeRange(_displayMsg.length, displayMention.length)]];
    [_displayMsg appendString:displayMention];
    
    [self displayToOrigin];
}

- (void)updateDisplayMsgWithText:(NSString *)text inRange:(NSRange)range {
    NSRange displayRange;
    NSUInteger displayBegin;
    NSUInteger displayEnd;
    
    NSUInteger rangeBegin = range.location;
    NSUInteger rangeEnd = range.location + range.length;
    
    NSMutableArray *rangesToDelete = [[NSMutableArray alloc] init];
    
    for (NSValue *v in _displayRanges) {
        displayRange = [v rangeValue];
        displayBegin = displayRange.location;
        displayEnd = displayRange.location + displayRange.length;
        for (NSUInteger i = displayBegin + 1; i < displayEnd; i++) {
            if (i >= rangeBegin && i <= rangeEnd) {
//                [self deleteOneMentionInDisplay:displayRange withBegin:rangeBegin];
                [rangesToDelete addObject:[NSNumber numberWithUnsignedInteger:[_displayRanges indexOfObject:v]]];
                break;
            }
        }
    }
    
    if (rangesToDelete.count > 0) {
        [self deleteMentionsInDisplay:rangesToDelete withDeleteLen:(range.length - text.length)];
    } else {
        // 对于没有删除的，把当前位置之后的所有range更新位置
        NSUInteger firstIndexToUpdate = _displayRanges.count;
        for (NSValue *v in _displayRanges) {
            displayRange = [v rangeValue];
            displayBegin = displayRange.location;
            if (rangeEnd <= displayBegin) {
                firstIndexToUpdate = [_displayRanges indexOfObject:v];
                break;
            }
        }
        if (firstIndexToUpdate < _displayRanges.count) {
            for (; firstIndexToUpdate < _displayRanges.count; firstIndexToUpdate ++) {
                NSValue *v = _displayRanges[firstIndexToUpdate];
                NSRange r = [v rangeValue];
                _displayRanges[firstIndexToUpdate] = [NSValue valueWithRange:NSMakeRange(r.location - (range.length - text.length), r.length)];
            }
        }
    }
    
    NSMutableString *oldDisplayMsg = [_displayMsg mutableCopy];
    _displayMsg = [[oldDisplayMsg substringToIndex:range.location] mutableCopy];
    [_displayMsg appendString:text];
    [_displayMsg appendString:[oldDisplayMsg substringFromIndex:range.location + range.length]];
    
    [self displayToOrigin];
    
//    [self showMsgs];
}

- (void)deleteMentionsInDisplay:(NSArray *)indexs withDeleteLen:(NSUInteger)lenDelete {
    NSUInteger lastDeleteIndex = [[indexs lastObject] unsignedIntegerValue];
    if (lastDeleteIndex < _displayRanges.count - 1) {
        for (NSUInteger i = lastDeleteIndex + 1; i < _displayRanges.count; i ++) {
            NSValue *v = _displayRanges[i];
            NSRange r = [v rangeValue];
            _displayRanges[i] = [NSValue valueWithRange:NSMakeRange(r.location - lenDelete, r.length)];
        }
    }
    
    for (NSUInteger i = 0; i < indexs.count; i ++) {
        [_displayRanges removeObjectAtIndex:[indexs[0] unsignedIntegerValue]];
        [_originRanges removeObjectAtIndex:[indexs[0] unsignedIntegerValue]];
        [_uidToNames removeObjectAtIndex:[indexs[0] unsignedIntegerValue]];
    }
}

//- (void)deleteOneMentionInDisplay:(NSRange)range withBegin:(NSUInteger)begin {
//    NSUInteger deleteIndex = [_displayRanges indexOfObject:[NSValue valueWithRange:range]];
//    
//    NSUInteger lenDelete = (range.location >= begin) ? range.length : range.location + range.length - begin;
//    
//    // 对之后的range进行更新
//    if (deleteIndex < _displayRanges.count - 1) {
//        for (NSUInteger i = deleteIndex + 1; i < _displayRanges.count; i ++) {
//            NSValue *v = _displayRanges[i];
//            NSRange r = [v rangeValue];
//            _displayRanges[i] = [NSValue valueWithRange:NSMakeRange(r.location - lenDelete, r.length)];
//        }
//    }
//    [_displayRanges removeObjectAtIndex:deleteIndex];
//    [_originRanges removeObjectAtIndex:deleteIndex];
//    [_uidToNames removeObjectAtIndex:deleteIndex];
//}

//- (void)deleteMentionInDisplay:(NSRange)range {
//    NSUInteger deleteIndex = [_displayRanges indexOfObject:[NSValue valueWithRange:range]];
//    
//    // 对所有之后的range更新位置
//    if (deleteIndex < _displayRanges.count - 1) {
//        for (NSUInteger i = deleteIndex + 1; i < _displayRanges.count; i ++) {
//            NSValue *v = _displayRanges[i];
//            NSRange r = [v rangeValue];
//            _displayRanges[i] = [NSValue valueWithRange:NSMakeRange(r.location - range.length, r.length)];
//        }
//    }
//    // 删除对应range
//    [_uidToNames removeObjectAtIndex:deleteIndex];
//    [_displayRanges removeObjectAtIndex:deleteIndex];
//    [_originRanges removeObjectAtIndex:deleteIndex];
//}

/**
 *  将正则表达式匹配的<@"@uid ">（最后有一个space）中提取uid
 */
- (NSString *)getUIDFromRegResult:(NSString *)regRes {
    NSString *trimmed = [regRes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [trimmed substringFromIndex:1];
}

- (void)clearReplyMsg {
    // sender信息不用改
    [_uidToNames removeAllObjects];
    [_displayRanges removeAllObjects];
    [_originRanges removeAllObjects];
    
    [_displayMsg setString:@""];
    [_originMsg setString:@""];
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

+ (NSMutableAttributedString *)addAttribute:(NSString *)str {
    NSDictionary *attrDicMention = @{ NSForegroundColorAttributeName:NAVIGATION_COLOR };
    NSAttributedString *attrStrMention = [[NSAttributedString alloc] initWithString:str attributes:attrDicMention];
    return [[NSMutableAttributedString alloc] initWithAttributedString:attrStrMention];
}

#pragma mark - 公用方法

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
    return [part stringByReplacingOccurrencesOfString:@"@" withString:@"[@]"];
}

+ (NSString *)escapeSinglePartToDisplay:(NSString *)str withRange:(NSRange)range {
    NSString *part = [str substringWithRange:range];
    return [part stringByReplacingOccurrencesOfString:@"[@]" withString:@"@"];
}

@end
