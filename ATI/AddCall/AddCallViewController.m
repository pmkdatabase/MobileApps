//
//  AddCallViewController.m
//  ATI
//
//  Created by E2M164 on 15/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import "AddCallViewController.h"
#import "SearchViewController.h"
#import "CallListingViewController.h"
#import "NextViewController.h"
#import "PartViewController.h"
#import "SFHFKeychainUtils.h"
#import "SQLiteManager.h"
#import "WebClient.h"
#import "TKAlertCenter.h"
#import "Common.h"
#import "MSTextField.h"
#import "Vehicle.h"
#import "Task.h"
#import "AddCall.h"
#import "User.h"
#import "Helper.h"
#import "UtilityManager.h"
#import "AppDelegate.h"
#import "SIAlertView.h"

#define kTableName          @"tblData"

@interface AddCallViewController ()
{
    AppDelegate *app;
}

@property (strong, nonatomic) IBOutlet UIView *viewPage1;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *lblPicker;
@property (strong, nonatomic) IBOutlet UILabel *lblDD;
@property (strong, nonatomic) IBOutlet UILabel *lblMM;
@property (strong, nonatomic) IBOutlet UILabel *lblYY;
@property (strong, nonatomic) IBOutlet UILabel *lblDDCompleted;
@property (strong, nonatomic) IBOutlet UILabel *lblMMCompleted;
@property (strong, nonatomic) IBOutlet UILabel *lblYYCompleted;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UIButton *btnCalendar;
@property (strong, nonatomic) IBOutlet UIButton *btnCalendar1;
@property (strong, nonatomic) IBOutlet UIButton *btnVehical;
@property (strong, nonatomic) IBOutlet UIButton *btnTask1;
@property (strong, nonatomic) IBOutlet UIButton *btnTask2;
@property (strong, nonatomic) IBOutlet UIButton *btnTask3;
@property (strong, nonatomic) IBOutlet UIButton *btnRepair;
@property (strong, nonatomic) IBOutlet UIButton *btnMaintanence;
@property (strong, nonatomic) IBOutlet UIButton *btnActive;
@property (strong, nonatomic) IBOutlet UIButton *btnInActive;

@property (strong, nonatomic) NSString *dateCompleted;
@property (strong, nonatomic) NSMutableArray *arrVehicle;
@property (strong, nonatomic) NSMutableArray *arrTask;
@property (strong, nonatomic) NSString *timedate;
@property (strong, nonatomic) NSString *timecompletedDate;

@property (strong, nonatomic) AddCall *addCall;
@property (strong, nonatomic) Vehicle *vehicle;
@property (strong, nonatomic) Task *task;

@end

@implementation AddCallViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [_btnVehical setTitle:[Helper getFromNSUserDefaults:@"VehicleNo"] forState:UIControlStateNormal];
    [_btnTask1 setTitle:[Helper getFromNSUserDefaults:@"Task1"] forState:UIControlStateNormal];
    [_btnTask2 setTitle:[Helper getFromNSUserDefaults:@"Task2"] forState:UIControlStateNormal];
    [_btnTask3 setTitle:[Helper getFromNSUserDefaults:@"Task3"] forState:UIControlStateNormal];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init Method

