//
//  CallListingViewController.m
//  ATI
//
//  Created by E2M164 on 15/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import "CallListingViewController.h"
#import "CallListCell.h"
#import "AddCallViewController.h"
#import "SearchViewController.h"
#import "SQLiteManager.h"
#import "TKAlertCenter.h"
#import "WebClient.h"
#import "CallList.h"
#import "Common.h"
#import "Helper.h"
#import "UtilityManager.h"
#import "TableData.h"
#import "Reachability.h"
#import "INTULocationManager.h"
#import "SVGeocoder.h"
#import "Loader.h"
#import "SIAlertView.h"
#import "AppDelegate.h"

#define kTableName      @"tblCommonData"

@interface CallListingViewController ()
{
    AppDelegate *app;
}

@property (strong, nonatomic) IBOutlet UITableView *tblCallList;
@property (strong, nonatomic) NSMutableArray *arrTableData;
@property (strong, nonatomic) NSMutableArray *arrData;
@property (strong, nonatomic) NSMutableArray *arrFilteredData;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (assign, nonatomic) BOOL isTextfieldLoded;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRecordFound;

@property (assign, nonatomic) INTULocationRequestID locationRequestID;

@end

@implementation CallListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [self getTableData];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)commonInit {
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([UtilityManager isConnectedToNetwork] == NO || [UtilityManager isDataSourceAvailable] == NO) {
        app.firstTime = NO;
    }else{
        app.firstTime = YES;
    }
    _arrTableData = [[NSMutableArray alloc]init];
    _arrData = [[NSMutableArray alloc]init];
    _arrFilteredData = [[NSMutableArray alloc]init];
    _tblCallList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tblCallList.tableFooterView.tintColor = [UIColor clearColor];
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableOnWWAN = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [reach startNotifier];
    [self fetchCurrentLocation];
    if (app.firstTime) {
        [self getCallList];
    }else{
        
    }
}

#pragma mark - Get Call List

- (void)getTableData{
    [_arrData removeAllObjects];
    [_arrTableData removeAllObjects];
    NSArray *data  = [[SQLiteManager singleton]find:@"*" from:kTableName where:[NSString stringWithFormat:@"empid=%ld",(long)[User sharedUser].intEmpID]];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TableData *tableData = [TableData dataWithDict:obj];
        [_arrTableData addObject:tableData];
    }];
    _lblNoRecordFound.hidden = _arrTableData.count!=0;
    [_arrData addObjectsFromArray:_arrTableData];
    TableData *tableData2 = [_arrData lastObject];
    [User sharedUser].intLastServiceId = tableData2.intServicecall_id;
    NSLog(@"%ld",(long)[User sharedUser].intLastServiceId);
    
    [_tblCallList reloadData];
}

