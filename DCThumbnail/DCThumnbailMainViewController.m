//
//  DCTableViewController.m
//  DCThumbnail
//
//  Created by Ishaan Gulrajani on 3/22/14.
//  Copyright (c) 2014 DeskConnnect. All rights reserved.
//

#import "DCThumnbailMainViewController.h"
#import "DCThumbnailDetailViewController.h"

@interface DCThumnbailMainViewController ()

@end

@implementation DCThumnbailMainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"DCThumnbail Demo";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSArray *)thumbnailTypes {
    return @[
             @[@"Web URL", [NSURL URLWithString:@"http://yahoo.com"]],
             @[@"Web URL with alerts", [NSURL URLWithString:@"http://stormy-chamber-5637.herokuapp.com"]],
             @[@"Image", [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"image.jpg" ofType:nil inDirectory:nil]] ],
             @[@"Video", [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"movie.m4v" ofType:nil inDirectory:nil]] ],
             @[@"Audio (MP3/ID3)", [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"mp3.mp3" ofType:nil inDirectory:nil]] ],
             @[@"Audio (M4A/iTunes)", [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"m4a.m4a" ofType:nil inDirectory:nil]] ],
              @[@"Audio (MP3/No Artwork)", [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"mp3-noart.mp3" ofType:nil inDirectory:nil]] ],
             @[@"Document (docx)", [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"docx.docx" ofType:nil inDirectory:nil]] ],
             @[@"Document (PDF)", [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pdf.pdf" ofType:nil inDirectory:nil]] ]
             ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self thumbnailTypes].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    cell.textLabel.text = [self thumbnailTypes][indexPath.row][0];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DCThumbnailDetailViewController *detailVC = [[DCThumbnailDetailViewController alloc] init];
    [detailVC loadURL:[self thumbnailTypes][indexPath.row][1]];
    [self.navigationController pushViewController:detailVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
