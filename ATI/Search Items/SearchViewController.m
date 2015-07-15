//
//  SearchViewController.m
//  ATI
//
//  Created by E2M164 on 16/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import "Task.h"
#import "Vehicle.h"
#import "part.h"
#import "AddCallViewController.h"
#import "TKAlertCenter.h"
#import "Common.h"
#import "WebClient.h"
#import "Helper.h"
#import "SQLiteManager.h"
#import "UtilityManager.h"
#import "AppDelegate.h"

#define kVehicleTableName       @"tblVehicle"
#define kTaskTableName          @"tblTask"

@interface SearchViewController ()
{
    AppDelegate *app;
}

@property (strong, nonatomic) IBOutlet UITableView *tbl;
@property (strong, nonatomic) IBOutlet UILabel *lblCategory;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;

@property (strong, nonatomic) NSMutableArray *arrVehicle;
@property (strong, nonatomic) NSMutableArray *arrTask;
@property (strong, nonatomic) NSMutableArray *arrfiltered;

@property (assign, nonatomic) BOOL isTextfieldLoded;
@property (strong, nonatomic) AddCallViewController *addcallViewController;

@end

@implementation SearchViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init Method

-(void)commonInit {
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    _lblCategory.text=_strCategory;
    _arrVehicle = [[NSMutableArray alloc]init];
    _arrTask = [[NSMutableArray alloc]init];
    _arrfiltered = [[NSMutableArray alloc]init];
    _tbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tbl.tableFooterView.tintColor = [UIColor clearColor];
    
    if ([UtilityManager isConnectedToNetwork] == NO || [UtilityManager isDataSourceAvailable] == NO) {
        if ([_strCategory isEqualToString:@"Vehicle No."]){
            [self getVehicleTableData];
        }else{
            [self getTaskTableData];
        }
    } else {
        if ([_strCategory isEqualToString:@"Vehicle No."]){
            [self getVehicleList];
        }else{
            [self getTaskList];
        }
    }
}

#pragma mark - Get Vehicle List from Web Service

- (void)getVehicleList{
    [_arrVehicle removeAllObjects];
    [[WebClient sharedClient] getVehiclesList:nil success:^(NSDictionary *dictionary) {
        NSLog(@"dictionary %@",dictionary);
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                NSArray *data = dictionary[@"objects"];
                if(data.count!=0){
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        Vehicle *vehicle = [Vehicle dataWithDict:obj];
                        [_arrVehicle addObject:vehicle];
                    }];
                }
                [_tbl reloadData];
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        }
        [_tbl reloadData];
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
}

#pragma mark - Get Task List from Web Service

- (void)getTaskList{
    [_arrTask removeAllObjects];
    [[WebClient sharedClient] getTasksList:nil success:^(NSDictionary *dictionary) {
        NSLog(@"dictionary %@",dictionary);
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                NSArray *data1 = dictionary[@"tasks"];
                if(data1.count!=0){
                    [data1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        Task *task = [Task dataWithDict:obj];
                        [_arrTask addObject:task];
                    }];
                }
                [_tbl reloadData];
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        }
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
}

#pragma mark - Get Vehicle List from Table

- (void)getVehicleTableData{
    [_arrVehicle removeAllObjects];
    NSArray *data  = [[SQLiteManager singleton]executeSql:@"SELECT * from tblVehicle order by vehicle_no asc"];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Vehicle *vehicle = [Vehicle dataWithDict:obj];
        [_arrVehicle addObject:vehicle];
    }];
    [_tbl reloadData];
}

#pragma mark - Get Task List from Table

- (void)getTaskTableData{
    [_arrTask removeAllObjects];
    NSArray *data  = [[SQLiteManager singleton]executeSql:@"SELECT * from tblTask order by repair asc"];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Task *task = [Task dataWithDict:obj];
        [_arrTask addObject:task];
    }];
    [_tbl reloadData];
}