-(void)commonInit {
    if ([_strTitle isEqualToString:@"Add Call"]) {
        _arrVehicle = [[NSMutableArray alloc]init];
        _arrTask = [[NSMutableArray alloc]init];
        _btnRepair.selected = YES;
        _btnActive.selected = YES;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:kDateTimeFormat];
        NSString *value = [dateFormatter stringFromDate:_datePicker.date];
        NSArray *arrval = [value componentsSeparatedByString:@" "];
        NSArray *arrValue = [arrval[0] componentsSeparatedByString:@"-"];
        _lblYY.text = arrValue[0];
        _lblMM.text = [arrValue[1]uppercaseString];
        _lblDD.text = arrValue[2];
        _timedate = arrval[1];

        _addCall.date=[NSString stringWithFormat:@"%@-%@-%@",_lblYY.text,_lblMM.text,_lblDD.text];
        
    }else{
//        if ([UtilityManager isConnectedToNetwork] == NO || [UtilityManager isDataSourceAvailable] == NO) {
        _lblTitle.text = @"Update Call";
        NSArray *date = [_tableData.strDate componentsSeparatedByString:@" "];
        NSArray *arrDate = [[Helper dateStringFromString:date[0] format:@"yyyy-MM-dd" toFormat:kDateFormat]componentsSeparatedByString:@"-"];
        _lblYY.text = arrDate[0];
        _lblMM.text = [arrDate[1] uppercaseString];
        _lblDD.text = arrDate[2];
        _timedate = date[1];

        if ([_tableData.strDateCompleted isEqualToString:@""]) {
            
        }else{
            NSArray *completed = [_tableData.strDateCompleted componentsSeparatedByString:@" "];
            NSArray *arrDateCompleted = [[Helper dateStringFromString:completed[0] format:@"yyyy-MM-dd" toFormat:kDateFormat]componentsSeparatedByString:@"-"];
            
            _lblYYCompleted.text = arrDateCompleted[0];
            _lblMMCompleted.text = [arrDateCompleted[1] uppercaseString];
            _lblDDCompleted.text = arrDateCompleted[2];
            _timecompletedDate = completed[1];
        }

        [Helper addToNSUserDefaults:_tableData.strVehicleNo forKey:@"VehicleNo"];
        [Helper addToNSUserDefaults:_tableData.strObjectID forKey:@"VehicleID"];
        [Helper addToNSUserDefaults:_tableData.strTask1Name forKey:@"Task1"];
        [Helper addToNSUserDefaults:_tableData.strTask2Name forKey:@"Task2"];
        [Helper addToNSUserDefaults:_tableData.strTask3Name forKey:@"Task3"];
        
//        if ([_tableData.strType isEqualToString:@"Repair"]) {
//            [self btnRepaireTapped:_btnRepair];
//        }else{
//            [self btnMaintanenceTapped:_btnMaintanence];
//        }
        
        if ([_tableData.strStatus isEqualToString:@"Active"]) {
            [self btnActiveTapped:_btnActive];
        }else{
            [self btnInActiveTapped:_btnInActive];
        }
//        }else{
//            _lblTitle.text = @"Update Call";
//            NSArray *arrDate = [[Helper dateStringFromString:_callList.strDate format:kSendDateFormat toFormat:kDateFormat]componentsSeparatedByString:@"-"];
//            _lblYY.text = arrDate[0];
//            _lblMM.text = [arrDate[1] uppercaseString];
//            _lblDD.text = arrDate[2];
//            
//            NSArray *datecomp = [_callList.strDateCompleted componentsSeparatedByString:@" "];
//            NSArray *arrDateCompleted = [[Helper dateStringFromString:datecomp[0] format:kSendDateFormat toFormat:kDateFormat]componentsSeparatedByString:@"-"];
//            
//            _lblYYCompleted.text = arrDateCompleted[0];
//            _lblMMCompleted.text = [arrDateCompleted[1] uppercaseString];
//            _lblDDCompleted.text = arrDateCompleted[2];
//            
//            [Helper addToNSUserDefaults:_callList.strVehicleNo forKey:@"VehicleNo"];
//            [Helper addToNSUserDefaults:_callList.strTask1 forKey:@"Task1"];
//            [Helper addToNSUserDefaults:_callList.strTask2 forKey:@"Task2"];
//            [Helper addToNSUserDefaults:_callList.strTask3 forKey:@"Task3"];
//            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:_callList.intObjectID] forKey:@"VehicleID"];
//            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:_callList.intRepairID1] forKey:@"RepairID1"];
//            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:_callList.intRepairID2] forKey:@"RepairID2"];
//            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:_callList.intRepairID3] forKey:@"RepairID3"];
//
//            if ([_callList.strType isEqualToString:@"Repair"]) {
//                [self btnRepaireTapped:_btnRepair];
//            }else{
//                [self btnMaintanenceTapped:_btnMaintanence];
//            }
//            if ([_callList.strStatus isEqualToString:@"Active"]) {
//                [self btnActiveTapped:_btnActive];
//            }else{
//                [self btnInActiveTapped:_btnInActive];
//            }
//        }
    }
}

