//
//  KTJTextKitTouchHandler.m
//
//
//  Created by 孙继刚 on 16/5/31.
//  Copyright © 2016年 madordie. All rights reserved.
//

#import "KTJTextKitTouchHandler.h"


@interface KTJTextKitTouchHandler ()

@property (nonatomic, strong) NSLayoutManager *layoutManager;

@property (nonatomic, strong) NSTextContainer *textContainer;

@property (nonatomic, strong) NSTextStorage *textStorage;

@property (nonatomic, weak) UITextView *textView;

@end


@implementation KTJTextKitTouchHandler

- (instancetype)initWithTextView:(UITextView *)view
{
    self = [super init];
    if (self) {
        _textView = view;
    }
    return self;
}

- (void)setTouchItems:(NSArray<KTJTextKitTouchItem *> *)touchItems
{
    if (_touchItems == touchItems) {
        return;
    }
    _touchItems = touchItems.copy;
    [_touchItems enumerateObjectsUsingBlock:^(KTJTextKitTouchItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.attributeName && obj.value) {
            [self.textStorage addAttribute:obj.attributeName value:obj.value range:obj.range];
        }
    }];
}


- (KTJTextKitTouchItem *)touchAtPoint:(CGPoint)location
{
    //  source: https://github.com/kevinzhow/RichTextView/blob/master/RichTextView/Source/RichTextView.swift

    if (self.textStorage == nil && self.textStorage.string.length == 0 && self.touchItems == nil && self.touchItems.count == 0) {
        return nil;
    }

    __block KTJTextKitTouchItem *hitItem = nil;

    [self.textStorage enumerateAttribute:KTJTextKitTouchHandlerAttributeName inRange:NSMakeRange(0, self.textStorage.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        //        if (value)
        {
            NSRange glyphRange = [self.layoutManager glyphRangeForCharacterRange:range actualCharacterRange:nil];

            [self.layoutManager enumerateEnclosingRectsForGlyphRange:glyphRange withinSelectedGlyphRange:NSMakeRange(NSNotFound, 0) inTextContainer:self.textContainer usingBlock:^(CGRect rect, BOOL * _Nonnull stop) {

                rect.origin.x += self.textView.textContainerInset.left;
                rect.origin.y += self.textView.textContainerInset.top;
                rect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(-2, -2, -2, -2));

                if (CGRectContainsPoint(rect, location)) {
                    //                    id value = [self.textStorage attribute:KTJTextKitTouchHandlerAttributeName atIndex:range.location effectiveRange:nil];
                    //                    if (value)
                    {
                        [self.touchItems enumerateObjectsUsingBlock:^(KTJTextKitTouchItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                            if ([obj.attributeName isEqualToString:KTJTextKitTouchHandlerAttributeName]
                                //                                && obj.value == value
                                && NSEqualRanges(range, obj.range)) {
                                hitItem = obj;
                                *stop = YES;
                            }
                        }];
                        if (hitItem != nil) {
                            *stop = YES;
                        }
                    }
                }
            }];
            if (hitItem != nil) {
                *stop = YES;
            }
        }
    }];

    return hitItem;
}

- (NSLayoutManager *)layoutManager
{
    if (_layoutManager == nil) {
        return self.textView.layoutManager;
    }
    return nil;
}
- (NSTextStorage *)textStorage
{
    if (_textStorage == nil) {
        return self.textView.textStorage;
    }
    return nil;
}
- (NSTextContainer *)textContainer
{
    if (_textContainer == nil) {
        return self.textView.textContainer;
    }
    return nil;
}

@end


@implementation KTJTextKitTouchItem

- (NSString *)attributeName
{
    if (_attributeName == nil) {
        return KTJTextKitTouchHandlerAttributeName;
    }
    return _attributeName;
}

+ (instancetype)itemWithAttributeName:(NSString *)attName value:(id)value rang:(NSRange)rang
{
    KTJTextKitTouchItem *item = [KTJTextKitTouchItem new];
    item.attributeName = attName;
    item.value = value;
    item.range = rang;
    return item;
}

@end


NSString *const KTJTextKitTouchHandlerAttributeName = @"KTJTextKitTouchHandlerAttributeName";
