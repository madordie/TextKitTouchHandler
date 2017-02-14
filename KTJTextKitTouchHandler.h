//
//  KTJTextKitTouchHandler.h
//  
//
//  Created by 孙继刚 on 16/5/31.
//  Copyright © 2016年 madordie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTJTextKitTouchItem;


@interface KTJTextKitTouchHandler : NSObject

@property (nonatomic, copy) NSArray<KTJTextKitTouchItem *> *touchItems;

- (instancetype)initWithTextView:(UITextView *)view;

//  判断点是否击中KTJTextKitTouchHandler.touchItems.anyone.attributeName = KTJTextKitTouchHandlerAttributeName
- (KTJTextKitTouchItem *)touchAtPoint:(CGPoint)point;

@end


@interface KTJTextKitTouchItem : NSObject

@property (nonatomic, copy) NSString *attributeName; //  Default KTJTextKitTouchHandlerAttributeName.

@property (nonatomic, strong) id value;

@property (nonatomic, assign) NSRange range;

+ (instancetype)itemWithAttributeName:(NSString *)attName value:(id)value rang:(NSRange)rang;

@end


extern NSString *const KTJTextKitTouchHandlerAttributeName;


#if 0

- (void)tapAction:(UITapGestureRecognizer *)tap {
    KTJTextKitTouchItem *item = [_touchHandle touchAtPoint:[tap locationInView:self.textView]];
    if (item) {
        NSLog(@"%@", item.value);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_textView];
    _touchHandle = [[KTJTextKitTouchHandler alloc] initWithTextView:_textView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_textView addGestureRecognizer:tap];
    _textView.editable = NO;
    
    NSMutableAttributedString *mAttString = [[NSMutableAttributedString alloc] initWithString:@"123456789@0234"];
    _textView.attributedText = mAttString;
    
    
    KTJTextKitTouchItem *item = [[KTJTextKitTouchItem alloc] init];
    item.attributeName = KTJTextKitTouchHandlerAttributeName;
    item.value = @0;
    item.range = [mAttString.string rangeOfString:@"@0234"];
    _touchHandle.touchItems = @[item];
}
#endif
