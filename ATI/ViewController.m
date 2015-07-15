//
//  ViewController.m
//  ATI
//
//  Created by E2M164 on 15/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import "ViewController.h"
#import "CallListingViewController.h"
#import "WebClient.h"
#import "TKAlertCenter.h"
#import "User.h"
#import "NSString+extras.h"
#import "Common.h"
#import "Helper.h"
#import "SFHFKeychainUtils.h"
#import "MSTextField.h"
#import "UtilityManager.h"
#import "SQLiteManager.h"
#import "AppDelegate.h"

#define kTableName      @"tblEmp"

@interface ViewController ()
{
    AppDelegate *app;
}

@property (strong, nonatomic) IBOutlet MSTextField *txtEmail;
@property (strong, nonatomic) IBOutlet MSTextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UIView *forgotPasswordView;
@property (strong, nonatomic) IBOutlet UITextField *txtForgotEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnRememberMe;
@property (strong, nonatomic) NSMutableArray *arrData;
@property (assign, nonatomic) BOOL isLogin;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self rememberMeInformation];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CommonInit

- (void)commonInit{
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _arrData = [[NSMutableArray alloc]init];
    _isLogin = NO;
    [self rememberMeInformation];
}

#pragma mark - Button Events

-(IBAction)btnLoginTapped:(id)sender {
    [self resignFields];
    if([self isValidLoginDetails]){
        if ([UtilityManager isConnectedToNetwork] == NO || [UtilityManager isDataSourceAvailable] == NO) {
            NSArray *data  = [[SQLiteManager singleton]findAllFrom:kTableName];
            app.firstTime = NO;
            for (int i=0; i<data.count; i++) {
                if ([_txtEmail.text isEqualToString:[[data objectAtIndex:i] valueForKey:@"Email"]] && [_txtPassword.text isEqualToString:[[data objectAtIndex:i] valueForKey:@"Pwd"]]) {
                    _isLogin = YES;
                    NSInteger d = [[NSString stringWithFormat:@"%@",[[data objectAtIndex:i]valueForKey:@"EmployeeID"]]integerValue];
                    [User sharedUser].intEmpID = [[NSNumber numberWithInteger:d]integerValue];
                    [User sharedUser].login = YES;
                    if(_btnRememberMe.selected){
                        [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
                        [User sharedUser].strEmail= _txtEmail.text;
                        [SFHFKeychainUtils storeUsername:[User sharedUser].strEmail andPassword:_txtPassword.text forServiceName:[User sharedUser].strEmail updateExisting:YES error:nil];
                    }
                    CallListingViewController *call=[self.storyboard instantiateViewControllerWithIdentifier:@"CallListingViewController"];
                    [self.navigationController pushViewController:call animated:YES];
                }else{
                    
                }
            }
            if (_isLogin == NO) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Please enter correct Email or Password!" image:kErrorImage];
            }
        } else{
            NSDictionary *dict = @{@"email": _txtEmail.text,@"password":_txtPassword.text};

            [[WebClient sharedClient] loginIntoApplication:dict success:^(NSDictionary *dictionary) {
                if(dictionary!=nil){
                    if([User saveCredentials:dictionary]) {
                        [User sharedUser].login = YES;
                        if(_btnRememberMe.selected){
                            [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
                            [User sharedUser].strEmail= _txtEmail.text;
                            [SFHFKeychainUtils storeUsername:[User sharedUser].strEmail andPassword:_txtPassword.text forServiceName:[User sharedUser].strEmail updateExisting:YES error:nil];
                        }
                        NSArray *data  = [[SQLiteManager singleton]findAllFrom:kTableName];
                        if (data.count == 0) {
                            [self saveIntoLocalDB:dictionary];
                        }
                        for (int i=0; i<data.count; i++) {
                            if ([_txtEmail.text isEqualToString:[[data objectAtIndex:i] valueForKey:@"Email"]] && [_txtPassword.text isEqualToString:[[data objectAtIndex:i] valueForKey:@"Pwd"]]) {
                            }else{
                                [self saveIntoLocalDB:dictionary];
                            }
                        }

                        CallListingViewController *call=[self.storyboard instantiateViewControllerWithIdentifier:@"CallListingViewController"];
                        [self.navigationController pushViewController:call animated:YES];
                    }
                }
            } failure:^(NSError *error) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:error.localizedDescription image:kErrorImage];
            }];
        }
    }
}

