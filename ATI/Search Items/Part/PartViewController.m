//
//  PartViewController.m
//  ATI
//
//  Created by Manish on 27/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import "PartViewController.h"
#import "PartCell.h"
#import "part.h"
#import "WebClient.h"
#import "Loader.h"
#import "Messages.h"
#import "TKAlertCenter.h"
#import "Common.h"
#import "MTBBasicExampleViewController.h"
#import "Helper.h"
#import "SIAlertView.h"
#import "SQLiteManager.h"
#import "UtilityManager.h"

#define kPartTableName      @"tblPart"

@interface PartViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) NSMutableArray *arrParts;
@property (strong, nonatomic) NSMutableArray *arrFilteredParts;
@property (assign, nonatomic) BOOL isTextfieldLoded;
@property (nonatomic) NSInteger openSectionIndex;

@property (strong, nonatomic) part *parts;

@end

@implementation PartViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)commonInit{
    _arrParts = [[NSMutableArray alloc]init];
    _arrFilteredParts = [[NSMutableArray alloc]init];
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tblList.tableFooterView.tintColor = [UIColor clearColor];
    if ([UtilityManager isConnectedToNetwork] == NO || [UtilityManager isDataSourceAvailable] == NO) {
        [self getPartTableData];
    } else {
        [self getPartsList];
    }
}

#pragma mark - Get Part List from Web Service

- (void)getPartsList{
    [_arrParts removeAllObjects];
    [[WebClient sharedClient] getPartsList:nil success:^(NSDictionary *dictionary) {
        NSLog(@"dictionary %@",dictionary);
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                NSArray *data = dictionary[@"parts"];
                if(data.count!=0){
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        part *parts = [part dataWithDict:obj];
                        [_arrParts addObject:parts];
                        _parts = parts;
                    }];
                }
                _arrFilteredParts = _arrParts;
                [_tblList reloadData];
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        }
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
}

#pragma mark - Get Part List from Table

- (void)getPartTableData{
    NSArray *data  = [[SQLiteManager singleton]executeSql:@"SELECT * from tblPart order by Part_no asc"];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        part *parts = [part dataWithDict:obj];
        [_arrParts addObject:parts];
    }];
    _arrFilteredParts = _arrParts;
    [_tblList reloadData];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isTextfieldLoded == YES){
        return _arrFilteredParts.count;
    }else {
        return _arrParts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PartCell";
    PartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PartCell" owner:self options:nil] objectAtIndex:0];

    part *parts = nil;
    if (_isTextfieldLoded == YES){
        parts  = _arrFilteredParts[indexPath.row];
    }else {
        parts  = _arrParts[indexPath.row];
    }
    cell.parts = parts;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    part *part = nil;
    if (_isTextfieldLoded) {
        part = _arrFilteredParts[indexPath.row];
    }else {
        part = _arrParts[indexPath.row];
    }

    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"DESCRIPTION" andMessage:part.partDesc];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
    [alertView addButtonWithTitle:@"DONE"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              if ([_strCategory isEqualToString:@"Part1"]) {
                                  [Helper addToNSUserDefaults:part.partNo forKey:@"Part1"];
                                  part.partBarcode = [Helper getFromNSUserDefaults:@"BarCode"];
                                  [Helper addToNSUserDefaults:part.partBarcode forKey:@"BarCode1"];
                                  [Helper addToNSUserDefaults:part.partDesc forKey:@"PartDesc1"];
                                  [Helper addToNSUserDefaults:[NSNumber numberWithInteger:part.intPartID] forKey:@"PartNo1"];
                              }else if ([_strCategory isEqualToString:@"Part2"]){
                                  part.partBarcode = [Helper getFromNSUserDefaults:@"BarCode"];
                                  [Helper addToNSUserDefaults:part.partNo forKey:@"Part2"];
                                  [Helper addToNSUserDefaults:part.partBarcode forKey:@"BarCode2"];
                                  [Helper addToNSUserDefaults:part.partDesc forKey:@"PartDesc2"];
                                  [Helper addToNSUserDefaults:[NSNumber numberWithInteger:part.intPartID] forKey:@"PartNo2"];
                              }else{
                                  part.partBarcode = [Helper getFromNSUserDefaults:@"BarCode"];
                                  [Helper addToNSUserDefaults:part.partNo forKey:@"Part3"];
                                  [Helper addToNSUserDefaults:part.partBarcode forKey:@"BarCode3"];
                                  [Helper addToNSUserDefaults:part.partDesc forKey:@"PartDesc3"];
                                  [Helper addToNSUserDefaults:[NSNumber numberWithInteger:part.intPartID] forKey:@"PartNo3"];
                              }

                              [self.navigationController popViewControllerAnimated:YES];
                          }];
    [alertView addButtonWithTitle:@"CANCEL"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

#pragma mark - buttons events

-(IBAction)btnbackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextField Delegate Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"partNo contains[cd] %@", textField.text];
    _arrFilteredParts = [NSMutableArray arrayWithArray:[_arrParts filteredArrayUsingPredicate:resultPredicate]];
    
    if (self.txtSearch.text.length!=0) {
        self.isTextfieldLoded=YES;
    }
    else{
        self.isTextfieldLoded=NO;
    }
    [_tblList reloadData];
    return NO;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    _txtSearch.text = @"";
    [_txtSearch resignFirstResponder];
    self.isTextfieldLoded=NO;
    [_tblList reloadData];
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_txtSearch becomeFirstResponder];
}

#pragma mark - Button Tapped Event

- (IBAction)btnBarCodeTapped:(id)sender{
    MTBBasicExampleViewController *add=[self.storyboard instantiateViewControllerWithIdentifier:@"MTBBasicExampleViewController"];
    add.arrParts = _arrParts;
    add.strCategory = _strCategory;
    [self.navigationController pushViewController:add animated:YES];
}

@end
