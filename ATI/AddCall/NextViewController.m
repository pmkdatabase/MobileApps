//
//  NextViewController.m
//  ATI
//
//  Created by Manish Dudharejia on 30/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import "NextViewController.h"
#import "MSTextField.h"
#import "UtilityManager.h"
#import "SQLiteManager.h"
#import "TKAlertCenter.h"
#import "PartViewController.h"
#import "CallListingViewController.h"
#import "Helper.h"
#import "Common.h"

#define kTableName      @"tblCommonData"

@interface NextViewController ()

@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIView *pageView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) IBOutlet UITextView *txtDesc1;
@property (strong, nonatomic) IBOutlet UITextView *txtDesc2;
@property (strong, nonatomic) IBOutlet UITextView *txtDesc3;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet MSTextField *txtQty1;
@property (strong, nonatomic) IBOutlet MSTextField *txtQty2;
@property (strong, nonatomic) IBOutlet MSTextField *txtQty3;
@property (strong, nonatomic) IBOutlet MSTextField *txtDuration1;
@property (strong, nonatomic) IBOutlet MSTextField *txtDuration2;
@property (strong, nonatomic) IBOutlet MSTextField *txtDuration3;

@property (strong, nonatomic) IBOutlet UIButton *btnPart1;
@property (strong, nonatomic) IBOutlet UIButton *btnPart2;
@property (strong, nonatomic) IBOutlet UIButton *btnPart3;
@property (strong, nonatomic) IBOutlet UIButton *btnDuration1;
@property (strong, nonatomic) IBOutlet UIButton *btnDuration2;
@property (strong, nonatomic) IBOutlet UIButton *btnDuration3;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;

@property (assign, nonatomic) NSInteger intServiceID;
@property (strong, nonatomic) IBOutlet UILabel *lblPicker;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) NSString *strBarCode1,*strBarCode2,*strBarCode3,*strPart1id,*strPart2id,*strPart3id,*date,*completedDate;

@property (assign, nonatomic) BOOL isStatus;
@property (assign, nonatomic) BOOL isUpdate;

@end

