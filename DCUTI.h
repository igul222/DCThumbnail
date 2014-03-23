//
//  DCUTI.h
//  DeskConnect
//
//  Created by Ari on 11/3/13.
//  Copyright (c) 2013 Squish Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCTargets.h"

#if DC_TARGET_MOBILE
#import <MobileCoreServices/MobileCoreServices.h>
#endif

extern CFStringRef const kUTDCTypeURLName;
extern CFStringRef const kUTDCTypeAppleM4A;

@interface DCUTI : NSObject {
    NSString *_string;
}

+ (instancetype)UTIWithString:(NSString *)string;
+ (instancetype)UTIWithUTType:(CFStringRef)utType;

+ (instancetype)UTIFromFilename:(NSString *)filename;
+ (instancetype)UTIFromFileExtension:(NSString *)fileExtension;

- (BOOL)isEqualToUTI:(DCUTI *)UTI;
- (BOOL)isEqualToUTType:(CFStringRef)utType;
- (BOOL)isEqualToString:(NSString *)UTIString;

- (BOOL)conformsToUTI:(DCUTI *)UTI;
- (BOOL)conformsToUTType:(CFStringRef)utType;

- (NSArray *)conformingUTIsWithFileExtension:(NSString *)fileExtension;
- (NSArray *)conformingUTIsWithMIMEType:(NSString *)MIMEType;

@property (nonatomic, readonly) NSString *string;
@property (nonatomic, readonly) CFStringRef utType;

@property (nonatomic, readonly) NSDictionary *typeDeclaration;
@property (nonatomic, readonly) NSURL *declaringBundleURL;
@property (nonatomic, readonly) NSArray *UTIsConformedTo;

@property (nonatomic, readonly) NSString *fileExtension;
@property (nonatomic, readonly) NSString *MIMEType;
#if DC_TARGET_MAC
@property (nonatomic, readonly) NSString *pboardType;
@property (nonatomic, readonly) NSString *OSType;
#endif

@end
