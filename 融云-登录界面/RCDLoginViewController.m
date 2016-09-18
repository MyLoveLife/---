//
//  LoginViewController.m
//  RongCloud
//
//  Created by Liv on 14/11/5.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//
//#import <RongIMKit/RongIMKit.h>
#import "RCDLoginViewController.h"
//#import "AFHttpTool.h"
//#import "RCDLoginInfo.h"
//#import "RCDTextFieldValidate.h"
//#import "MBProgressHUD.h"
//#import "RCDRCIMDataSource.h"
#import "RCAnimatedImagesView.h"
#import "RCUnderlineTextField.h"
//#import "RCDCommonDefine.h"
//#import "RCDRegisterViewController.h"
//#import "UITextFiled+Shake.h"
//#import "RCDFindPswViewController.h"
//#import "RCDHttpTool.h"
//#import "AppkeyModel.h"
//#import "SelectAppKeyViewController.h"
//#import "RCDataBaseManager.h"

@interface RCDLoginViewController ()<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet RCAnimatedImagesView* animatedImagesView;

@property (weak, nonatomic) IBOutlet UITextField* emailTextField;

@property (weak, nonatomic) IBOutlet UITextField* pwdTextField;

@property (nonatomic, strong) UIView* headBackground;
@property (nonatomic, strong) UIImageView* rongLogo;
@property (nonatomic, strong) UIView* inputBackground;
@property (nonatomic, strong) UIView* statusBarView;
@property (nonatomic, strong) UILabel* errorMsgLb;
@property (nonatomic, strong) UITextField *passwordTextField;

//@property (nonatomic, strong) AppkeyModel *currentModel;

@property (nonatomic, strong) UILabel *appKeyLabel;
@property (nonatomic, strong) UIButton *changeKeyButton;
@property (nonatomic) int loginFailureTimes;
@property (nonatomic)BOOL rcDebug;
@end


@implementation RCDLoginViewController
#define UserTextFieldTag 1000
#define PassWordFieldTag 1001
@synthesize animatedImagesView = _animatedImagesView;
@synthesize inputBackground = _inputBackground;
//MBProgressHUD* hud ;

