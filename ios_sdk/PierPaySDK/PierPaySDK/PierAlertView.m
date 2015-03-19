//
//  PierAlertView.m
//  PierPaySDK
//
//  Created by zyma on 1/27/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierAlertView.h"
#import "PierColor.h"
#import "PierTools.h"
#import "PierKeyboard.h"
#import "PierPayModel.h"
#import "PierService.h"
#import "NSString+PierCheck.h"
#import "PierViewUtil.h"

@interface PierAlertView ()

@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *alertLabel;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSDictionary *paramDic;
@property (nonatomic, copy) approveBlock    approveBc;

@property (nonatomic, assign) ePierAlertViewType alertType;

@end

@implementation PierAlertView


+ (void)showPierAlertView:(id)delegate
                    param:(id)param
                     type:(ePierAlertViewType)type
                  approve:(approveBlock)approve{
    PierAlertView *confirmView = (PierAlertView *)[[pierBoundle() loadNibNamed:@"PierAlertView" owner:delegate options:nil] objectAtIndex:0];
    confirmView.paramDic    = param;
    confirmView.approveBc   = approve;
    confirmView.alertType   = type;
    [confirmView initData];
    [confirmView initView];
}

- (void)initData{
    if (self.paramDic) {
        [self.titleLabel setText:[self.paramDic objectForKey:@"title"]];
        [self.doneButton setTitle:@"OK" forState:UIControlStateNormal];
        [self.alertLabel setText:[self.paramDic objectForKey:@"message"]];
    }
}

- (void)initView{
    UIWindow *currentWindow = [[UIApplication sharedApplication].delegate window];
    
    [self.doneButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.doneButton.layer setBorderWidth:0.5];
    [self.doneButton.layer setCornerRadius:5];
    [self.doneButton.layer setMasksToBounds:YES];
    
    [self setCenter:CGPointMake(DEVICE_WIDTH/2, DEVICE_HEIGHT/2-100)];
    
    [self.layer setCornerRadius:5];
    [self.layer setMasksToBounds:YES];
    
    self.bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.bgView setBackgroundColor:[UIColor blackColor]];
    [self.bgView setAlpha:0.1];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.bgView setAlpha:0.6];
    }];
    
    _titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    [_titleImage setCenter:CGPointMake(self.center.x, self.center.y-self.bounds.size.height/2-6)];
    [_titleImage setImage:[UIImage imageWithContentsOfFile:getImagePath([self.paramDic objectForKey:@"title_image_name"])]];
    
    [currentWindow addSubview:self.bgView];
    [currentWindow addSubview:self];
    [currentWindow addSubview:_titleImage];
    
    switch (self.alertType) {
        case ePierAlertViewType_userInput:
        {
            break;
        }
        default:
            break;
    }
    
    [self.doneButton setBackgroundColor:[PierColor lightPurpleColor]];
    UIImage *btnImg = [PierViewUtil getImageByView:self.doneButton];
    [self.doneButton setBackgroundImage:btnImg forState:UIControlStateNormal];
}

- (IBAction)doneButton:(id)sender{
    if (self.approveBc) {
        [self viewRemoveFromSuperView];
    }
}

- (void)handleBgTapGesture{
    [self viewRemoveFromSuperView];
}

- (void)viewRemoveFromSuperView{
    [self.bgView        removeFromSuperview];
    [self.titleImage removeFromSuperview];
    [self removeFromSuperview];
}

@end

@interface PierUserInputAlertView ()

//@property (nonatomic, strong) UIImageView *titleImage;
//@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *approveButton;
@property (nonatomic, weak) IBOutlet UIButton *cancleButton;

@property (nonatomic, strong) UIView *bgView;
//@property (nonatomic, strong) NSDictionary *paramDic;
@property (nonatomic, copy) approveBlock    approveBc;
@property (nonatomic, copy) cancelBlock     cancelBc;

@property (nonatomic, assign) ePierAlertViewType alertType;

@end

@implementation PierUserInputAlertView

+ (void)showPierUserInputAlertView:(id)delegate
                             param:(id)param
                              type:(ePierAlertViewType)type
                           approve:(approveBlock)approve
                            cancel:(cancelBlock)cancel{
    PierUserInputAlertView *confirmView = (PierUserInputAlertView *)[[pierBoundle() loadNibNamed:@"PierAlertView" owner:delegate options:nil] objectAtIndex:1];
    confirmView.paramDic    = param;
    confirmView.approveBc   = approve;
    confirmView.cancelBc    = cancel;
    confirmView.alertType   = type;
    [confirmView.textField becomeFirstResponder];
    [confirmView initData];
    [confirmView initView];
}

