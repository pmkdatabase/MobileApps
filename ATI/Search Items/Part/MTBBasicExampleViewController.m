//
//  MTBViewController.m
//  MTBBarcodeScannerExample
//
//  Created by Mike Buss on 2/8/14.
//
//

#import "MTBBasicExampleViewController.h"
#import "MTBBarcodeScanner.h"
#import "Helper.h"
#import "part.h"
#import "SIAlertView.h"
#import  "PartViewController.h"

@interface MTBBasicExampleViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIButton *toggleScanningButton;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MTBBarcodeScanner *scanner;
@property (strong, nonatomic) NSMutableArray *uniqueCodes;
@property (strong, nonatomic) IBOutlet UILabel *lblBarcode;
@property (strong, nonatomic) NSMutableArray *arr;

@end

@implementation MTBBasicExampleViewController

#pragma mark - Lifecycle

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [self toggleScanningTapped:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.scanner stopScanning];
    [super viewWillDisappear:animated];
}

#pragma mark - Scanner

- (MTBBarcodeScanner *)scanner {
    
    if (!_scanner) {
        _scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:_previewView];
    }
    return _scanner;
}

#pragma mark - Scanning

- (void)startScanning {
    self.uniqueCodes = [[NSMutableArray alloc] init];
    
    [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
        for (AVMetadataMachineReadableCodeObject *code in codes) {
            if (code.stringValue && [self.uniqueCodes indexOfObject:code.stringValue] == NSNotFound) {
                [self.uniqueCodes addObject:code.stringValue];
                
                NSLog(@"Found unique code: %@", code.stringValue);
                // Update the tableview
                _lblBarcode.text = code.stringValue;
                self.toggleScanningButton.hidden = YES;
                SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Barcode" andMessage:[NSString stringWithFormat:@"%@",_lblBarcode.text]];
                alertView.buttonsListStyle = SIAlertViewButtonTypeDefault;
                [alertView addButtonWithTitle:@"DONE"
                                         type:SIAlertViewButtonTypeDestructive
                                      handler:^(SIAlertView *alert) {
                                          [self btnDoneTapped:nil];
                                      }];
                [alertView addButtonWithTitle:@"CANCEL"
                                         type:SIAlertViewButtonTypeCancel
                                      handler:^(SIAlertView *alert) {
                                          _lblBarcode.text = @"Barcode String";
                                          [self toggleScanningTapped:_toggleScanningButton];
                                      }];
                alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                [alertView show];

                [self.tableView reloadData];
                [self scrollToLastTableViewCell];
            }
        }
    }];
    
    [self.toggleScanningButton setTitle:@"Stop Scanning" forState:UIControlStateNormal];
    self.toggleScanningButton.backgroundColor = [UIColor redColor];
}

- (void)stopScanning {
    [self.scanner stopScanning];
    
    [self.toggleScanningButton setTitle:@"Start Scanning" forState:UIControlStateNormal];
    self.toggleScanningButton.backgroundColor = self.view.tintColor;
}

#pragma mark - Actions

- (IBAction)toggleScanningTapped:(id)sender {
//    if ([self.scanner isScanning]) {
//        [self stopScanning];
//    } else {
        [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
            if (success) {
                [self startScanning];
            } else {
                [self displayPermissionMissingAlert];
            }
        }];
//    }
}

- (IBAction)switchCameraTapped:(id)sender {
    [self.scanner flipCamera];
}

- (IBAction)btnBackTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDoneTapped:(id)sender{
    BOOL match = NO;
    for (int i = 0; i<_arrParts.count; i++) {
        part *part = _arrParts[i];
        if ([_lblBarcode.text isEqualToString:part.partBarcode]) {
            match = YES;
            if ([_strCategory isEqualToString:@"Part1"]) {
                [Helper addToNSUserDefaults:part.partName forKey:@"Part1"];
                part.partBarcode = [Helper getFromNSUserDefaults:@"BarCode"];
                [Helper addToNSUserDefaults:part.partBarcode forKey:@"BarCode1"];
                [Helper addToNSUserDefaults:part.partDesc forKey:@"PartDesc1"];
                [Helper addToNSUserDefaults:[NSNumber numberWithInteger:part.intPartID] forKey:@"PartNo1"];
            }else if ([_strCategory isEqualToString:@"Part2"]){
                part.partBarcode = [Helper getFromNSUserDefaults:@"BarCode"];
                [Helper addToNSUserDefaults:part.partName forKey:@"Part2"];
                [Helper addToNSUserDefaults:part.partBarcode forKey:@"BarCode2"];
                [Helper addToNSUserDefaults:part.partDesc forKey:@"PartDesc2"];
                [Helper addToNSUserDefaults:[NSNumber numberWithInteger:part.intPartID] forKey:@"PartNo2"];
            }else{
                part.partBarcode = [Helper getFromNSUserDefaults:@"BarCode"];
                [Helper addToNSUserDefaults:part.partName forKey:@"Part3"];
                [Helper addToNSUserDefaults:part.partBarcode forKey:@"BarCode3"];
                [Helper addToNSUserDefaults:part.partDesc forKey:@"PartDesc3"];
                [Helper addToNSUserDefaults:[NSNumber numberWithInteger:part.intPartID] forKey:@"PartNo3"];
            }
            PartViewController *add=[self.storyboard instantiateViewControllerWithIdentifier:@"PartViewController"];
            [self.navigationController pushViewController:add animated:NO];
        }
    }
    if (!match) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Not Match" andMessage:[NSString stringWithFormat:@"%@ does not match with part barcode. Try other Barcode!",_lblBarcode.text]];
        alertView.buttonsListStyle = SIAlertViewButtonTypeDefault;
        [alertView addButtonWithTitle:@"OK"
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alert) {
                                  //[self.navigationController popViewControllerAnimated:YES];
                                  _lblBarcode.text = @"Barcode String";
                                  [self toggleScanningTapped:_toggleScanningButton];
                              }];
//        [alertView addButtonWithTitle:@"CANCEL"
//                                 type:SIAlertViewButtonTypeCancel
//                              handler:^(SIAlertView *alert) {
//
//                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
    }
}

- (void)backTapped {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"BarcodeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                            forIndexPath:indexPath];
    cell.textLabel.text = self.uniqueCodes[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.uniqueCodes.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - Helper Methods

- (void)displayPermissionMissingAlert {
    NSString *message = nil;
    if ([MTBBarcodeScanner scanningIsProhibited]) {
        message = @"This app does not have permission to use the camera.";
    } else if (![MTBBarcodeScanner cameraIsPresent]) {
        message = @"This device does not have a camera.";
    } else {
        message = @"An unknown error occurred.";
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Scanning Unavailable"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}

- (void)scrollToLastTableViewCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.uniqueCodes.count - 1
                                                inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

#pragma mark - Setters

- (void)setUniqueCodes:(NSMutableArray *)uniqueCodes {
    _uniqueCodes = uniqueCodes;
    [self.tableView reloadData];
}

@end