- (void)getCallList{
    [_arrData removeAllObjects];
    [_arrTableData removeAllObjects];
    [[WebClient sharedClient]getCallList:@{@"empid":[NSNumber numberWithInteger:[User sharedUser].intEmpID]} success:^(NSDictionary *dictionary) {
        NSLog(@"Dictionary : %@",dictionary);
        if(dictionary){
            if([dictionary[@"success"] boolValue]){
                [_arrData removeAllObjects];
                NSString *deleteQuery = @"delete from tblCommonData";
                [[SQLiteManager singleton] executeSql:deleteQuery];

                NSArray *listResult = dictionary[@"services"];
                if(listResult.count!=0){
                    [listResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        CallList *callList = [CallList dataWithDict:obj];
                        
                        if ([callList.strTask1Name isEqualToString:@""]) {
                            callList.strTask1Name = @"Task1";
                        }
                        if ([callList.strTask2Name isEqualToString:@""]) {
                            callList.strTask2Name = @"Task2";
                        }
                        if ([callList.strTask3Name isEqualToString:@""]) {
                            callList.strTask3Name = @"Task3";
                        }
                        if ([callList.strPart1Name isEqualToString:@""]) {
                            callList.strPart1Name = @"Part1";
                        }
                        if ([callList.strPart2Name isEqualToString:@""]) {
                            callList.strPart2Name = @"Part2";
                        }
                        if ([callList.strPart3Name isEqualToString:@""]) {
                            callList.strPart3Name = @"Part3";
                        }
                        if ([callList.strPart1Qty isEqualToString:@"0"]) {
                            callList.strPart1Qty = @"";
                        }
                        if ([callList.strPart2Qty isEqualToString:@"0"]) {
                            callList.strPart2Qty = @"";
                        }
                        if ([callList.strPart3Qty isEqualToString:@"0"]) {
                            callList.strPart3Qty = @"";
                        }

                        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO tblCommonData (date,datecompleted,objectid,empid,task_type,task1,task2,task3,part1bcode,part1id,qtypart1,part1desc,part2bcode,part2id,qtypart2,part2desc,part3bcode,part3id,qtypart3,part3desc,status,vehicleno,part1name,part2name,part3name,task1name,task2name,task3name,duration1,duration2,duration3,isstatus,dateexported,latitudes,longitudes,isupdate,servicecall_id) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", callList.strDate,callList.strDateCompleted,[NSNumber numberWithInteger:callList.intObjectID],[NSNumber numberWithInteger:callList.intEmpID],callList.strType,[NSNumber numberWithInteger:callList.intRepairID1],[NSNumber numberWithInteger:callList.intRepairID2],[NSNumber numberWithInteger:callList.intRepairID3],callList.strPart1Bcode,[NSNumber numberWithInteger:callList.intPartID1],callList.strPart1Qty,callList.strPart1Desc,callList.strPart2Bcode,[NSNumber numberWithInteger:callList.intPartID2],callList.strPart2Qty,callList.strPart2Desc,callList.strPart3Bcode,[NSNumber numberWithInteger:callList.intPartID3],callList.strPart3Qty,callList.strPart3Desc,callList.strStatus,callList.strVehicleNo,callList.strPart1Name,callList.strPart2Name,callList.strPart3Name,callList.strTask1Name,callList.strTask2Name,callList.strTask3Name,callList.strDuration1,callList.strDuration2,callList.strDuration3,@"1",@"",[User sharedUser].strLatitude,[User sharedUser].strLongitude,@"0",[NSNumber numberWithInteger:callList.intServiceID]];
                        
                        [[SQLiteManager singleton] executeSql:insertSQL];

                        [_arrData addObject:callList];
                    }];
                }
                _lblNoRecordFound.hidden = _arrData.count!=0;
                [_arrData addObjectsFromArray: _arrTableData];
                [self getTableData];
                [_tblCallList reloadData];
            }else {
                //[[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
                _lblNoRecordFound.hidden = _arrData.count!=0;
            }
        }
        _lblNoRecordFound.hidden = _arrData.count!=0;
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:error.localizedDescription image:kErrorImage];
    }];
}