@implementation NextViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [_btnPart1 setTitle:[Helper getFromNSUserDefaults:@"Part1"] forState:UIControlStateNormal];
    [_btnPart2 setTitle:[Helper getFromNSUserDefaults:@"Part2"] forState:UIControlStateNormal];
    [_btnPart3 setTitle:[Helper getFromNSUserDefaults:@"Part3"] forState:UIControlStateNormal];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    if ([_strTitle isEqualToString:@"Add Call"]) {
        _txtDesc1.text = _txtDesc2.text = _txtDesc3.text = @"  Labour Description";
        _txtDesc1.textColor = _txtDesc2.textColor = _txtDesc3.textColor = [UIColor lightGrayColor];
    }else{
//        if ([UtilityManager isConnectedToNetwork] == NO || [UtilityManager isDataSourceAvailable] == NO) {
        _lblTitle.text = @"Update Call";
        [_btnSave setTitle:@"UPDATE" forState:UIControlStateNormal];
        [Helper addToNSUserDefaults:_tableData.strPart1Name forKey:@"Part1"];
        [Helper addToNSUserDefaults:_tableData.strPart2Name forKey:@"Part2"];
        [Helper addToNSUserDefaults:_tableData.strPart3Name forKey:@"Part3"];
        _txtDesc1.text = _tableData.strPart1Desc;
        _txtDesc2.text = _tableData.strPart2Desc;
        _txtDesc3.text = _tableData.strPart3Desc;
        _txtQty1.text = _tableData.strPart1Qty;
        _txtQty2.text = _tableData.strPart2Qty;
        _txtQty3.text = _tableData.strPart3Qty;
        _txtDuration1.text = _tableData.strDuration1;
        _txtDuration2.text = _tableData.strDuration2;
        _txtDuration3.text = _tableData.strDuration3;
        _strBarCode1 = _tableData.strPart1Bcode;
        _strBarCode2 = _tableData.strPart2Bcode;
        _strBarCode3 = _tableData.strPart3Bcode;

        if ([_txtDesc1.text isEqualToString:@""]) {
            _txtDesc1.text = @"  Labour Description";
            _txtDesc1.textColor = [UIColor lightGrayColor];
        }
        if ([_txtDesc2.text isEqualToString:@""]) {
            _txtDesc2.text = @"  Labour Description";
            _txtDesc2.textColor = [UIColor lightGrayColor];
        }
        if ([_txtDesc3.text isEqualToString:@""]) {
            _txtDesc3.text = @"  Labour Description";
            _txtDesc3.textColor = [UIColor lightGrayColor];
        }

//        }else{
//            _lblTitle.text = @"Update Call";
//            [_btnSave setTitle:@"UPDATE" forState:UIControlStateNormal];
//            [Helper addToNSUserDefaults:_callList.strPart1Name forKey:@"Part1"];
//            [Helper addToNSUserDefaults:_callList.strPart2Name forKey:@"Part2"];
//            [Helper addToNSUserDefaults:_callList.strPart3Name forKey:@"Part3"];
//            
//            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:_callList.intPartID1] forKey:@"PartNo1"];
//            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:_callList.intPartID2] forKey:@"PartNo2"];
//            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:_callList.intPartID3] forKey:@"PartNo3"];
//
//            [Helper addToNSUserDefaults:_callList.strPart1Bcode forKey:@"BarCode1"];
//            [Helper addToNSUserDefaults:_callList.strPart2Bcode forKey:@"BarCode2"];
//            [Helper addToNSUserDefaults:_callList.strPart3Bcode forKey:@"BarCode3"];
//
//            _txtDesc1.text = _callList.strPart1Desc;
//            _txtDesc2.text = _callList.strPart2Desc;
//            _txtDesc3.text = _callList.strPart3Desc;
//            _txtQty1.text = _callList.strPart1Qty;
//            _txtQty2.text = _callList.strPart2Qty;
//            _txtQty3.text = _callList.strPart3Qty;
//            _txtDuration1.text = _callList.strDuration1;
//            _txtDuration2.text = _callList.strDuration2;
//            _txtDuration3.text = _callList.strDuration3;
//        }
    }
}

