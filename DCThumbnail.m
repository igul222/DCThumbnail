//
//  DCThumnail.m
//  DCThumbnail
//
//  Created by Ishaan Gulrajani on 3/22/14.
//  Copyright (c) 2014 DeskConnnect. All rights reserved.
//

#import "DCThumbnail.h"

@implementation DCThumbnail

-(id)initWithURL:(NSURL *)URL {
    self = [super init];
    if(self) {
        _URL = URL;
    }
    return self;
}

-(void)beginRenderingWithSize:(CGSize)size completion:(void (^)(UIImage *))completion {
    // TODO: implement
}

@end