- (void)getSyncData{
    [_arrTableData removeAllObjects];
    [_arrData removeAllObjects];
    NSArray *data = [[SQLiteManager singleton]find:@"*" from:kTableName where:[NSString stringWithFormat:@"empid=%ld",(long)[User sharedUser].intEmpID]];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TableData *tableData = [TableData dataWithDict:obj];
        [_arrTableData addObject:tableData];
    }];
    [_arrData addObjectsFromArray:_arrTableData];

    NSMutableArray *arrSync = [[NSMutableArray alloc]init];
    for (int i=0; i<data.count; i++) {
        if ([[[data objectAtIndex:i]valueForKey:@"isstatus"]isEqualToString:@"0"]) {
            [arrSync addObject:data];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[[data objectAtIndex:i]valueForKey:@"date"],@"date",[[data objectAtIndex:i]valueForKey:@"objectid"],@"objectid",[[data objectAtIndex:i]valueForKey:@"empid"],@"empid",[[data objectAtIndex:i]valueForKey:@"task_type"],@"task_type",[[data objectAtIndex:i]valueForKey:@"task1"],@"task1",[[data objectAtIndex:i]valueForKey:@"task2"],@"task2",[[data objectAtIndex:i]valueForKey:@"task3"],@"task3",[[data objectAtIndex:i]valueForKey:@"part1bcode"],@"part1bcode",[[data objectAtIndex:i]valueForKey:@"part1id"],@"part1id",[[data objectAtIndex:i]valueForKey:@"qtypart1"],@"qtypart1",[[data objectAtIndex:i]valueForKey:@"duration1"],@"duration1",[[data objectAtIndex:i]valueForKey:@"part1desc"],@"part1labesc",[[data objectAtIndex:i]valueForKey:@"part2bcode"],@"part2bcode",[[data objectAtIndex:i]valueForKey:@"part2id"],@"part2id",[[data objectAtIndex:i]valueForKey:@"qtypart2"],@"qtypart2",[[data objectAtIndex:i]valueForKey:@"duration2"],@"duration2",[[data objectAtIndex:i]valueForKey:@"part2desc"],@"part2labesc",[[data objectAtIndex:i]valueForKey:@"part3bcode"],@"part3bcode",[[data objectAtIndex:i]valueForKey:@"part3id"],@"part3id",[[data objectAtIndex:i]valueForKey:@"qtypart3"],@"qtypart3",[[data objectAtIndex:i]valueForKey:@"duration3"],@"duration3",[[data objectAtIndex:i]valueForKey:@"part3desc"],@"part3labesc",[[data objectAtIndex:i]valueForKey:@"status"],@"status",[[data objectAtIndex:i]valueForKey:@"datecompleted"],@"datecompleted",@"",@"dateexported",[User sharedUser].strLongitude,@"longitudes",[User sharedUser].strLatitude,@"latitudes",nil];
            
            NSString *sid = [[data objectAtIndex:i]valueForKey:@"servicecall_id"];
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tblCommonData set isstatus = '1'  WHERE servicecall_id = %@",sid];
            [[SQLiteManager singleton] executeSql:updateSQL];
            [self getTableData];
            [_tblCallList reloadData];

            [[WebClient sharedClient] addCall:dict success:^(NSDictionary *dictionary) {
                NSLog(@"dictionary %@",dictionary);
                if (dictionary!=nil) {
                    if([dictionary[@"success"] boolValue] == YES){
                        //[[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
                        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tblCommonData set isstatus = '1'  WHERE servicecall_id = %@",sid];
                        [[SQLiteManager singleton] executeSql:updateSQL];
                        [self getTableData];
                        [_tblCallList reloadData];
                    }else {
                        [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
                    }
                    [self getTableData];
                    [_tblCallList reloadData];
                }
            } failure:^(NSError *error) {
                // [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
            }];
        }
        
        if ([[[data objectAtIndex:i]valueForKey:@"isupdate"]isEqualToString:@"1"]) {
            [arrSync addObject:data];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[[data objectAtIndex:i]valueForKey:@"servicecall_id"],@"id",[[data objectAtIndex:i]valueForKey:@"date"],@"date",[[data objectAtIndex:i]valueForKey:@"objectid"],@"objectid",[[data objectAtIndex:i]valueForKey:@"empid"],@"empid",[[data objectAtIndex:i]valueForKey:@"task_type"],@"task_type",[[data objectAtIndex:i]valueForKey:@"task1"],@"task1",[[data objectAtIndex:i]valueForKey:@"task2"],@"task2",[[data objectAtIndex:i]valueForKey:@"task3"],@"task3",[[data objectAtIndex:i]valueForKey:@"part1bcode"],@"part1bcode",[[data objectAtIndex:i]valueForKey:@"part1id"],@"part1id",[[data objectAtIndex:i]valueForKey:@"qtypart1"],@"qtypart1",[[data objectAtIndex:i]valueForKey:@"duration1"],@"duration1",[[data objectAtIndex:i]valueForKey:@"part1desc"],@"part1labesc",[[data objectAtIndex:i]valueForKey:@"part2bcode"],@"part2bcode",[[data objectAtIndex:i]valueForKey:@"part2id"],@"part2id",[[data objectAtIndex:i]valueForKey:@"qtypart2"],@"qtypart2",[[data objectAtIndex:i]valueForKey:@"duration2"],@"duration2",[[data objectAtIndex:i]valueForKey:@"part2desc"],@"part2labesc",[[data objectAtIndex:i]valueForKey:@"part3bcode"],@"part3bcode",[[data objectAtIndex:i]valueForKey:@"part3id"],@"part3id",[[data objectAtIndex:i]valueForKey:@"qtypart3"],@"qtypart3",[[data objectAtIndex:i]valueForKey:@"duration3"],@"duration3",[[data objectAtIndex:i]valueForKey:@"part3desc"],@"part3labesc",[[data objectAtIndex:i]valueForKey:@"status"],@"status",[[data objectAtIndex:i]valueForKey:@"datecompleted"],@"datecompleted",@"",@"dateexported",[User sharedUser].strLongitude,@"longitudes",[User sharedUser].strLatitude,@"latitudes",nil];
            
            NSString *sid = [[data objectAtIndex:i]valueForKey:@"servicecall_id"];
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tblCommonData set isupdate = '0'  WHERE servicecall_id = %@",sid];
            [[SQLiteManager singleton] executeSql:updateSQL];
            [self getTableData];
            [_tblCallList reloadData];
            
            [[WebClient sharedClient] editCall:dict success:^(NSDictionary *dictionary) {
                NSLog(@"dictionary %@",dictionary);
                if (dictionary!=nil) {
                    if([dictionary[@"success"] boolValue] == YES){
                        //[[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
                        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tblCommonData set isupdate = '0'  WHERE servicecall_id = %@",sid];
                        [[SQLiteManager singleton] executeSql:updateSQL];
                        [self getTableData];
                        [_tblCallList reloadData];
                    }else {
                        [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
                    }
                    [self getTableData];
                    [_tblCallList reloadData];
                }
            } failure:^(NSError *error) {
                // [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
            }];
        }
    }
}

