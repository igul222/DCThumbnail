//
//  DCThumbnailDetailViewController.h
//  DCThumbnail
//
//  Created by Ishaan Gulrajani on 3/22/14.
//  Copyright (c) 2014 DeskConnnect. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCThumbnail;
@interface DCThumbnailDetailViewController : UIViewController {
    DCThumbnail *renderer;
}

-(void)loadURL:(NSURL *)URL;

@end