-(IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnPart1Tapped:(id)sender{
    [self showPartController:@"Part1"];
}

-(IBAction)btnPart2Tapped:(id)sender{
    [self showPartController:@"Part2"];
}

-(IBAction)btnPart3Tapped:(id)sender{
    [self showPartController:@"Part3"];
}

-(IBAction)btnDuration1Tapped:(id)sender{
    [self resignFields];
    _btnDuration1.selected = YES;
    _btnDuration2.selected = _btnDuration3.selected = NO;
    [self showTimePickerView];
}

-(IBAction)btnDuration2Tapped:(id)sender{
    [self resignFields];
    _btnDuration2.selected = YES;
    _btnDuration1.selected = _btnDuration3.selected = NO;
    [self showTimePickerView];
}

-(IBAction)btnDuration3Tapped:(id)sender{
    [self resignFields];
    _btnDuration3.selected = YES;
    _btnDuration2.selected = _btnDuration1.selected = NO;
    [self showTimePickerView];
}

- (IBAction)btnCloseTapped:(id)sender{
    [self hideKeyboard];
    _pickerView.hidden = YES;
}

- (IBAction)btnRightTapped:(id)sender{
    [self hideKeyboard];
    _pickerView.hidden = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (_datePicker.datePickerMode == UIDatePickerModeCountDownTimer){
        [dateFormatter setDateFormat:kTimeFormat];
    }
    NSString *value = [dateFormatter stringFromDate:_datePicker.date];
    
    if (_btnDuration1.selected) {
        _txtDuration1.text = [value stringByAppendingString:@" hrs"];
    }else if (_btnDuration2.selected){
        _txtDuration2.text = [value stringByAppendingString:@" hrs"];
    }else if (_btnDuration3.selected){
        _txtDuration3.text = [value stringByAppendingString:@" hrs"];
    }    
}

-(IBAction)btnSaveTapped:(id)sender{
    if ([_btnPart1.titleLabel.text isEqualToString:@"Part1"] && [_btnPart2.titleLabel.text isEqualToString:@"Part2"] && [_btnPart3.titleLabel.text isEqualToString:@"Part3"]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgSelectPart image:kErrorImage];
    }
//    else if ([_txtQty1.text isEmptyString] && [_txtQty2.text isEmptyString] && [_txtQty3.text isEmptyString]){
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgSelectQuantity image:kErrorImage];
//    }else if ([_btnDuration1.titleLabel.text isEmptyString] || [_btnDuration2.titleLabel.text isEmptyString] || [_btnDuration3.titleLabel.text isEmptyString]){
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgSelectDuration image:kErrorImage];
//    }
    else{
        //_date = [[[_strYY stringByAppendingString:[NSString stringWithFormat:@"-%@",_strMM]]stringByAppendingString:[NSString stringWithFormat:@"-%@",_strDD]]stringByAppendingString:[NSString stringWithFormat:@" %@",_timedate]];
        NSLog(@"Date %@",[Helper dateStringFromString:[[[_strYY stringByAppendingString:[NSString stringWithFormat:@"-%@",_strMM]]stringByAppendingString:[NSString stringWithFormat:@"-%@",_strDD]]stringByAppendingString:[NSString stringWithFormat:@" %@",_timedate]] format:kDateTimeFormat toFormat:kSendDateFormat]);
        
        _date = [Helper dateStringFromString:[[[_strYY stringByAppendingString:[NSString stringWithFormat:@"-%@",_strMM]]stringByAppendingString:[NSString stringWithFormat:@"-%@",_strDD]]stringByAppendingString:[NSString stringWithFormat:@" %@",_timedate]] format:kDateTimeFormat toFormat:kSendDateFormat];
        
        _completedDate = [Helper dateStringFromString:[[[_strCompletedYY stringByAppendingString:[NSString stringWithFormat:@"-%@",_strCompletedMM]] stringByAppendingString:[NSString stringWithFormat:@"-%@",_strCompletedDD]]stringByAppendingString:[NSString stringWithFormat:@" %@",_timecompletedDate]] format:kDateTimeFormat toFormat:kSendDateFormat];
        
        _strBarCode1 = [Helper getFromNSUserDefaults:@"BarCode1"];
        _strBarCode2 = [Helper getFromNSUserDefaults:@"BarCode2"];
        _strBarCode3 = [Helper getFromNSUserDefaults:@"BarCode3"];

        if (_strBarCode1 == nil) {
            _strBarCode1 = @"";
        }
        if (_strBarCode2 == nil) {
            _strBarCode2 = @"";
        }
        if (_strBarCode3 == nil) {
            _strBarCode3 = @"";
        }

        _strPart1id = [NSString stringWithFormat:@"%@",[Helper getFromNSUserDefaults:@"PartNo1"]];
        _strPart2id = [NSString stringWithFormat:@"%@",[Helper getFromNSUserDefaults:@"PartNo2"]];
        _strPart3id = [NSString stringWithFormat:@"%@",[Helper getFromNSUserDefaults:@"PartNo3"]];

        if ([_txtDesc1.text isEqualToString:@"  Labour Description"]) {
            _txtDesc1.text = @"";
        }
        if ([_txtDesc2.text isEqualToString:@"  Labour Description"]) {
            _txtDesc2.text = @"";
        }
        if ([_txtDesc3.text isEqualToString:@"  Labour Description"]) {
            _txtDesc3.text = @"";
        }

        if (_completedDate == nil) {
            _completedDate = @"";
        }
        if ([UtilityManager isConnectedToNetwork] == NO || [UtilityManager isDataSourceAvailable] == NO) {
            if ([_strTitle isEqualToString:@"Update Call"]) {
                _isUpdate = YES;
                _isStatus = YES;
            }else{
                _isStatus = NO;
            }
            _intServiceID = [User sharedUser].intLastServiceId + 1;
            [self saveIntoLocalDataBase];
        } else {
            if ([_strTitle isEqualToString:@"Update Call"]) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:_tableData.intServicecall_id],@"id",_date,@"date",_strObjectID,@"objectid",[[NSNumber numberWithInteger:[User sharedUser].intEmpID] stringValue],@"empid",_strType,@"task_type",_strTask1,@"task1",_strTask2,@"task2",_strTask3,@"task3",_strBarCode1,@"part1bcode",_strPart1id,@"part1id",_txtQty1.text,@"qtypart1",_txtDuration1.text,@"duration1",_txtDesc1.text,@"part1labesc",_strBarCode2,@"part2bcode",_strPart2id,@"part2id",_txtQty2.text,@"qtypart2",_txtDuration2.text,@"duration2",_txtDesc2.text,@"part2labesc",_strBarCode3,@"part3bcode",_strPart3id,@"part3id",_txtQty3.text,@"qtypart3",_txtDuration3.text,@"duration3",_txtDesc3.text,@"part3labesc",_strStatus,@"status",_completedDate,@"datecompleted",@"",@"dateexported",[User sharedUser].strLongitude,@"longitudes",[User sharedUser].strLatitude,@"latitudes",nil];

                [[WebClient sharedClient] editCall:dict success:^(NSDictionary *dictionary) {
                    NSLog(@"dictionary %@",dictionary);
                    if (dictionary!=nil) {
                        if([dictionary[@"success"] boolValue] == YES){
                            _isUpdate = YES;
                            _isStatus = YES;
                            [self saveIntoLocalDataBase];
                            [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
                            CallListingViewController *add=[self.storyboard instantiateViewControllerWithIdentifier:@"CallListingViewController"];
                            [self.navigationController pushViewController:add animated:NO];
                        }else {
                            [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
                        }
                    }
                } failure:^(NSError *error) {
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
                }];
            }else{
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:_date,@"date",_strObjectID,@"objectid",[[NSNumber numberWithInteger:[User sharedUser].intEmpID] stringValue],@"empid",_strType,@"task_type",_strTask1,@"task1",_strTask2,@"task2",_strTask3,@"task3",_strBarCode1,@"part1bcode",_strPart1id,@"part1id",_txtQty1.text,@"qtypart1",_txtDuration1.text,@"duration1",_txtDesc1.text,@"part1labesc",_strBarCode2,@"part2bcode",_strPart2id,@"part2id",_txtQty2.text,@"qtypart2",_txtDuration2.text,@"duration2",_txtDesc2.text,@"part2labesc",_strBarCode3,@"part3bcode",_strPart3id,@"part3id",_txtQty3.text,@"qtypart3",_txtDuration3.text,@"duration3",_txtDesc3.text,@"part3labesc",_strStatus,@"status",_completedDate,@"datecompleted",@"",@"dateexported",[User sharedUser].strLongitude,@"longitudes",[User sharedUser].strLatitude,@"latitudes",nil];

                [[WebClient sharedClient] addCall:dict success:^(NSDictionary *dictionary) {
                    NSLog(@"dictionary %@",dictionary);
                    if (dictionary!=nil) {
                        if([dictionary[@"success"] boolValue] == YES){
                            _isStatus = YES;
                            _intServiceID = [dictionary[@"services_id"]integerValue];
                            [self saveIntoLocalDataBase];
                            [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
                            // [self.navigationController popViewControllerAnimated:YES];
                            CallListingViewController *add=[self.storyboard instantiateViewControllerWithIdentifier:@"CallListingViewController"];
                            [self.navigationController pushViewController:add animated:NO];
                            
                        }else {
                            [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
                        }
                    }
                } failure:^(NSError *error) {
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
                }];
            }
        }
    }
}

