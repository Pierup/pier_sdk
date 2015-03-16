//
//  PierPaySDK.m
//  PierPaySDK
//
//  Created by zyma on 12/3/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import "PierPay.h"
#import "PIRHttpClient.h"
#import "PIRService.h"
#import "PIRPayModel.h"
#import "PIRConfig.h"
#import "PierLoginViewController.h"
#import "PierTools.h"
#import "PierSiginViewController.h"
#import "PIRDataSource.h"
#import "PierColor.h"
#import "PIRViewUtil.h"

/** Model View Close Button */
void setCloseBarButtonWithTarget(id target, SEL selector);

#pragma mark - -------------------- UI --------------------
#pragma mark - viewController

@interface PierPayRootViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UIButton *payButton;
@property (nonatomic, weak) IBOutlet UIButton *applyButton;

@property (nonatomic, weak) IBOutlet UIImageView *logoWhiteImageView;
@property (nonatomic, weak) IBOutlet UIImageView *whiteArrorImageView;
@property (nonatomic, weak) IBOutlet UIImageView *logoPurpleImageView;
@property (nonatomic, weak) IBOutlet UIImageView *purpleArrorImageView;

@end

@implementation PierPayRootViewController

#pragma makr ------------------ 初始化 ------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}


- (void)initView{
    [self setTitle:@"Pay By Pier"];
    [self.closeButton setBackgroundColor:[UIColor clearColor]];
    [self.closeButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"btn_close")] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    setCloseBarButtonWithTarget(self, @selector(closeBarButtonClicked:));
    
    [self.logoWhiteImageView setImage:[UIImage imageWithContentsOfFile:getImagePath(@"icon_logowhite")]];
    [self.whiteArrorImageView setImage:[UIImage imageWithContentsOfFile:getImagePath(@"btn_next")]];
   
    [self.logoPurpleImageView setImage:[UIImage imageWithContentsOfFile:getImagePath(@"icon_logopurple")]];
    [self.purpleArrorImageView setImage:[UIImage imageWithContentsOfFile:getImagePath(@"btn_nextpurple")]];
    
    [self.payButton setBackgroundColor:[PierColor darkPurpleColor]];
    [self.payButton setBackgroundImage:[PIRViewUtil getDarkPurpleColorImage:self.payButton.frame] forState:UIControlStateNormal];
    [self.payButton setBackgroundImage:[PIRViewUtil getLightPurpleColorImage:self.payButton.frame] forState:UIControlStateHighlighted];
    [self.payButton.layer setMasksToBounds:YES];
    [self.payButton.layer setCornerRadius:5];
    
    [self.applyButton setBackgroundImage:[PIRViewUtil getImageByView:self.applyButton] forState:UIControlStateNormal];
    [self.applyButton.layer setBorderWidth:1.0];
    [self.applyButton.layer setBorderColor:[[PierColor darkPurpleColor] CGColor]];
    [self.applyButton.layer setMasksToBounds:YES];
    [self.applyButton.layer setCornerRadius:5];
    
}

#pragma mark --------------- button Action ------------------------

- (void)closeBarButtonClicked:(id)sender
{
    if ([self.navigationController.viewControllers count] == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)termsAndPolicyButtonAction:(UIButton *)sender
{
    
}

- (IBAction)loginAction:(id)sender
{
    PierLoginViewController *loginPage = [[PierLoginViewController alloc] initWithNibName:@"PierLoginViewController" bundle:pierBoundle()];
    [self.navigationController pushViewController:loginPage animated:YES];
}

- (IBAction)creditApplay:(id)sender
{
    PierSiginViewController *creditApplay = [[PierSiginViewController alloc] initWithNibName:@"PierSiginViewController" bundle:pierBoundle()];
    [self.navigationController pushViewController:creditApplay animated:YES];
}

#pragma mark --------------------- Service ---------------------------

- (void)uploadFile
{
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

#pragma mark ----------------------退出清空 ------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

#pragma mark - navigationController

@interface PierPay ()

@property (nonatomic, assign) BOOL merchantAppHasBar;

@end

@implementation PierPay

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWith:(NSDictionary *)userAttributes delegate:(id)delegate
{
    initDataSource();
    __dataSource.merchantParam = userAttributes;
    __dataSource.pierDelegate = delegate;
    self = [super init];
    if (self) {
        _merchantAppHasBar = NO;
        PierPayRootViewController *pierUserCheckVC = [[PierPayRootViewController alloc] initWithNibName:@"PierPayRootViewController" bundle:pierBoundle()];
        [self addChildViewController:pierUserCheckVC];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (self.navigationBar.hidden == NO) {
        _merchantAppHasBar = NO;
        [self setNavigationBarHidden:YES animated:YES];
    }else{
        _merchantAppHasBar = YES;
    }
//    NSArray *path1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//    NSString *documentPath = [path1 objectAtIndex:0];
//    NSLog(@"path=%@",documentPath);
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (!_merchantAppHasBar) {
        [self setNavigationBarHidden:NO animated:YES];
    }
}

@end

#pragma mark - -------------------- Tools -------------------

#pragma mark- Model View Close Button
void setCloseBarButtonWithTarget(id target, SEL selector)
{
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* image = [UIImage imageWithContentsOfFile:getImagePath(@"btn_close")];
    UIImage* pressedImage = [UIImage imageWithContentsOfFile:getImagePath(@"btn_close")];
    [customButton setImage:image forState:UIControlStateNormal];
    [customButton setImage:pressedImage forState:UIControlStateHighlighted];
    
    [customButton setFrame:CGRectMake(0, 0, 44, 44)];
    [customButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    
    UIViewController *vc = (UIViewController *)target;
    vc.navigationItem.rightBarButtonItem = item;
}