#pragma mark - Location

- (void)fetchCurrentLocation{
    [[Loader defaultLoader] displayLoadingView:msgLoading];
    __weak __typeof(self) weakSelf = self;
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    self.locationRequestID =  [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:50 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        __typeof(weakSelf) strongSelf = weakSelf;
        if (status == INTULocationStatusSuccess) {
            [SVGeocoder reverseGeocode:currentLocation.coordinate completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                [User sharedUser].strLatitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
                [User sharedUser].strLongitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
                [[Loader defaultLoader] hideLoadingView];
            }];
        } else if (status == INTULocationStatusTimedOut) {
            [[Loader defaultLoader] hideLoadingView];
            [self locationError:[NSString stringWithFormat:msgTimeOut, currentLocation]];
        } else {
            if (status == INTULocationStatusServicesNotDetermined) {
                [self locationError:msgLocationNotDetermine];
            } else if (status == INTULocationStatusServicesDenied) {
                [self locationError:msgUserDeniedPermission];
            } else if (status == INTULocationStatusServicesRestricted) {
                [self locationError:msgUserRestrictedLocation];
            } else if (status == INTULocationStatusServicesDisabled) {
                [self locationError:msgLocationTurnOff];
            } else {
                [self locationError:msgLocationError];
            }
            [[Loader defaultLoader] hideLoadingView];
        }
        strongSelf.locationRequestID = NSNotFound;
    }];
}

- (void)locationError:(NSString *)msg{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Oops" andMessage:msg];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [User sharedUser].strLatitude = @"0.0";
    [User sharedUser].strLongitude = @"0.0";
    
    [alertView show];
}

#pragma mark - Tableview Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isTextfieldLoded == YES)
        return _arrFilteredData.count;
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CallListCell";
    CallListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CallListCell" owner:self options:nil] objectAtIndex:0];
    
//    if ([UtilityManager isConnectedToNetwork] == NO || [UtilityManager isDataSourceAvailable] == NO) {
        TableData *tableData = nil;
        if (_isTextfieldLoded == YES){
            tableData = _arrFilteredData[indexPath.row];
        }else{
            tableData = _arrData[indexPath.row];
        }
        cell.tableData = tableData;
