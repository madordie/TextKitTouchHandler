# TextKitTouchHandler
给TextKit增加自定义的点击事件
# 说明 
`UITextView`的超链接不能自定义点击状态等点击属性。此方案提供一种思路：通过寻找点击位置所在的富文本中是否支持 自定义标记链接 来完成自定义点击事件。
# 栗子
```

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
```
