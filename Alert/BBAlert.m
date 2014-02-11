//
//  BBAlert.m
//  
//
//  Created by Javier Fuchs on 2/4/14.
//  Copyright (c) 2014 [your company here]. All rights reserved.
//

#import "BBAlert.h"

typedef NS_OPTIONS(NSUInteger, AlertViewOption) {
    AlertViewOptionLeft        = 1 << 0,
    AlertViewOptionRight       = 1 << 1,
    AlertViewOptionTextField   = 1 << 2,
};


@interface BBAlert()
@property (nonatomic,copy) void (^leftBlock)();
@property (nonatomic,copy) void (^rightBlock)();
@property (nonatomic,copy) void (^textBlock)(NSString* text);
@end

@implementation BBAlert
{
    unsigned char options;
}


- (id)initWithFrame:(CGRect)frame textBlock:(void (^)(NSString* text))textBlock leftTitle:(NSString*)leftTitle leftBlock:(void (^)())leftBlock rightTitle:(NSString*)rightTitle rightBlock:(void (^)())rightBlock
{
    if ((self = [super initWithFrame:frame])) {
        
        if (textBlock)
        {
            _textBlock = [textBlock copy];
            options |= AlertViewOptionTextField;
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
    self.delegate = self;

    [self setMessage:message];
    [self setTitle:title];
    [super show];
}



+ (void)alertWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message leftTitle:(NSString*)leftTitle leftBlock:(void (^)())leftBlock rightTitle:(NSString*)rightTitle rightBlock:(void (^)())rightBlock
{
    BBAlert* alert = [[BBAlert alloc] initWithFrame:frame textBlock:nil leftTitle:leftTitle leftBlock:leftBlock rightTitle:rightTitle rightBlock:rightBlock];
    alert.delegate = alert;
    [alert showWithMessage:message title:title];
}


+ (void)alertWithFrame:(CGRect)frame prompt:(NSString *)prompt placeholder:(NSString *)placeholder textBlock:(void (^)(NSString* text))textBlock leftTitle:(NSString*)leftTitle leftBlock:(void (^)())leftBlock rightTitle:(NSString*)rightTitle rightBlock:(void (^)())rightBlock
{
    BBAlert* alert = [[BBAlert alloc] initWithFrame:frame textBlock:textBlock leftTitle:leftTitle leftBlock:leftBlock rightTitle:rightTitle rightBlock:rightBlock];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.delegate = alert;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.delegate = alert;
    textField.placeholder = placeholder;
    [textField becomeFirstResponder];
    [alert showWithMessage:@" " title:prompt];
}

+ (void)alertWithFrame:(CGRect)frame prompt:(NSString *)prompt placeholder:(NSString *)placeholder value:(NSString *)value textBlock:(void (^)(NSString* text))textBlock leftTitle:(NSString*)leftTitle leftBlock:(void (^)())leftBlock rightTitle:(NSString*)rightTitle rightBlock:(void (^)())rightBlock
{
    BBAlert* alert = [[BBAlert alloc] initWithFrame:frame textBlock:textBlock leftTitle:leftTitle leftBlock:leftBlock rightTitle:rightTitle rightBlock:rightBlock];
    alert.delegate = alert;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.delegate = alert;
    textField.placeholder = placeholder;
    textField.text = value;
    [textField becomeFirstResponder];
    [alert showWithMessage:@" " title:prompt];
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (options & AlertViewOptionTextField)
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        [textField endEditing:YES];
    }
    if ((options & AlertViewOptionLeft) && (buttonIndex == 0))
    {
        assert(self.leftBlock);
        self.leftBlock();
    } else if ((options & AlertViewOptionRight) && (buttonIndex == 0 || buttonIndex == 1))
    {
        
        if (options & AlertViewOptionTextField)
        {
            UITextField *textField = [alertView textFieldAtIndex:0];
            self.textBlock(textField.text);
        } else {
            assert(self.rightBlock);
            self.rightBlock();
        }
    } else {
        assert(0);
    }
    
}


#pragma mark -
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (![textField.text length]) {
        return NO;
    }
    self.textBlock(textField.text);
    
    [self dismissWithClickedButtonIndex:1 animated:YES];
    
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (![textField.text length]) {
        return;
    }
}


@end