//    }else{
//        CallList *callList = nil;
//        if (_isTextfieldLoded == YES){
//            callList = _arrFilteredData[indexPath.row];
//        }else{
//            callList = _arrData[indexPath.row];
//        }
//        cell.callList = callList;
//    
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([UtilityManager isConnectedToNetwork] == NO || [UtilityManager isDataSourceAvailable] == NO) {
        TableData *tableData = nil;
        if (_isTextfieldLoded == YES){
            tableData = _arrFilteredData[indexPath.row];
        }else{
            tableData = _arrData[indexPath.row];
        }
        AddCallViewController *add=[self.storyboard instantiateViewControllerWithIdentifier:@"AddCallViewController"];
        add.tableData = tableData;
        add.strTitle = @"Update Call";
        [self.navigationController pushViewController:add animated:YES];
//    }else{
//        CallList *callList = nil;
//        if (_isTextfieldLoded == YES){
//            callList = _arrFilteredData[indexPath.row];
//        }else{
//            callList = _arrData[indexPath.row];
//        }
//        AddCallViewController *add=[self.storyboard instantiateViewControllerWithIdentifier:@"AddCallViewController"];
//        add.callList = callList;
//        add.strTitle = @"Update Call";
//        [self.navigationController pushViewController:add animated:YES];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - buttons events

-(IBAction)btnAddCallTapped:(id)sendern {
    AddCallViewController *add=[self.storyboard instantiateViewControllerWithIdentifier:@"AddCallViewController"];
    [Helper addToNSUserDefaults:@"Vehicle No." forKey:@"VehicleNo"];
    [Helper addToNSUserDefaults:@"Task1" forKey:@"Task1"];
    [Helper addToNSUserDefaults:@"Task2" forKey:@"Task2"];
    [Helper addToNSUserDefaults:@"Task3" forKey:@"Task3"];
    [Helper addToNSUserDefaults:@"Part1" forKey:@"Part1"];
    [Helper addToNSUserDefaults:@"Part2" forKey:@"Part2"];
    [Helper addToNSUserDefaults:@"Part3" forKey:@"Part3"];
    [Helper addToNSUserDefaults:@"" forKey:@"BarCode"];
    [Helper addToNSUserDefaults:@"" forKey:@"BarCode1"];
    [Helper addToNSUserDefaults:@"" forKey:@"BarCode2"];
    [Helper addToNSUserDefaults:@"" forKey:@"BarCode3"];
    [Helper addToNSUserDefaults:@"0" forKey:@"RepairID1"];
    [Helper addToNSUserDefaults:@"0" forKey:@"RepairID2"];
    [Helper addToNSUserDefaults:@"0" forKey:@"RepairID3"];
    [Helper addToNSUserDefaults:@"0" forKey:@"PartNo1"];
    [Helper addToNSUserDefaults:@"0" forKey:@"PartNo2"];
    [Helper addToNSUserDefaults:@"0" forKey:@"PartNo3"];

    add.strTitle = @"Add Call";
    [self.navigationController pushViewController:add animated:YES];
}

#pragma mark - TextField Delegate Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
 
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"strVehicleNo contains[cd] %@", textField.text];
    _arrFilteredData = [NSMutableArray arrayWithArray:[_arrData filteredArrayUsingPredicate:resultPredicate]];
    
    if (self.txtSearch.text.length!=0) {
        self.isTextfieldLoded=YES;
    }
    else{
        self.isTextfieldLoded=NO;
    }
    [_tblCallList reloadData];
    return NO;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    _txtSearch.text = @"";
    [_txtSearch resignFirstResponder];
    self.isTextfieldLoded=NO;
    [_tblCallList reloadData];
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_txtSearch becomeFirstResponder];
}

#pragma mark - Rechability

-(BOOL)reachabilityChanged:(NSNotification*)note{
    BOOL status =YES;
    NSLog(@"reachabilityChanged");
    Reachability * reach = [note object];
    if([reach isReachable]){
        status = YES;
        NSLog(@"NetWork is Available");
        [self getSyncData];
    }
    else{
        status = NO;
    }
    return status;
}

@end