- (void)saveIntoLocalDataBase{

    NSString *strEmpId = [NSString stringWithFormat:@"%ld",(long)[User sharedUser].intEmpID];
    NSString *strVehicleNo = [NSString stringWithFormat:@"%@",[Helper getFromNSUserDefaults:@"VehicleNo"]];
    
    NSString *strTask1Name = [NSString stringWithFormat:@"%@",[Helper getFromNSUserDefaults:@"Task1"]];
    NSString *strTask2Name = [NSString stringWithFormat:@"%@",[Helper getFromNSUserDefaults:@"Task2"]];
    NSString *strTask3Name = [NSString stringWithFormat:@"%@",[Helper getFromNSUserDefaults:@"Task3"]];
    
    NSString *value;
    if (_isStatus) {
        value = @"1";
    }else{
        value = @"0";
    }
    
    NSString *updateVal;
    if (_isUpdate) {
        updateVal = @"1";
    }else{
        updateVal = @"0";
    }
    
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO tblCommonData (date,datecompleted,objectid,empid,task_type,task1,task2,task3,part1bcode,part1id,qtypart1,part1desc,part2bcode,part2id,qtypart2,part2desc,part3bcode,part3id,qtypart3,part3desc,status,vehicleno,part1name,part2name,part3name,task1name,task2name,task3name,duration1,duration2,duration3,isstatus,dateexported,latitudes,longitudes,isupdate,servicecall_id) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%ld')", _date,_completedDate,_strObjectID,strEmpId,_strType,_strTask1,_strTask2,_strTask3,_strBarCode1,_strPart1id,_txtQty1.text,_txtDesc1.text,_strBarCode2,_strPart2id,_txtQty2.text,_txtDesc2.text,_strBarCode3,_strPart3id,_txtQty3.text,_txtDesc3.text,_strStatus,strVehicleNo,_btnPart1.titleLabel.text,_btnPart2.titleLabel.text,_btnPart3.titleLabel.text,strTask1Name,strTask2Name,strTask3Name,_txtDuration1.text,_txtDuration2.text,_txtDuration3.text,value,@"",[User sharedUser].strLatitude,[User sharedUser].strLongitude,updateVal,(long)_intServiceID];
    
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tblCommonData set date = '%@',datecompleted = '%@',objectid = '%@',empid = '%@',task_type = '%@',task1 = '%@',task2 = '%@',task3 = '%@',part1bcode = '%@',part1id = '%@',qtypart1 = '%@',part1desc = '%@',part2bcode = '%@',part2id = '%@',qtypart2 = '%@',part2desc = '%@',part3bcode = '%@',part3id = '%@',qtypart3 = '%@',part3desc = '%@',status = '%@',vehicleno = '%@',part1name = '%@',part2name = '%@',part3name = '%@',task1name = '%@',task2name = '%@',task3name = '%@',duration1 = '%@',duration2 = '%@',duration3 = '%@',isstatus = '%@',dateexported = '%@',latitudes = '%@',longitudes = '%@',isupdate = '%@'  WHERE servicecall_id = %ld", _date,_completedDate,_strObjectID,strEmpId,_strType,_strTask1,_strTask2,_strTask3,_strBarCode1,_strPart1id,_txtQty1.text,_txtDesc1.text,_strBarCode2,_strPart2id,_txtQty2.text,_txtDesc2.text,_strBarCode3,_strPart3id,_txtQty3.text,_txtDesc3.text,_strStatus,strVehicleNo,_btnPart1.titleLabel.text,_btnPart2.titleLabel.text,_btnPart3.titleLabel.text,strTask1Name,strTask2Name,strTask3Name,_txtDuration1.text,_txtDuration2.text,_txtDuration3.text,value,@"",[User sharedUser].strLatitude,[User sharedUser].strLongitude,updateVal,(long)_tableData.intServicecall_id];
    
    if ([_lblTitle.text isEqualToString:@"Update Call"]) {
        [[SQLiteManager singleton] executeSql:updateSQL];
    }else{
        [[SQLiteManager singleton] executeSql:insertSQL];
    }
    CallListingViewController *add=[self.storyboard instantiateViewControllerWithIdentifier:@"CallListingViewController"];
    [self.navigationController pushViewController:add animated:NO];
}

