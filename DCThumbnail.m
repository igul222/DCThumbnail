//
//  DCThumnail.m
//  DCThumbnail
//
//  Created by Ishaan Gulrajani on 3/22/14.
//  Copyright (c) 2014 DeskConnnect. All rights reserved.
//

#import "DCThumbnail.h"
#import "NSURL+DCUTI.h"
#import "DCUTI.h"

@implementation DCThumbnail

-(id)initWithURL:(NSURL *)URL {
    self = [super init];
    if(self) {
        _URL = URL;
    }
    return self;
}

-(void)beginRenderingWithSize:(CGSize)size completion:(void (^)(UIImage *))completion {
    if([_URL isFileURL]) {
        DCUTI *UTI = [_URL fileUTI];
        if([UTI conformsToUTI:[DCUTI UTIWithString:@"public.image"]]) {
            // Don't resize the image manually because UIImageView will do it more efficiently when it renders anyway
            completion([UIImage imageWithContentsOfFile:[_URL path]]);
        }
    } else { // Web URL
        
    }
}

@end