- (void)initData{
    if (self.paramDic) {
        self.titleLabel = [self.paramDic objectForKey:@"title"];
        [self.approveButton setTitle:[self.paramDic objectForKey:@"approve_text"] forState:UIControlStateNormal];
        [self.cancleButton setTitle:[self.paramDic objectForKey:@"cancle_text"] forState:UIControlStateNormal];
    }
}

- (void)initView{
    UIWindow *currentWindow = [[UIApplication sharedApplication].delegate window];
    
    [self.approveButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.approveButton.layer setBorderWidth:0.5];
    [self.approveButton.layer setCornerRadius:5];
    [self.approveButton.layer setMasksToBounds:YES];
    
    [self.cancleButton.layer setBorderColor:[self.cancleButton.titleLabel.textColor CGColor]];
    [self.cancleButton.layer setBorderWidth:0.5];
    [self.cancleButton.layer setCornerRadius:5];
    [self.cancleButton.layer setMasksToBounds:YES];
    
    [self.textField.layer setBorderColor:[[PierColor darkPurpleColor] CGColor]];
//    [self.textField.layer setBorderWidth:0.5];
    [self.textField.layer setCornerRadius:5];
    [self.textField.layer setMasksToBounds:YES];
    
    [self setCenter:CGPointMake(DEVICE_WIDTH/2, DEVICE_HEIGHT/2-100)];
    
    [self.layer setCornerRadius:5];
    [self.layer setMasksToBounds:YES];
    
    self.bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.bgView setBackgroundColor:[UIColor blackColor]];
    [self.bgView setAlpha:0.1];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.bgView setAlpha:0.6];
    }];
    
    self.titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    [self.titleImage setCenter:CGPointMake(self.center.x, self.center.y-self.bounds.size.height/2-6)];
    [self.titleImage setImage:[UIImage imageWithContentsOfFile:getImagePath(@"icon_smscode")]];
    
    [currentWindow addSubview:self.bgView];
    [currentWindow addSubview:self];
    [currentWindow addSubview:self.titleImage];
    
    switch (self.alertType) {
        case ePierAlertViewType_userInput:
        {
            break;
        }
        default:
            break;
    }
    
    [self.approveButton setBackgroundColor:[PierColor lightPurpleColor]];
    UIImage *appbtnImg = [PierViewUtil getImageByView:self.approveButton];
    [self.approveButton setBackgroundImage:appbtnImg forState:UIControlStateNormal];
    
    [self.cancleButton setBackgroundColor:[PierColor lightPurpleColor]];
    UIImage *canclebtnImg = [PierViewUtil getImageByView:self.approveButton];
    [self.cancleButton setBackgroundImage:canclebtnImg forState:UIControlStateNormal];
}

- (IBAction)approve:(id)sender{
    if (self.approveBc([self.textField text])) {
        [self viewRemoveFromSuperView];
    }
}

- (IBAction)cancleAction:(id)sender{
    [UIView animateWithDuration:0.1 animations:^{
        [self.bgView setAlpha:0.1];
    } completion:^(BOOL finished) {
        [self viewRemoveFromSuperView];
        self.cancelBc();
    }];
}

- (void)handleBgTapGesture{
    [self viewRemoveFromSuperView];
}

- (void)viewRemoveFromSuperView{
    [self.textField resignFirstResponder];
    [self.bgView        removeFromSuperview];
    [self.titleImage removeFromSuperview];
    [self removeFromSuperview];
}

@end

@interface PierSMSAlertView ()<PierStopWatchViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *smsTitleLabel;

@property (nonatomic, strong) IBOutlet PierStopWatchView *stopWatch;
@property (nonatomic, strong) IBOutlet UIButton *refreshButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) IBOutlet UITextField *smsInputTextField;
@property (nonatomic, strong) IBOutlet UIView *smsInputBgView;

@property (nonatomic, strong) IBOutlet UILabel *errorMessageLabel;

@end

@implementation PierSMSAlertView

- (id)initWith:(id)delegate param:(id)param type:(ePierAlertViewType)type{
    self = (PierSMSAlertView *)[[pierBoundle() loadNibNamed:@"PierAlertView" owner:delegate options:nil] objectAtIndex:2];
    if (self) {
        self.paramDic    = param;
        self.alertType   = type;
        [self.textField becomeFirstResponder];
        self.smsInputTextField.delegate = self;
        [self initData];
    }
    return self;
}

- (void)show{
    [self initView];
}

- (void)dismiss{
    [self viewRemoveFromSuperView];
}

- (void)showErrorMessage:(NSString *)message{
    [self.errorMessageLabel setHidden:NO];
    [self.errorMessageLabel setText:message];
}

