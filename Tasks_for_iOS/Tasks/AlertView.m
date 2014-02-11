//
//  AlertView.m
//  Tasks
//
//  Created by Javier Fuchs on 5/19/13.
//  Copyright (c) 2013 Hungry And Foolish. All rights reserved.
//

#import "AlertView.h"

typedef NS_OPTIONS(NSUInteger, AlertViewOption) {
    AlertViewOptionLeft        = 1 << 0,
    AlertViewOptionRight       = 1 << 1,
    AlertViewOptionTextField   = 1 << 2,
};


@interface AlertView()
@property (nonatomic,copy) void (^leftBlock)();
@property (nonatomic,copy) void (^rightBlock)();
@property (nonatomic,copy) void (^textBlock)(NSString* text);
@property (nonatomic, retain) UITextField* textField;
@end

@implementation AlertView
{
    unsigned char options;
}

- (void)dealloc {

    [_leftBlock release]; _leftBlock = nil;
    [_rightBlock release]; _rightBlock = nil;
    _textField.delegate = nil;
    [_textField release]; _textField = nil;

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame textBlock:(void (^)(NSString* text))textBlock leftTitle:(NSString*)leftTitle leftBlock:(void (^)())leftBlock rightTitle:(NSString*)rightTitle rightBlock:(void (^)())rightBlock
{
    if ((self = [super initWithFrame:frame])) {

        if (textBlock)
        {
            _textBlock = [textBlock copy];
            options |= AlertViewOptionTextField;
            
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
            _textField.delegate = self;
        }
        
        if (leftBlock)
        {
            [self addButtonWithTitle:leftTitle];
            _leftBlock = [leftBlock copy];
            options |= AlertViewOptionLeft;
        }
        
        if (rightBlock)
        {
            [self addButtonWithTitle:rightTitle];
            _rightBlock = [rightBlock copy];
            options |= AlertViewOptionRight;
        }

    }
    assert(self);
    return self;
}




- (void)showWithMessage:(NSString *)message title:(NSString *)title {
    [self setMessage:message];
    [self setTitle:title];
    if (options & AlertViewOptionTextField)
    {
        [self.textField setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.textField];
    }
    [self setDelegate:self];
    [super show];
}



+ (void)alertWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message leftTitle:(NSString*)leftTitle leftBlock:(void (^)())leftBlock rightTitle:(NSString*)rightTitle rightBlock:(void (^)())rightBlock
{
    AlertView* alert = [[AlertView alloc] initWithFrame:frame textBlock:nil leftTitle:leftTitle leftBlock:leftBlock rightTitle:rightTitle rightBlock:rightBlock];
    [alert showWithMessage:message title:title];
    [alert release];
}


+ (void)alertWithFrame:(CGRect)frame prompt:(NSString *)prompt placeholder:(NSString *)placeholder textBlock:(void (^)(NSString* text))textBlock leftTitle:(NSString*)leftTitle leftBlock:(void (^)())leftBlock rightTitle:(NSString*)rightTitle rightBlock:(void (^)())rightBlock
{
    AlertView* alert = [[AlertView alloc] initWithFrame:frame textBlock:textBlock leftTitle:leftTitle leftBlock:leftBlock rightTitle:rightTitle rightBlock:rightBlock];
    alert.textField.placeholder = placeholder;
    [alert.textField becomeFirstResponder];
    [alert showWithMessage:@" " title:prompt];
    [alert release];
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (options & AlertViewOptionTextField)
    {
        [self.textField endEditing:YES];
    }
    if ((options & AlertViewOptionLeft) && (buttonIndex == 0)) {
        assert(self.leftBlock);
        self.leftBlock();
    } else if ((options & AlertViewOptionRight) && (buttonIndex == 0 || buttonIndex == 1)) {

        if (options & AlertViewOptionTextField)
        {
            self.textBlock(self.textField.text);
        } else {
            assert(self.rightBlock);
            self.rightBlock();
        }
    } else {
        assert(0);
    }

}

static inline BOOL IsEmpty(id object)
{
    if (object == nil) {
        return YES;
    }
    if ([object isKindOfClass:[NSString class]] && [object respondsToSelector:@selector(length)] && [(NSString *)object length] == 0) {
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (IsEmpty(textField.text)) {
        return NO;
    }
    self.textBlock(self.textField.text);
    
    [self dismissWithClickedButtonIndex:1 animated:YES];
    
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (IsEmpty(textField.text)) {
        return;
    }
}



@end