#pragma mark - button events

-(IBAction)btnRepaireTapped:(UIButton *)sender {
//    _btnMaintanence.selected=NO;
//    _btnRepair.selected=YES;
//    [_btnRepair setBackgroundColor:[UIColor colorWithRed:68.0/255.0 green:177.0/255.0 blue:124.0/255.0 alpha:1.0]];
//    [_btnMaintanence setBackgroundColor:[UIColor whiteColor]];
//    _addCall.taskType=@"REPAIR";
}
-(IBAction)btnMaintanenceTapped:(UIButton *)sender {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"MAINTENANCE" andMessage:@"Not Active."];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {

                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [alertView show];
    
//    _btnMaintanence.selected=YES;
//    _btnRepair.selected=NO;
//    [_btnMaintanence  setBackgroundColor:[UIColor colorWithRed:68.0/255.0 green:177.0/255.0 blue:124.0/255.0 alpha:1.0]];
//    
//    [_btnRepair setBackgroundColor:[UIColor whiteColor]];
//    _addCall.taskType=@"MAINTENANCE";
    
    }

-(IBAction)btnActiveTapped:(id)sender {
    _btnActive.selected=YES;
    _btnInActive.selected=NO;
    [_btnActive setBackgroundColor:[UIColor colorWithRed:68.0/255.0 green:177.0/255.0 blue:124.0/255.0 alpha:1.0]];
    [_btnActive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnInActive setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnInActive setBackgroundColor:[UIColor whiteColor]];
}

-(IBAction)btnInActiveTapped:(id)sender {
    _btnInActive.selected=YES;
    _btnActive.selected=NO;
    [_btnInActive  setBackgroundColor:[UIColor colorWithRed:68.0/255.0 green:177.0/255.0 blue:124.0/255.0 alpha:1.0]];
    [_btnInActive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnActive setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnActive setBackgroundColor:[UIColor whiteColor]];
}

-(IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnNextTapped:(id)sender {
    if ([_btnVehical.titleLabel.text isEqualToString:@"Vehicle No."]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgSelectVehicleNo image:kErrorImage];
    }else if ([_btnTask1.titleLabel.text isEqualToString:@"Task1"] && [_btnTask2.titleLabel.text isEqualToString:@"Task2"] && [_btnTask3.titleLabel.text isEqualToString:@"Task3"]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgSelectTask image:kErrorImage];
    }else{
//        NSString *type;
//        if (_btnRepair.selected) {
//            type = @"REPAIR";
//        }else{
//            type = @"MAINTENANCE";
//        }
        
        NSString *status;
        if (_btnActive.selected) {
            status = @"Active";
        }else{
            status = @"Inactive";
        }
        
        NextViewController *nextViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"NextViewController"];
        nextViewController.strDD = _lblDD.text;
        nextViewController.strMM = _lblMM.text;
        nextViewController.strYY = _lblYY.text;
        nextViewController.strVehicleNo = _btnVehical.titleLabel.text;
        nextViewController.strObjectID = [NSString stringWithFormat:@"%@",[Helper getFromNSUserDefaults:@"VehicleID"]];
        nextViewController.strType =  @"REPAIR";
        nextViewController.strTask1 = [NSString stringWithFormat:@"%@",[Helper getFromNSUserDefaults:@"RepairID1"]];
        nextViewController.strTask2 = [NSString stringWithFormat:@"%@",[Helper getFromNSUserDefaults:@"RepairID2"]];
        nextViewController.strTask3 = [NSString stringWithFormat:@"%@",[Helper getFromNSUserDefaults:@"RepairID3"]];
        nextViewController.strCompletedDD = _lblDDCompleted.text;
        nextViewController.strCompletedMM = _lblMMCompleted.text;
        nextViewController.strCompletedYY = _lblYYCompleted.text;
        nextViewController.strStatus = status;
        nextViewController.strTitle = _strTitle;
        nextViewController.timedate = _timedate;
        nextViewController.timecompletedDate = _timecompletedDate;
