//
//  DCThumnail.m
//  DCThumbnail
//
//  Created by Ishaan Gulrajani on 3/22/14.
//  Copyright (c) 2014 DeskConnnect. All rights reserved.
//

#import "DCThumnail.h"

@implementation DCThumnail

-(id)initWithURL:(NSURL *)URL {
    self = [super init];
    if(self) {
        _URL = URL;
    }
    return self;
}

@end