- (void)onChangeKey:(id)sender
{
//    if (sender == self.changeKeyButton) {
//        SelectAppKeyViewController *selectAppkeyVC = [[SelectAppKeyViewController alloc] init];
//        selectAppkeyVC.result = ^(AppkeyModel *selectedModel) {
//            if (selectedModel) {
//                self.currentModel = selectedModel;
//                self.appKeyLabel.text = selectedModel.appKey;
//            }
//        };
//        
//        [self.navigationController pushViewController:selectAppkeyVC animated:YES];
//    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rcDebug = [[NSUserDefaults standardUserDefaults] boolForKey:@"rongcloud appkey debug"];
    if (self.rcDebug) {//测试切换appkey使用
        NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:@[@"z3v5yqkbv8v30", @"lmxuhwagxrxmd", @"e0x9wycfx7flq"], @"keys", @[@1, @2, @0], @"envs", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    //添加动态图
    self.animatedImagesView = [[RCAnimatedImagesView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:self.animatedImagesView];
    self.animatedImagesView.delegate = self;

    //添加头部内容
    _headBackground = [[UIView alloc] initWithFrame:CGRectMake(0, -100, self.view.bounds.size.width, 50)];
    _headBackground.userInteractionEnabled = YES;
    _headBackground.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.2];
    [self.view addSubview:_headBackground];

    if (self.rcDebug) {
        self.appKeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 150, 40)];
        self.appKeyLabel.text = @"请选择AppKey";
        
        self.changeKeyButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 20, 120, 40)];
        [self.changeKeyButton setTitle:@"选择" forState:UIControlStateNormal];
        [self.changeKeyButton  addTarget:self action:@selector(onChangeKey:) forControlEvents:UIControlEventTouchUpInside];
        [self.changeKeyButton setBackgroundColor:[UIColor redColor]];
        self.changeKeyButton .imageView.contentMode = UIViewContentModeCenter;
        
        [self.view addSubview:self.appKeyLabel];
        [self.view addSubview:self.changeKeyButton];
    }
    
    UIButton* registerHeadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [registerHeadButton setTitle:@"找回密码" forState:UIControlStateNormal];
    [registerHeadButton setTitleColor:[[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5] forState:UIControlStateNormal];
    registerHeadButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [registerHeadButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    [registerHeadButton addTarget:self action:@selector(forgetPswEvent) forControlEvents:UIControlEventTouchUpInside];

    [_headBackground addSubview:registerHeadButton];
    
    //添加图标
    UIImage* rongLogoSmallImage = [UIImage imageNamed:@"girl.jpg"];
    UIImageView* rongLogoSmallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 60, 5, 100, 40)];
    [rongLogoSmallImageView setImage:rongLogoSmallImage];

    [rongLogoSmallImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    rongLogoSmallImageView.contentMode = UIViewContentModeScaleAspectFit;
    rongLogoSmallImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    rongLogoSmallImageView.clipsToBounds = YES;
    [_headBackground addSubview:rongLogoSmallImageView];
    
    //顶部按钮
    UIButton* forgetPswHeadButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 80, 0, 70, 50)];
    [forgetPswHeadButton setTitle:@"新用户" forState:UIControlStateNormal];
    [forgetPswHeadButton setTitleColor:[[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5] forState:UIControlStateNormal];
    [forgetPswHeadButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    [forgetPswHeadButton addTarget:self action:@selector(registerEvent) forControlEvents:UIControlEventTouchUpInside];
    [_headBackground addSubview:forgetPswHeadButton];

    UIImage* rongLogoImage = [UIImage imageNamed:@"qt"];
    _rongLogo = [[UIImageView alloc] initWithImage:rongLogoImage];
    _rongLogo.contentMode = UIViewContentModeScaleAspectFit;
    _rongLogo.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_rongLogo];

    //中部内容输入区
    _inputBackground = [[UIView alloc] initWithFrame:CGRectZero];
    _inputBackground.translatesAutoresizingMaskIntoConstraints = NO;
    _inputBackground.userInteractionEnabled = YES;
    [self.view addSubview:_inputBackground];
    _errorMsgLb = [[UILabel alloc] initWithFrame:CGRectZero];
    _errorMsgLb.text = @"";
    _errorMsgLb.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
    _errorMsgLb.translatesAutoresizingMaskIntoConstraints = NO;
    _errorMsgLb.textColor = [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1];
    [self.view addSubview:_errorMsgLb];

    //用户名
    RCUnderlineTextField* userNameTextField = [[RCUnderlineTextField alloc] initWithFrame:CGRectZero];
    userNameTextField.backgroundColor = [UIColor clearColor];
    userNameTextField.tag = UserTextFieldTag;
    userNameTextField.delegate=self;
    //_account.placeholder=[NSString stringWithFormat:@"Email"];
    UIColor* color = [UIColor whiteColor];
    userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"邮箱" attributes:@{ NSForegroundColorAttributeName : color }];
    userNameTextField.textColor = [UIColor whiteColor];
    userNameTextField.text = [self getDefaultUserName];
    if (userNameTextField.text.length > 0) {
        [userNameTextField setFont:[UIFont fontWithName:@"Heiti SC" size:25.0]];
    }
    userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameTextField.adjustsFontSizeToFitWidth = YES;
    [userNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [_inputBackground addSubview:userNameTextField];

    //密码
    RCUnderlineTextField* passwordTextField = [[RCUnderlineTextField alloc] initWithFrame:CGRectZero];
    passwordTextField.tag = PassWordFieldTag;
    passwordTextField.textColor = [UIColor whiteColor];
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.delegate=self;
    passwordTextField.delegate = self;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{ NSForegroundColorAttributeName : color }];
    passwordTextField.text = [self getDefaultUserPwd];
    [_inputBackground addSubview:passwordTextField];
    passwordTextField.text = [self getDefaultUserPwd];
    self.passwordTextField = passwordTextField;
    
    UIEdgeInsets buttonEdgeInsets = UIEdgeInsetsMake(0, 7.f, 0, 7.f);
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton addTarget:self action:@selector(actionLogin:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login_button.png"] forState:UIControlStateNormal];
    loginButton.imageView.contentMode = UIViewContentModeCenter;
    loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_inputBackground addSubview:loginButton];
    UIButton* userProtocolButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [userProtocolButton setTitle:@"阅读用户协议" forState:UIControlStateNormal];
    [userProtocolButton setTitleColor:[[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5] forState:UIControlStateNormal];

    [userProtocolButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    [userProtocolButton addTarget:self action:@selector(userProtocolEvent) forControlEvents:UIControlEventTouchUpInside];


    [self.view addSubview:userProtocolButton];

    //底部按钮区
    UIView* bottomBackground = [[UIView alloc] initWithFrame:CGRectZero];
    UIButton* registerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, -20, 80, 50)];
    [registerButton setTitle:@"找回密码" forState:UIControlStateNormal];
    [registerButton setTitleColor:[[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5] forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    [registerButton addTarget:self action:@selector(forgetPswEvent) forControlEvents:UIControlEventTouchUpInside];

    [bottomBackground addSubview:registerButton];

    UIButton* forgetPswButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, -20, 80, 50)];
    [forgetPswButton setTitle:@"新用户" forState:UIControlStateNormal];
    [forgetPswButton setTitleColor:[[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5] forState:UIControlStateNormal];
    [forgetPswButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    [forgetPswButton addTarget:self action:@selector(registerEvent) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackground addSubview:forgetPswButton];

    [self.view addSubview:bottomBackground];
    
    bottomBackground.translatesAutoresizingMaskIntoConstraints = NO;
    userProtocolButton.translatesAutoresizingMaskIntoConstraints = NO;
    passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    userNameTextField.translatesAutoresizingMaskIntoConstraints = NO;


    //添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomBackground attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];

    NSDictionary* views = NSDictionaryOfVariableBindings(_errorMsgLb, _rongLogo, _inputBackground, userProtocolButton, bottomBackground);

    NSArray* viewConstraints = [[[[[[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-41-[_inputBackground]-41-|" options:0 metrics:nil views:views]
        arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[_rongLogo]-60-|" options:0 metrics:nil views:views]]
        arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[_rongLogo(==60)]-10-[_errorMsgLb(==10)]-20-[_inputBackground(180)]-20-[userProtocolButton(==20)]" options:0 metrics:nil views:views]]
         arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomBackground(==50)]" options:0 metrics:nil views:views]]
        arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[bottomBackground]-10-|" options:0 metrics:nil views:views]]
        arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_errorMsgLb]-10-|" options:0 metrics:nil views:views]];

    [self.view addConstraints:viewConstraints];

    NSLayoutConstraint* userProtocolLabelConstraint = [NSLayoutConstraint constraintWithItem:userProtocolButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX
                                                                                  multiplier:1.f
                                                                                    constant:0];
    [self.view addConstraint:userProtocolLabelConstraint];
    NSDictionary* inputViews = NSDictionaryOfVariableBindings(userNameTextField, passwordTextField, loginButton);

    NSArray* inputViewConstraints = [[[[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[userNameTextField]|" options:0 metrics:nil views:inputViews]
        arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[passwordTextField]|" options:0 metrics:nil views:inputViews]] arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[userNameTextField(60)]-[passwordTextField(60)]-[loginButton(50)]" options:0 metrics:nil views:inputViews]] arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loginButton]|" options:0 metrics:nil views:inputViews]];

    [_inputBackground addConstraints:inputViewConstraints];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    _statusBarView.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.2];
    [self.view addSubview:_statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.view setNeedsLayout];
    [self.view setNeedsUpdateConstraints];
}

//用户名输入时改变字体大小
- (void)textFieldDidChange:(UITextField*)textField
{
    if (textField.text.length == 0) {
        [textField setFont:[UIFont fontWithName:@"Heiti SC" size:18.0]];
    }
    else {
        [textField setFont:[UIFont fontWithName:@"Heiti SC" size:25.0]];
    }
    
    if ([textField.text isEqualToString:@"appkeydebug"]) {
        [[NSUserDefaults standardUserDefaults] setBool:!self.rcDebug forKey:@"rongcloud appkey debug"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:(!self.rcDebug ? @"进入debug模式，请重新启动应用！":@"退出debug模式，请重新启动应用")
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil,nil];
        [alert show];
        self.rcDebug = !self.rcDebug;
                    exit(0);
        return;
    }
}
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    return YES;
}
//- (BOOL)textFieldShouldClear:(UITextField *)textField
//{
//    switch (textField.tag) {
//        case UserTextFieldTag:
//            [DEFAULTS removeObjectForKey:@"userName"];
//            self.passwordTextField.text = nil;
//        case PassWordFieldTag:
//            [DEFAULTS removeObjectForKey:@"userPwd"];
//            break;
//        default:
//            break;
//    }
//    return YES;
//}

//键盘升起时动画
- (void)keyboardWillShow:(NSNotification*)notif
{

    CATransition* animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.25;
    [_rongLogo.layer addAnimation:animation forKey:nil];

    _rongLogo.hidden = YES;

    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.frame = CGRectMake(0.f, -50, self.view.frame.size.width, self.view.frame.size.height);
        _headBackground.frame=CGRectMake(0, 70, self.view.bounds.size.width, 50);
        _statusBarView.frame = CGRectMake(0.f,50, self.view.frame.size.width,20);
    } completion:nil];
}

//键盘关闭时动画
- (void)keyboardWillHide:(NSNotification*)notif
{
    CATransition* animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.25;
    [_rongLogo.layer addAnimation:animation forKey:nil];

    _rongLogo.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
        CGRectMake(0, -100, self.view.bounds.size.width, 50);
        _headBackground.frame=CGRectMake(0, -100, self.view.bounds.size.width, 50);
        _statusBarView.frame = CGRectMake(0.f,0, self.view.frame.size.width,20);
    } completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.animatedImagesView startAnimating];
    if (self.rcDebug) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self.animatedImagesView stopAnimating];
}