- (void)rememberMeInformation{
    User *user = [Helper getCustomObjectToUserDefaults:kUserInformation];
    if(user){
        if(user.login){
            [UIApplication sharedApplication].statusBarHidden = NO;
            CallListingViewController *call=[self.storyboard instantiateViewControllerWithIdentifier:@"CallListingViewController"];
            [self.navigationController pushViewController:call animated:NO];
        }else if(user.rememberMe){
            _txtEmail.text = user.strEmail;
            _txtPassword.text = [SFHFKeychainUtils getPasswordForUsername:user.strEmail andServiceName:user.strEmail error:nil];
            _btnRememberMe.selected = YES;
        }
    }else {
        _txtEmail.text = @"";
        _txtPassword.text = @"";
        _btnRememberMe.selected = NO;
    }
}

- (IBAction)btnForgotPasswordTapped:(id)sender {
    [self resignFields];
    _loginView.hidden = YES;
    _forgotPasswordView.hidden = NO;
}

- (IBAction)btnSendTapped:(id)sender {
    [_txtForgotEmail resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _mainView.frame;
        frame.origin.y = 0;
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];

    if([self isValidForgotDetails]){
        [[WebClient sharedClient] forgotPassword:@{@"email":_txtForgotEmail.text} success:^(NSDictionary *dictionary) {
            BOOL success = [dictionary[@"success"] boolValue];
            if (success) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
                [self btnCancelTapped:nil];
            }else{
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        } failure:^(NSError *error) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:error.localizedDescription image:kErrorImage];
        }];
    }
}

- (void)resignFields{
    [_txtEmail resignFirstResponder];
    [_txtPassword resignFirstResponder];
}

- (IBAction)btnCancelTapped:(id)sender {
    [_txtForgotEmail resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _mainView.frame;
        frame.origin.y = 0;
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];

    _forgotPasswordView.hidden = YES;
    _loginView.hidden = NO;
}

- (IBAction)btnRememberMeTapped:(UIButton*)sender {
    sender.selected = !sender.selected;
    [User sharedUser].rememberMe = sender.selected;
}

- (void)saveIntoLocalDB:(NSDictionary *)dictionary{
    NSDictionary *dict = dictionary[@"userdata"];
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO tblEmp (CatID,Email,EmployeeID,EmployeeNo,First,Last,LocID,LoginID,NewEmpNotify,Pwd,Status,TypeID) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",dict[@"CatID"],dict[@"Email"],dict[@"EmployeeID"],dict[@"EmployeeNo"],dict[@"First"],dict[@"Last"],dict[@"LocID"],dict[@"LoginID"],dict[@"NewEmpNotify"],dict[@"Pwd"],dict[@"Status"],dict[@"TypeID"]];
    app.firstTime = YES;
    [[SQLiteManager singleton] executeSql:insertSQL];
}

#pragma mark - Validate login Information

- (BOOL)isValidLoginDetails{
    if(!_txtEmail.text || [_txtEmail.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterEmail image:kErrorImage];
        return NO;
    }
//    if(![_txtEmail.text isValidEmail]){
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidEmail image:kErrorImage];
//        return NO;
//    }
    if(!_txtPassword.text || [_txtPassword.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidPassword image:kErrorImage];
        return NO;
    }
    return YES;
}

- (BOOL)isValidForgotDetails{
    if(!_txtForgotEmail.text || [_txtForgotEmail.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterEmail image:kErrorImage];
        return NO;
    }
    if(![_txtForgotEmail.text isValidEmail]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidEmail image:kErrorImage];
        return NO;
    }
    return YES;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _mainView.frame;
        frame.origin.y = 0;
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];
   
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = _mainView.frame;
    if (IPHONE4S) {
        frame.origin.y = -150;
    }else if (IPHONE5S){
        frame.origin.y = -50;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];
}

#pragma mark - Keyboard Notifications

- (void)sfkeyboardWillHide:(NSNotification*)notification{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _mainView.frame;
        frame.origin.y = 0;
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];
}

- (void)sfkeyboardWillShow:(NSNotification*)notification{
    
}

@end
