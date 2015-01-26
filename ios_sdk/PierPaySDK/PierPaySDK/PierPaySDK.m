//
//  PierPaySDK.m
//  PierPaySDK
//
//  Created by zyma on 12/3/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import "PierPaySDK.h"
#import "PIRHttpClient.h"
#import "PIRService.h"
#import "PIRPayModel.h"
#import "PIRConfig.h"

static NSString *__bundlePath;

/** Get iPhone Version */
double IPHONE_OS_MAIN_VERSION();
/** Get ImageName in Bundle */
NSString *getImagePath(NSString *imageName);
/** Model View Close Button */
void setCloseBarButtonWithTarget(id target, SEL selector);

@implementation PierPaySDK

+ (void)test:(NSString *)text{
    NSLog(@"%@",text);
    
}

@end

#pragma mark - -------------------- UI --------------------
#pragma mark - viewController

@interface PierUserInfuCheckViewController : UIViewController

@end

@implementation PierUserInfuCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)initView{
    [self setTitle:@"Pay By Pier"];
    setCloseBarButtonWithTarget(self, @selector(closeBarButtonClicked:));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeBarButtonClicked:(id)sender
{
    if ([self.navigationController.viewControllers count] == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)submitButtonAction:(id)sender{
//    [self testGet];
    [self testPost];
//    [self testPut];
//    [self uploadFile];
}

- (IBAction)cancelService:(id)sender{
    [[PIRHttpClient sharedInstanceWithClientType:ePIRHttpClientType_User] cancelAllRequests];
}

- (IBAction)addUser:(id)sender{
//    AddUserRequest *requestModel = [[AddUserRequest alloc] init];
//    requestModel.phone = @"13484573887";
//    requestModel.email = @"asfr2323gger@gmail.com";
//    requestModel.first_name = @"fra23sda";
//    requestModel.last_name = @"laksda23d";
//    requestModel.country_code = @"CN";
//    requestModel.merchant_id = @"MC0000000017";
//    [PIRService serverSend:ePIER_API_ADD_SUER resuest:requestModel successBlock:^(id responseModel) {
//        AddUserResponse *result = (AddUserResponse *)responseModel;
//        
//    } faliedBlock:^(NSError *error) {
//        
//    }];
}

- (void)testGet{
//    GetAgreementRequest *requestModel = [[GetAgreementRequest alloc] init];
//
//    [PIRService serverSend:ePIER_API_GET_AGREEMENT resuest:requestModel successBlock:^(id responseModel) {
//        GetAgreementResponse *result = (GetAgreementResponse *)responseModel;
//        DLog(@"url:%@",result.url);
//    } faliedBlock:^(NSError *error) {
//        
//    }];
}

- (void)testPut{
//    SaveDOBAndSSNRequest *requestModel = [[SaveDOBAndSSNRequest alloc] init];
//    requestModel.user_id = @"UR0000004525";
//    requestModel.session_token = @"0ba7c3ad-9bcb-11e4-aad2-0ea81fa3d43c";
//    requestModel.dob = @"1990-12-11";
//    requestModel.ssn = @"123456789";
//    [PIRService serverSend:ePIER_API_SAVE_DOB_SSN resuest:requestModel successBlock:^(id responseModel) {
//        
//    } faliedBlock:^(NSError *error) {
//        
//    }];
}

- (void)testPost{
    GetAuthTokenV2Request *requestModel = [[GetAuthTokenV2Request alloc] init];
    requestModel.phone = @"18638998588";
    requestModel.country_code = @"CN";
    requestModel.code = @"698366";
    requestModel.merchant_id = @"MC0000000017";
    requestModel.amount = @"199.00";
    requestModel.country_code = @"USD";
    [PIRService serverSend:ePIER_API_GET_AUTH_TOKEN_V2 resuest:requestModel successBlock:^(id responseModel) {
        
    } faliedBlock:^(NSError *error) {
        
    }];

//    TransactionSMSRequest *requestSMS = [[TransactionSMSRequest alloc] init];
//    requestSMS.phone = @"18638998588";
//    requestSMS.country_code = @"CN";
//    [PIRService serverSend:ePIER_API_TRANSACTION_SMS resuest:requestSMS successBlock:^(id responseModel) {
//        
//    } faliedBlock:^(NSError *error) {
//        
//    }];
}

- (void)uploadFile{
    PIRHttpClient *client = [PIRHttpClient sharedInstanceWithClientType:ePIRHttpClientType_User];
    /** post */
    UIImage *image = [UIImage imageWithContentsOfFile:getImagePath(@"btn_close")];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *testAddUserURL = @"/pier_api/v1/user/upload_file";//?content_type=image/jpeg
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"UR0000000001",@"user_id",
                           @"6fd20dd7-84f5-11e4-8328-32913f86e6ed",@"session_token",
                           @"8A412D29-F8E0-46D0-8BC6-3A6CCFD858B7",@"device_token",
                           @"image/jpeg",@"content_type",
                           @"UR0000000001_2014121615332sdsd81.jpg",@"file_name",
                           @"0",@"platform",
                           imageData,@"file",
                           nil];
    
    [client UploadImage:testAddUserURL parameters:param progress:^(float progress){
        NSLog(@"progress:%f",progress);
    } success:^(id response, NSHTTPURLResponse *urlResponse) {
        NSLog(@"%@response",response);
    } failed:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"%@urlResponse",urlResponse);
    }];
}
@end

#pragma mark - navigationController

@interface PierCredit ()
@end

@implementation PierCredit

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    NSArray *path1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//    NSString *documentPath = [path1 objectAtIndex:0];
//    NSLog(@"path=%@",documentPath);

    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"PierResource" withExtension:@"bundle"]];
    
    PierUserInfuCheckViewController *pierUserCheckVC = [[PierUserInfuCheckViewController alloc] initWithNibName:@"PierUserInfuCheckViewController" bundle:bundle];
    [self addChildViewController:pierUserCheckVC];
}


@end

#pragma mark - -------------------- Tools -------------------
#pragma mark - Get iPhone Version
double IPHONE_OS_MAIN_VERSION() {
    static double __iphone_os_main_version = 0.0;
    if(__iphone_os_main_version == 0.0) {
        NSString *sv = [[UIDevice currentDevice] systemVersion];
        NSScanner *sc = [[NSScanner alloc] initWithString:sv];
        if(![sc scanDouble:&__iphone_os_main_version])
            __iphone_os_main_version = -1.0;
    }
    return __iphone_os_main_version;
}

#pragma mark - Get ImageName in Bundle
NSString *getImagePath(NSString *imageName){
    NSString *path = @"";
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"PierResource" withExtension:@"bundle"]];
    
//    NSString *bindlePath = [[NSBundle mainBundle] pathForResource:@"PierResource" ofType:@"bundle"];
//    NSBundle *bundle = [NSBundle bundleWithPath:bindlePath];
    path = [bundle pathForResource:imageName ofType:@"png"];
    return path;
}

#pragma mark- Model View Close Button
void setCloseBarButtonWithTarget(id target, SEL selector)
{
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* image = [UIImage imageWithContentsOfFile:getImagePath(@"btn_close")];
    UIImage* pressedImage = [UIImage imageWithContentsOfFile:getImagePath(@"btn_close")];
    [customButton setImage:image forState:UIControlStateNormal];
    [customButton setImage:pressedImage forState:UIControlStateHighlighted];
    
    [customButton setFrame:CGRectMake(0, 0, 20, 20)];
    [customButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    
    UIViewController *vc = (UIViewController *)target;
    vc.navigationItem.rightBarButtonItem = item;
}