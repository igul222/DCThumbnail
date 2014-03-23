//
//  NSURL+DCUTI.m
//  DeskConnect
//
//  Created by Ari on 12/10/13.
//  Copyright (c) 2013 Squish Software. All rights reserved.
//

#import "NSURL+DCUTI.h"
#import "DCUTI.h"

@implementation NSURL (DCUTI)

- (DCUTI *)fileUTI {
    if (![self isFileURL])
        return nil;
    
    DCUTI *fileUTI = nil;
    
    if ([self respondsToSelector:@selector(getResourceValue:forKey:error:)]) {
        NSString *fileType = nil;
        [self getResourceValue:&fileType forKey:NSURLTypeIdentifierKey error:nil];
        
        fileUTI = [DCUTI UTIWithString:fileType];
    }
    
#if DC_TARGET_MAC
    if (!fileUTI) {
        CFStringRef typeString = nil;
        FSRef fileRef = self.fileRef;
        LSCopyItemAttribute(&fileRef, kLSRolesNone, kLSItemContentType, (CFTypeRef *)&typeString);
        
        if (typeString) {
            fileUTI = [DCUTI UTIWithUTType:typeString];
            CFRelease(typeString);
        }
    }
#endif
    
    if (!fileUTI)
        fileUTI = [DCUTI UTIFromFilename:self.lastPathComponent];
    
    return fileUTI;
}

@end
