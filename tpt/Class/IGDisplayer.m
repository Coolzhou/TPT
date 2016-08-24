

#import "IGDisplayer.h"

@interface IGDisplayer()

@property (nonatomic,strong) UIWindow *overlayWindow;
@property (nonatomic,strong) UIView *buttonsView, *backgroundView;
@property (nonatomic,strong) NSMutableArray *innerButtonsList;

@property (nonatomic) CGFloat topH, contentH, buttonsH;

@end

@implementation IGDisplayer

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initParams];
    }
    return self;
}

-(void)initParams{
    _displayerWidth = kScreenWidth - 2*30;
    _buttonHeight = 40;
    _buttonsInset = 0.5f;
    _customViewSize = CGSizeMake(245, 210);
    _titleEdgeInsets = UIEdgeInsetsMake(25,16,15,16);
    _contentEdgeInsets = UIEdgeInsetsMake(18,16,20,16);
    _isHiddenDisplayerWhenSelected = YES;
    _isHiddenDisplayerByTouch = NO;
    _isCustomWidthEqualToDisplayer = YES;

}

-(void)initSelfParams{
    _topH = 0;
    _contentH = 0;
    _buttonsH = 0;
    
    _innerButtonsList = nil;
    [self innerButtonsList];

    [self.overlayWindow addSubview:self];
    self.frame = self.overlayWindow.bounds;
    [self addSubview:self.backgroundView];
    [self addSubview:self.displayer];
    _displayer.transform = CGAffineTransformIdentity;
    _displayer.alpha = 1.0f;

    _displayer.layer.cornerRadius = 8.0f;

}

//类方法
+(void)showDisplayerWithTitleText:(NSString *)title contentText:(NSString *)content{

    IGDisplayer *displayer = [[IGDisplayer alloc] init];
    displayer.titleLabel.text = title;
    displayer.textLabel.text = content;
    [displayer displayerShow];
}

-(void)displayerShow{
    [self initSelfParams];
    
    [self computeTop];
    [self computeContent];
    [self showAnimation];
}

//计算头部标题控件
-(void)computeTop{
    if (_titleLabel && _titleLabel.text != nil && _titleLabel.text.length > 0) {
        CGFloat titleW = _displayerWidth - _titleEdgeInsets.left - _titleEdgeInsets.right;
//        CGFloat titleH = [_titleLabel sizeThatFits:CGSizeMake(titleW, MAXFLOAT)].height;
        _titleLabel.frame = CGRectMake(_titleEdgeInsets.left,
                                       _titleEdgeInsets.top,
                                       titleW,
                                       25);
        [_displayer addSubview:_titleLabel];

        CGFloat cancelW = _displayerWidth - 40 - _titleEdgeInsets.right-10;
        self.cancelButton.frame = CGRectMake(cancelW,
                                       _titleEdgeInsets.top-2,
                                       50,
                                       25);
        [_displayer addSubview:self.cancelButton];

        CGFloat lineTop = _titleEdgeInsets.top +_titleEdgeInsets.bottom +25;

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10,lineTop,_displayerWidth-20,1)];
        lineView.backgroundColor = RGB(175, 175, 175);
        [_displayer addSubview:lineView];
        _topH = 25 + _titleEdgeInsets.top + _titleEdgeInsets.bottom;
    }
}

//计算内容控件
-(void)computeContent{
    if (_textLabel && _textLabel.text != nil && _textLabel.text.length > 0) {
        CGFloat textW = _displayerWidth - _contentEdgeInsets.left - _contentEdgeInsets.right;
        CGFloat textH = [_textLabel sizeThatFits:CGSizeMake(textW, MAXFLOAT)].height;
        //设定一个内容控件最小高度
        textH = textH < 50 ? 50 : textH;
        _textLabel.frame = CGRectMake(_contentEdgeInsets.left,
                                      _contentEdgeInsets.top + _topH,
                                      textW,
                                      textH);
        [_displayer addSubview:_textLabel];
        _contentH = _contentEdgeInsets.top + textH + _contentEdgeInsets.bottom;
    }
}

-(void)displayerButtonAction:(UIButton *)sender{
    if (_isHiddenDisplayerWhenSelected) {
        [self displayerHidden];
    }
}

-(void)showAnimation{
    CGFloat totalH = _topH + _contentH + _buttonsH;

    NSLog(@"totalH = %f",totalH);
    if (totalH <400) {
        totalH = totalH +80;
    }

    self.displayer.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - _displayerWidth) / 2,
                                      ([UIScreen mainScreen].bounds.size.height - totalH) / 2,
                                      _displayerWidth,
                                      totalH);

    
    [self.overlayWindow makeKeyAndVisible];

    _displayer.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    _displayer.alpha = 0.0f;
    [UIView animateWithDuration:0.1f animations:^{
        _displayer.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        _displayer.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            _displayer.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f animations:^{
                _displayer.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:nil];
        }];
    }];
}

-(void)displayerHidden{
    [UIView animateWithDuration:0.15f
                     animations:^{

                         _displayer.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                         _displayer.alpha = 0.0f;
                         _backgroundView.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         _overlayWindow = nil;
                         [_displayer removeFromSuperview]; _displayer = nil;
                         [_backgroundView removeFromSuperview]; _backgroundView = nil;
                         
                         [[UIApplication sharedApplication].windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                             if ([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal && ![[window class] isEqual:[IGDisplayer class]]) {
                                 [window makeKeyWindow];
                                 *stop = YES;
                             }
                         }];
                     }];
}

-(void)singleTap{
    if (_isHiddenDisplayerByTouch) {
        [self displayerHidden];
    }else{
        [self displayerHidden];
    }
}

-(UIWindow *)overlayWindow{
    if (!_overlayWindow) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.windowLevel = UIWindowLevelAlert;
        _overlayWindow.userInteractionEnabled = YES;
    }
    return _overlayWindow;
}

-(UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        _backgroundView.userInteractionEnabled = YES;
        _backgroundView.alpha = 1.0f;
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        [_backgroundView addGestureRecognizer:singleTapGesture];
    }
    return _backgroundView;
}

-(UIView *)displayer{
    if (!_displayer) {
        _displayer = [[UIView alloc] init];
        _displayer.backgroundColor = [UIColor whiteColor];
        _displayer.clipsToBounds = YES;
    }
    return _displayer;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = MainTitleColor;
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:16];
        _textLabel.textColor = MainContentColor;
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _textLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _textLabel;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:NSLocalizedString(@"raiders_close",@"") forState:0];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:0];
        _cancelButton.layer.cornerRadius = 5;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.tag = 999;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"tui_button_p"] forState:UIControlStateNormal];
//        [_cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.95f alpha:1.0f]]forState:1<<0];
        [_cancelButton addTarget:self action:@selector(displayerButtonAction:) forControlEvents:1<<6];
    }
    return _cancelButton;
}


//
//-(UIButton *)customButton{
//    UIButton *button = [[UIButton alloc] init];
//    [button setTitleColor:_otherButtonTitleColor forState:0];
//    button.titleLabel.font = [UIFont systemFontOfSize:15];
//    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:0];
//    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.95f alpha:1.0f]]forState:1<<0];
//    return button;
//}



@end