#pragma mark - Tableview Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_strCategory isEqualToString:@"Vehicle No."]) {
        if (_isTextfieldLoded == YES){
            return _arrfiltered.count;
        }else{
            return _arrVehicle.count;
        }
    }else{
        if (_isTextfieldLoded == YES){
            return _arrfiltered.count;
        }else{
            return _arrTask.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SearchCell";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil] objectAtIndex:0];
  
    if ([_strCategory isEqualToString:@"Vehicle No."]) {
        Vehicle *vehicle = nil;
        if (_isTextfieldLoded == YES){
            vehicle = _arrfiltered[indexPath.row];
        }else {
            vehicle = _arrVehicle[indexPath.row];
        }
        cell.vehicle = vehicle;
    }else{
        Task *task = nil;
        if (_isTextfieldLoded == YES){
            task  = _arrfiltered[indexPath.row];
        }else {
            task  = _arrTask[indexPath.row];
        }
        cell.task = task;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Vehicle *vehicle = nil;
    Task *task = nil;
    
    if ([_strCategory isEqualToString:@"Vehicle No."]) {
        if (_isTextfieldLoded == YES){
            vehicle = _arrfiltered[indexPath.row];
            NSString *vehicleNo = [NSString stringWithFormat:@"%@",vehicle.strVehicleNo];
            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:vehicle.intObjectID] forKey:@"VehicleID"];
            [Helper addToNSUserDefaults:vehicleNo forKey:@"VehicleNo"];
        }else {
            vehicle = _arrVehicle[indexPath.row];
            NSString *vehicleNo = [NSString stringWithFormat:@"%@",vehicle.strVehicleNo];
            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:vehicle.intObjectID] forKey:@"VehicleID"];
            [Helper addToNSUserDefaults:vehicleNo forKey:@"VehicleNo"];
        }
    }else if ([_strCategory isEqualToString:@"Task1"]) {
        if (_isTextfieldLoded == YES){
            task = _arrfiltered[indexPath.row];
            NSString *vehicleNo = [NSString stringWithFormat:@"%@",task.strRepair];
            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:task.intRepairID] forKey:@"RepairID1"];
            [Helper addToNSUserDefaults:vehicleNo forKey:@"Task1"];
        }else {
            task = _arrTask[indexPath.row];
            NSString *vehicleNo = [NSString stringWithFormat:@"%@",task.strRepair];
            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:task.intRepairID] forKey:@"RepairID1"];
            [Helper addToNSUserDefaults:vehicleNo forKey:@"Task1"];
        }
    }else if ([_strCategory isEqualToString:@"Task2"]) {
        if (_isTextfieldLoded == YES){
            task = _arrfiltered[indexPath.row];
            NSString *vehicleNo = [NSString stringWithFormat:@"%@",task.strRepair];
            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:task.intRepairID] forKey:@"RepairID2"];
            [Helper addToNSUserDefaults:vehicleNo forKey:@"Task2"];
        }else {
            task = _arrTask[indexPath.row];
            NSString *vehicleNo = [NSString stringWithFormat:@"%@",task.strRepair];
            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:task.intRepairID] forKey:@"RepairID2"];
            [Helper addToNSUserDefaults:vehicleNo forKey:@"Task2"];
        }
    }else if ([_strCategory isEqualToString:@"Task3"]) {
        if (_isTextfieldLoded == YES){
            task = _arrfiltered[indexPath.row];
            NSString *vehicleNo = [NSString stringWithFormat:@"%@",task.strRepair];
            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:task.intRepairID] forKey:@"RepairID3"];
            [Helper addToNSUserDefaults:vehicleNo forKey:@"Task3"];
        }else {
            task = _arrTask[indexPath.row];
            NSString *vehicleNo = [NSString stringWithFormat:@"%@",task.strRepair];
            [Helper addToNSUserDefaults:[NSNumber numberWithInteger:task.intRepairID] forKey:@"RepairID3"];
            [Helper addToNSUserDefaults:vehicleNo forKey:@"Task3"];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - buttons events

-(IBAction)btnbackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextField Delegate Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([_strCategory isEqualToString:@"Vehicle No."]) {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"strVehicleNo contains[cd] %@", textField.text];
        _arrfiltered = [NSMutableArray arrayWithArray:[_arrVehicle filteredArrayUsingPredicate:resultPredicate]];
    }else if([_strCategory isEqualToString:@"Task1"] || [_strCategory isEqualToString:@"Task2"] || [_strCategory isEqualToString:@"Task3"]){
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"strRepair contains[cd] %@", textField.text];
        _arrfiltered = [NSMutableArray arrayWithArray:[_arrTask filteredArrayUsingPredicate:resultPredicate]];
    }
    if (self.txtSearch.text.length!=0) {
        self.isTextfieldLoded=YES;
    }
    else{
        self.isTextfieldLoded=NO;
    }
    [_tbl reloadData];
    return NO;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    _txtSearch.text = @"";
    [_txtSearch resignFirstResponder];
    self.isTextfieldLoded=NO;
    [_tbl reloadData];
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_txtSearch becomeFirstResponder];
}

@end
