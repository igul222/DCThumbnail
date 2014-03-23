//
//  DCUTI.m
//  DeskConnect
//
//  Created by Ari on 11/3/13.
//  Copyright (c) 2013 Squish Software. All rights reserved.
//

#import "DCUTI.h"

CFStringRef const kUTDCTypeURLName = CFSTR("public.url-name");
CFStringRef const kUTDCTypeAppleM4A = CFSTR("com.apple.m4a-audio"); // Available under AVFoundation as AVFileTypeAppleM4A, but not under UTCoreTypes

@implementation DCUTI

@synthesize string = _string;

#pragma mark - Initialization

+ (instancetype)UTIWithString:(NSString *)string {
    return [[[self alloc] initWithString:string] autorelease];
}

+ (instancetype)UTIWithUTType:(CFStringRef)utType {
    return [self UTIWithString:(NSString *)utType];
}

- (instancetype)initWithString:(NSString *)string {
    if (!string) {
        [self release];
        return nil;
    }
    
    self = [super init];
    if (!self)
        return nil;
    
    _string = [string copy];
    
    return self;
}

- (void)dealloc {
    [_string release];
    
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: %@", [super description], self.string];
}

#pragma mark - UTIs from files

+ (instancetype)UTIFromFilename:(NSString *)filename {
    if ([filename hasSuffix:@".rtfd.zip"])
        return [self UTIFromFileExtension:@"rtf"];
    
    return [self UTIFromFileExtension:[filename pathExtension]];
}

+ (instancetype)UTIFromFileExtension:(NSString *)fileExtension {
    return [self UTIForTagClass:kUTTagClassFilenameExtension tag:(CFStringRef)fileExtension];
}

#pragma mark - String accessors

- (CFStringRef)utType {
    return (CFStringRef)_string;
}

- (NSString *)string {
    return _string;
}

#pragma mark - Equality

- (BOOL)isEqual:(DCUTI *)UTI {
    if (UTI == self)
        return YES;
    
    if ([UTI isKindOfClass:[self class]] && [self isEqualToUTType:UTI.utType])
        return YES;
    
    return NO;
}

- (NSUInteger)hash {
    return [[self.string lowercaseString] hash];
}

- (BOOL)isEqualToUTI:(DCUTI *)UTI {
    return [self isEqual:UTI];
}

- (BOOL)isEqualToString:(NSString *)UTIString {
    return [self isEqualToUTType:(CFStringRef)UTIString];
}

- (BOOL)isEqualToUTType:(CFStringRef)utType {
    if (!utType)
        return NO;
    
    return !!UTTypeEqual(self.utType, utType);
}

#pragma mark - Conformance

- (BOOL)conformsToUTI:(DCUTI *)UTI {
    return [self conformsToUTType:UTI.utType];
}

- (BOOL)conformsToUTType:(CFStringRef)utType {
    return UTTypeConformsTo(self.utType, utType);
}

#pragma mark - Conforming UTIs

- (NSArray *)conformingUTIsWithFileExtension:(NSString *)fileExtension {
    return [self conformingUTIsWithTagClass:kUTTagClassFilenameExtension tag:fileExtension];
}

- (NSArray *)conformingUTIsWithMIMEType:(NSString *)MIMEType {
    return [self conformingUTIsWithTagClass:kUTTagClassMIMEType tag:MIMEType];
}

#pragma mark - Type declaration

- (NSDictionary *)typeDeclaration {
    return [(NSDictionary *)UTTypeCopyDeclaration(self.utType) autorelease];
}

- (NSURL *)declaringBundleURL {
    return [(NSURL *)UTTypeCopyDeclaringBundleURL(self.utType) autorelease];
}

- (NSArray *)UTIsConformedTo {
    NSArray *typesConformedTo = [self.typeDeclaration objectForKey:(id)kUTTypeConformsToKey];
    
    if ([typesConformedTo isKindOfClass:[NSString class]])
        typesConformedTo = [NSArray arrayWithObject:typesConformedTo];
    
    if (![typesConformedTo isKindOfClass:[NSArray class]])
        return nil;
    
    NSInteger typeCount = [typesConformedTo count];
    if (!typeCount)
        return nil;
    
    return [[self class] UTIsFromUTTypes:typesConformedTo];
}

#pragma mark - Converting to other types

- (NSString *)fileExtension {
    if ([self isEqualToUTType:kUTTypeUTF8PlainText] || [self isEqualToUTType:kUTTypePlainText] || [self isEqualToUTType:kUTTypeText])
        return @"txt";
    
    return [self preferredTagWithClass:kUTTagClassFilenameExtension];
}

- (NSString *)MIMEType {
    return [self preferredTagWithClass:kUTTagClassMIMEType];
}

#if DC_TARGET_MAC

- (NSString *)pboardType {
    return [self preferredTagWithClass:kUTTagClassNSPboardType];
}

- (NSString *)OSType {
    return [self preferredTagWithClass:kUTTagClassOSType];
}

#endif

#pragma mark - Internal methods

+ (NSArray *)UTIsFromUTTypes:(NSArray *)utTypes excludingType:(NSString *)excludedTypeString {
    NSMutableArray *UTIs = [NSMutableArray arrayWithCapacity:[utTypes count]];
    for (NSString *utTypeString in utTypes)
        if (![excludedTypeString isEqualToString:utTypeString])
            [UTIs addObject:[self UTIWithString:utTypeString]];
    
    return UTIs;
}

+ (NSArray *)UTIsFromUTTypes:(NSArray *)utTypes {
    return [self UTIsFromUTTypes:utTypes excludingType:nil];
}

+ (DCUTI *)UTIForTagClass:(CFStringRef)tagClass tag:(CFStringRef)tag {
    NSString *UTIString = [(NSString *)UTTypeCreatePreferredIdentifierForTag(tagClass, tag, NULL) autorelease];
    return [self UTIWithString:UTIString];
}

+ (NSArray *)UTIsForTagClass:(CFStringRef)tagClass tag:(CFStringRef)tag conformingToType:(CFStringRef)conformingToType {
    NSArray *utTypes = [(NSArray *)UTTypeCreateAllIdentifiersForTag(tagClass, tag, conformingToType) autorelease];
    return [self UTIsFromUTTypes:utTypes excludingType:(NSString *)conformingToType];
}

- (NSString *)preferredTagWithClass:(CFStringRef)class {
    return [(NSString *)UTTypeCopyPreferredTagWithClass(self.utType, class) autorelease];
}

- (NSArray *)conformingUTIsWithTagClass:(CFStringRef)tagClass tag:(NSString *)tag {
    return [[self class] UTIsForTagClass:tagClass tag:(CFStringRef)tag conformingToType:self.utType];
}

@end