/*阅读用户协议*/
- (void)userProtocolEvent
{
    NSLog(@"阅读用户协议");
}
/*注册*/
- (void)registerEvent
{
    NSLog(@"注册");
//    RCDRegisterViewController* temp = [[RCDRegisterViewController alloc] init];
//    [self.navigationController pushViewController:temp animated:YES];
}

/*找回密码*/
- (void)forgetPswEvent
{
    NSLog(@"找回密码");
//    RCDFindPswViewController* temp = [[RCDFindPswViewController alloc] init];
//    [self.navigationController pushViewController:temp animated:YES];
}
/**
 *  获取默认用户
 *
 *  @return 是否获取到数据
 */
- (BOOL)getDefaultUser
{
    NSString* userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString* userPwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"];
    return userName && userPwd;
}
/*获取用户账号*/
- (NSString*)getDefaultUserName
{
    NSString* defaultUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    return defaultUser;
}

/*获取用户密码*/
- (NSString*)getDefaultUserPwd
{
    NSString* defaultUserPwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"];
    return defaultUserPwd;
}

- (IBAction)actionLogin:(id)sender
{
    NSString* userName = [(UITextField*)[self.view viewWithTag:UserTextFieldTag] text];
     NSString* userPwd = [(UITextField*)[self.view viewWithTag:PassWordFieldTag] text];
//    [self login:userName password:userPwd];
    NSLog(@"登录");
}


- (NSUInteger)animatedImagesNumberOfImages:(RCAnimatedImagesView*)animatedImagesView
{
    return 2;
}

- (UIImage*)animatedImagesView:(RCAnimatedImagesView*)animatedImagesView imageAtIndex:(NSUInteger)index
{
    return [UIImage imageNamed:@"girl.jpg"];
}

#pragma mark - UI

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidUnload
{
    [self setAnimatedImagesView:nil];
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


@end
