//
//  AlertView.h
//  Tasks
//
//  Created by Javier Fuchs on 5/19/13.
//  Copyright (c) 2013 Hungry And Foolish. All rights reserved.
//

@interface AlertView : UIAlertView <UIAlertViewDelegate, UITextFieldDelegate>

+ (void)alertWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message leftTitle:(NSString*)leftTitle leftBlock:(void (^)())leftBlock rightTitle:(NSString*)rightTitle rightBlock:(void (^)())rightBlock;


+ (void)alertWithFrame:(CGRect)frame prompt:(NSString *)prompt placeholder:(NSString *)placeholder textBlock:(void (^)(NSString* text))textBlock leftTitle:(NSString*)leftTitle leftBlock:(void (^)())leftBlock rightTitle:(NSString*)rightTitle rightBlock:(void (^)())rightBlock;

@end
