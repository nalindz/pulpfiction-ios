//
//  ViewController.m
//  BookApp
//
//  Created by Nalin on 11/1/12.
//
//

#import "ViewController.h"
#import <RestKit/RestKit.h>
#import "API.h"
#import "Block.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [API sharedInstance];
    int storyId = 2;
//    int first_block = 0;
//    int last_block = 5;
    [RKObjectManager.sharedManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"stories/%d/blocks?first_block=%d&last_block=%d", storyId, self.pageNumber, self.pageNumber] delegate:self];
    
   // [appDelegate.columnsController loadTitleView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Error loading venues: %@", error);
}

- (void) objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"got objects: %@", objects);
    if (objects.count == 0) return;
    Block *block = [objects objectAtIndex:0];
    NSLog(@"The text: %@", block.text);
    self.text = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 500, 50)];
    self.text.text = block.text;
    [self.view addSubview:self.text];
}




@end