- (void)showTimePickerView{
    [self resignFields];
    _pickerView.hidden = NO;
    _datePicker.hidden = NO;
    _lblPicker.text = @"SELECT DURATION";
    [self.view bringSubviewToFront:_datePicker];
    _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kTimeFormat];
    [_datePicker setDate:[NSDate date]];
    [_datePicker setCountDownDuration:3600.0f];
}

- (void)showPartController:(NSString *)strName{
    PartViewController *partViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PartViewController"];
    partViewController.strCategory = strName;
    [self.navigationController pushViewController:partViewController animated:YES];
}

#pragma mark - UITextView Delegate Methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView{
    _pickerView.hidden = YES;
    if ([_strTitle isEqualToString:@"Add Call"]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];
    if (textView == _txtDesc2) {
        CGRect frame = _pageView.frame;
        if (IPHONE4S) {
            frame.origin.y = -200;
        }else if (IPHONE5S || IPHONE6 || IPHONE6PLUS){
            frame.origin.y = -100;
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            _pageView.frame = frame;
        }];
        [UIView commitAnimations];
    }else if (textView == _txtDesc3){
        CGRect frame = _pageView.frame;
        if (IPHONE4S) {
            frame.origin.y = -250;
        }else if (IPHONE5S || IPHONE6 || IPHONE6PLUS){
            frame.origin.y = -200;
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            _pageView.frame = frame;
        }];
        [UIView commitAnimations];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self hideKeyboard];
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView{
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"  Labour Description";
        [textView resignFirstResponder];
    }
    if ([textView.text isEqualToString:@""]) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"  Labour Description";
        [textView resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _pageView.frame;
        frame.origin.y = 0;
        _pageView.frame = frame;
    }];
    [UIView commitAnimations];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _pickerView.hidden = YES;
    CGRect frame = _pageView.frame;
    if (textField == _txtQty2) {
        if (IPHONE4S) {
            frame.origin.y = -200;
        }else if (IPHONE5S || IPHONE6 || IPHONE6PLUS){
            frame.origin.y = -100;
        }
    }else if (textField == _txtQty3){
        if (IPHONE4S) {
            frame.origin.y = -250;
        }else if (IPHONE5S || IPHONE6 || IPHONE6PLUS){
            frame.origin.y = -200;
        }
    }
    [UIView animateWithDuration:0.4 animations:^{
        _pageView.frame = frame;
    }];
    [UIView commitAnimations];
}

- (void)resignFields{
    [_txtQty1 resignFirstResponder];
    [_txtQty2 resignFirstResponder];
    [_txtQty3 resignFirstResponder];
    [_txtDesc1 resignFirstResponder];
    [_txtDesc2 resignFirstResponder];
    [_txtDesc3 resignFirstResponder];
}

#pragma mark - Keyboard Notifications

- (void)sfkeyboardWillHide:(NSNotification*)notification{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _pageView.frame;
        frame.origin.y = 0;
        _pageView.frame = frame;
    }];
    [UIView commitAnimations];
}

- (void)sfkeyboardWillShow:(NSNotification*)notification{
    
}

- (void)hideKeyboard{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _pageView.frame;
        frame.origin.y = 0;
        _pageView.frame = frame;
    }];
    [UIView commitAnimations];
}

- (void)showKeyboard{
    CGRect frame = _pageView.frame;
    if (IPHONE4S) {
        frame.origin.y = -150;
    }else if (IPHONE5S || IPHONE6 || IPHONE6PLUS){
        frame.origin.y = -100;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        _pageView.frame = frame;
    }];
    [UIView commitAnimations];
}

@end