- (void)dismissErorMessage{
    [self.errorMessageLabel setHidden:YES];
}

+ (void)showPierUserInputAlertView:(id)delegate
                             param:(id)param
                              type:(ePierAlertViewType)type
                           approve:(approveBlock)approve
                            cancel:(cancelBlock)cancel{
    PierSMSAlertView *confirmView = (PierSMSAlertView *)[[pierBoundle() loadNibNamed:@"PierAlertView" owner:delegate options:nil] objectAtIndex:2];
    confirmView.paramDic    = param;
    confirmView.approveBc   = approve;
    confirmView.cancelBc    = cancel;
    confirmView.alertType   = type;
    [confirmView.textField becomeFirstResponder];
    confirmView.smsInputTextField.delegate = confirmView;
    [confirmView initData];
    [confirmView initView];
}

- (void)initData{
    [super initData];
    if (self.paramDic) {
        self.stopWatch.expirTime = [[self.paramDic objectForKey:@"expiration_time"] integerValue];
        NSString *title = [self.paramDic objectForKey:@"title"];
        [self.smsTitleLabel setText:title];
    }
    [self.stopWatch startTimer];
    self.stopWatch.delegate = self;
}

- (void)initView{
    [super initView];
    [self.refreshButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"btn_resend")] forState:UIControlStateNormal];
    
    [self.stopWatch setHidden:NO];
    [self.refreshButton setHidden:YES];
    [self.loadingView setHidesWhenStopped:YES];
    [self.loadingView stopAnimating];
    [self dismissErorMessage];
    
    [self.approveButton setBackgroundColor:[PierColor lightPurpleColor]];
    UIImage *appbtnImg = [PierViewUtil getImageByView:self.approveButton];
    [self.approveButton setBackgroundImage:appbtnImg forState:UIControlStateNormal];
    
    [self.cancleButton setBackgroundColor:[UIColor whiteColor]];
    UIImage *canclebtnImg = [PierViewUtil getImageByView:self.cancleButton];
    [self.cancleButton setBackgroundImage:canclebtnImg forState:UIControlStateNormal];
    
    [self.smsInputBgView.layer setBorderColor:[[PierColor darkPurpleColor] CGColor]];
    [self.textField.layer setBorderWidth:0.5];
    [self.smsInputBgView.layer setCornerRadius:5];
    [self.smsInputBgView.layer setMasksToBounds:YES];
}

- (void)viewRemoveFromSuperView{
    [super viewRemoveFromSuperView];
    [self.stopWatch stopTimer];
}

- (void)timerStop{
    [self.stopWatch setHidden:YES];
    [self.refreshButton setHidden:NO];
}

- (IBAction)resend:(id)sender{
    [self.stopWatch stopTimer];
    [self.stopWatch setHidden:NO];
    [self.loadingView startAnimating];
    [self.refreshButton setHidden:YES];
    [self serviceGetReigistSMS];
}

- (IBAction)approve:(id)sender{
    if (self.alertType == ePierAlertViewType_instance) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(userApprove:)]) {
            [self.delegate userApprove:self.textField.text];
        }
    }else{
        if (self.approveBc([self.textField text])) {
            [self viewRemoveFromSuperView];
        }
    }
}

- (IBAction)cancleAction:(id)sender{
    if (self.alertType == ePierAlertViewType_instance) {
        [UIView animateWithDuration:0.1 animations:^{
            [self.bgView setAlpha:0.1];
        } completion:^(BOOL finished) {
            [self viewRemoveFromSuperView];
        }];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            [self.bgView setAlpha:0.1];
        } completion:^(BOOL finished) {
            [self viewRemoveFromSuperView];
            self.cancelBc();
        }];
    }
}


- (void)serviceGetReigistSMS{
    GetRegisterCodeRequest *requestModel = [[GetRegisterCodeRequest alloc] init];
    requestModel.phone = [self.paramDic objectForKey:@"phone"] ;
    requestModel.country_code = @"CN";
    
    [PierService serverSend:ePIER_API_GET_ACTIVITY_CODE resuest:requestModel successBlock:^(id responseModel) {
        GetRegisterCodeResponse *response = (GetRegisterCodeResponse *)responseModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.stopWatch.expirTime = [response.expiration integerValue];
            [self.stopWatch startTimer];
            [self.loadingView stopAnimating];
        });
    } faliedBlock:^(NSError *error) {
        [self.loadingView stopAnimating];
    } attribute:nil];
}

#pragma mark - -------------------UITextFieldDelegate----------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string) {
        if (![string isNumString]  && ![NSString emptyOrNull:string]) {
            return NO;
        }
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length > [[self.paramDic objectForKey:@"code_length"] integerValue]) {
        return NO;
    }
    return YES;
}