//        if ([UtilityManager isConnectedToNetwork] == NO || [UtilityManager isDataSourceAvailable] == NO) {
            nextViewController.tableData = _tableData;
//        }else{
//            nextViewController.callList = _callList;
//        }
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

-(IBAction)btnTask1Tapped:(id)sender {
    [self showController:@"Task1"];
}

-(IBAction)btnTask2Tapped:(id)sender {
    [self showController:@"Task2"];
}

-(IBAction)btnTask3Tapped:(id)sender {
    [self showController:@"Task3"];
}

-(IBAction)btnVehicleNoTapped:(id)sender {
    [self showController:@"Vehicle No."];
}

- (IBAction)btnCalendarTapped:(id)sender{
    [self showDatePickerView];
    _btnCalendar.selected = YES;
    _btnCalendar1.selected = NO;
}

- (IBAction)btnCalendar1Tapped:(id)sender{
    [self showDatePickerView];
    _btnCalendar.selected = NO;
    _btnCalendar1.selected = YES;
}

- (IBAction)btnRightTapped:(id)sender{
    _pickerView.hidden = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];

    if (_datePicker.datePickerMode == UIDatePickerModeDate) {
        [dateFormatter setDateFormat:kDateFormat];
    }else if (_datePicker.datePickerMode == UIDatePickerModeDateAndTime){
        [dateFormatter setDateFormat:kDateTimeFormat];
    }
    
    NSString *value = [dateFormatter stringFromDate:_datePicker.date];
    NSArray *arrval = [value componentsSeparatedByString:@" "];
    NSArray *arrValue = [arrval[0] componentsSeparatedByString:@"-"];
    
    if (_btnCalendar.selected) {
        _lblYY.text = arrValue[0];
        _lblMM.text = [arrValue[1]uppercaseString];
        _lblDD.text = arrValue[2];
        _timedate = arrval[1];
        _addCall.date=[NSString stringWithFormat:@"%@-%@-%@",_lblYY.text,_lblMM.text,_lblDD.text];
    }else if (_btnCalendar1.selected){
        _lblYYCompleted.text = arrValue[0];
        _lblMMCompleted.text = [arrValue[1]uppercaseString];
        _lblDDCompleted.text = arrValue[2];
        _timecompletedDate = arrval[1];
        _addCall.dateCompleted=[NSString stringWithFormat:@"%@-%@-%@",_lblYYCompleted.text,_lblMMCompleted.text,_lblDDCompleted.text];
    }
}

- (IBAction)btnCloseTapped:(id)sender{
    _pickerView.hidden = YES;
}

- (void)showDatePickerView{
    _pickerView.hidden = NO;
    _datePicker.hidden = NO;
    _lblPicker.text = @"SELECT DATE";
    [self.view bringSubviewToFront:_datePicker];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:kDateFormat];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [_datePicker setDate:[NSDate date]];
}

- (void)showController:(NSString *)strName{
    SearchViewController *search=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    search.strCategory = strName;
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - change Title of buttons

-(void)setVehicleNo:(Vehicle*)vehicleNo {
    [_btnVehical setTitle:vehicleNo.strVehicleNo forState:UIControlStateNormal];
    _vehicle = vehicleNo;
}

-(void)setTask1:(Task*)task1 {
    [_btnTask1 setTitle:task1.strRepair forState:UIControlStateNormal];
}

-(void)setTask2:(Task*)task2 {
    [_btnTask2 setTitle:task2.strRepair forState:UIControlStateNormal];
}

-(void)setTask3:(Task*)task3 {
    [_btnTask3 setTitle:task3.strRepair forState:UIControlStateNormal];
}

@end
