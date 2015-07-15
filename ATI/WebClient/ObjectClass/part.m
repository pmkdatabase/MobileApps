//
//  part.m
//  ATI
//
//  Created by E2M164 on 18/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import "part.h"
#import "NSString+HTML.h"
#import <UIKit/UIKit.h>

@implementation part

+ (part*)dataWithDict:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (part*)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        
        if (dict[@"part_id"]  != [NSNull null])
            self.intPartID = [dict[@"part_id"]integerValue];
        
        if (dict[@"Part_no"]  != [NSNull null])
            self.partNo = dict[@"Part_no"];
        
        if (dict[@"part_barcode"]  != [NSNull null])
            self.partBarcode = dict[@"part_barcode"];
        
        if (dict[@"part_desc"]  != [NSNull null])
            self.partDesc = dict[@"part_desc"];
        
        if (dict[@"part_name"]  != [NSNull null])
            self.partName = dict[@"part_name"];
        
        if (dict[@"part_unit_type"]  != [NSNull null])
            self.partUnitType = dict[@"part_unit_type"];
        
       // self.attributedDescString = [self getString:self.partDesc fontSize:14.0];
        
    }
    _open = NO;
    
    return self;
}
/*
- (NSMutableAttributedString*)getString:(NSString*)data fontSize:(CGFloat)size{
    NSDictionary *dictAttrib = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,  NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc]initWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:dictAttrib documentAttributes:nil error:nil];
    [attrib beginEditing];
    [attrib enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attrib.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            UIFont *oldFont = (UIFont *)value;
            [attrib removeAttribute:NSFontAttributeName range:range];
            if ([oldFont.fontName isEqualToString:@"TimesNewRomanPSMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:size] range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-BoldMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:size] range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-ItalicMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Italic" size:size] range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-BoldItalicMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Italic" size:size] range:range];
            else
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:size] range:range];
        }
    }];
    [attrib endEditing];
    return attrib;
}
*/
@end
