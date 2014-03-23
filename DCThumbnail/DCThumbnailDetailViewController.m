//
//  DCThumbnailDetailViewController.m
//  DCThumbnail
//
//  Created by Ishaan Gulrajani on 3/22/14.
//  Copyright (c) 2014 DeskConnnect. All rights reserved.
//

#import "DCThumbnailDetailViewController.h"
#import "DCThumbnail.h"

@interface DCThumbnailDetailViewController ()

@end

@implementation DCThumbnailDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadURL:(NSURL *)URL {
    [[[DCThumbnail alloc] initWithURL:URL] beginRenderingWithSize:CGSizeMake(400, 400) completion:^(UIImage *image) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
        imageView.image = image;
        [self.view addSubview:imageView];
    }];
}

@end