@end

//@interface PierCustomKeyboardAlertView ()<PierKeyboardDelegate>
//
//@property (nonatomic, strong) UIView *bgView;
//@property (nonatomic, strong) NSDictionary *paramDic;
//@property (nonatomic, weak) IBOutlet UIButton *approveButton;
//@property (nonatomic, weak) IBOutlet UIButton *cancleButton;
//
//@property (nonatomic, copy) approveBlock    approveBc;
//@property (nonatomic, copy) cancelBlock     cancelBc;
//
//@property (nonatomic, assign) ePierAlertViewType alertType;
//
///** keyboard */
//@property (nonatomic, strong) PierKeyboard *pirKeyBoard;
//@property (nonatomic, weak) IBOutlet UILabel *userInputLabel;
//
//@end
//
//@implementation PierCustomKeyboardAlertView
//
//+ (void)showPierAlertView:(id)delegate param:(id)param type:(ePierAlertViewType)type approve:(approveBlock)approve cancel:(cancelBlock)cancel{
//    PierCustomKeyboardAlertView *confirmView = (PierCustomKeyboardAlertView *)[[pierBoundle() loadNibNamed:@"PierAlertView" owner:delegate options:nil] objectAtIndex:1];
//    confirmView.paramDic    = param;
//    confirmView.approveBc   = approve;
//    confirmView.cancelBc    = cancel;
//    confirmView.alertType   = type;
//    [confirmView initData];
//    [confirmView initView];
//}
//
//- (void)initData{
//    
//}
//
//- (void)initView{
//    UIWindow *currentWindow = [[UIApplication sharedApplication].delegate window];
//    CGRect currentBound = [[UIScreen mainScreen] bounds];
//    //    NSInteger titleViewWidth = 55;
//    
//    [self.approveButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//    [self.approveButton.layer setBorderWidth:1];
//    [self.approveButton.layer setCornerRadius:5];
//    [self.approveButton.layer setMasksToBounds:YES];
//    
//    [self.cancleButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//    [self.cancleButton.layer setBorderWidth:1];
//    [self.cancleButton.layer setCornerRadius:5];
//    [self.cancleButton.layer setMasksToBounds:YES];
//    
//    [self setCenter:CGPointMake(currentBound.size.width/2, currentBound.size.height/2)];
//    
//    [self.layer setCornerRadius:5];
//    [self.layer setMasksToBounds:YES];
//    
//    self.bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [self.bgView setBackgroundColor:[UIColor blackColor]];
//    [self.bgView setAlpha:0.1];
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        [self.bgView setAlpha:0.4];
//    }];
//    
//    
//    [currentWindow addSubview:self.bgView];
//    [currentWindow addSubview:self];
//    
//    switch (self.alertType) {
//        case ePierAlertViewType_userInput:
//        {
//            self.pirKeyBoard = [PierKeyboard getKeyboardWithType:keyboardTypeNormal alpha:1 delegate:self];
//            [self setCenter:CGPointMake(currentBound.size.width/2, currentBound.size.height/2 - 100)];
//            [currentWindow addSubview:self.pirKeyBoard];
//            [self.pirKeyBoard setFrame:CGRectMake(0, DEVICE_HEIGHT-self.pirKeyBoard.frame.size.height, self.pirKeyBoard.frame.size.width, self.pirKeyBoard.frame.size.height)];
//            break;
//        }
//        default:
//            break;
//    }
//}
//
//- (IBAction)approve:(id)sender{
//    [self viewRemoveFromSuperView];
//    self.approveBc([self.userInputLabel text]);
//}
//
//- (IBAction)cancelAction:(id)sender{
//    [UIView animateWithDuration:0.1 animations:^{
//        [self.bgView setAlpha:0.1];
//    } completion:^(BOOL finished) {
//        [self viewRemoveFromSuperView];
//        self.cancelBc();
//    }];
//}
//
//- (void)handleBgTapGesture{
//    [self viewRemoveFromSuperView];
//}
//
//- (void)viewRemoveFromSuperView{
//    [self.bgView        removeFromSuperview];
//    [self.pirKeyBoard   removeFromSuperview];
//    [self removeFromSuperview];
//}
//
//#pragma mark - -----------------PierKeyboardDelegate---------------
//
//- (void)numberKeyboardInput:(NSString *)number{
//    
//}
//
//- (void)numberKeyboardAllInput:(NSString *)number{
//    [self.userInputLabel setText:number];
//}
//
//- (void)numberKeyboardBackspace:(NSString *)number{
//    [self.userInputLabel setText:number];
//}
//
//@end