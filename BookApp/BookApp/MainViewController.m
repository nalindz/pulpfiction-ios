//
//  MainViewController.m
//  BookApp
//
//  Created by Nalin on 11/5/12.
//
//

#import "MainViewController.h"
#import "ISColumnsController.h"
#import "ViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ISColumnsController *pageController = [[ISColumnsController alloc] init];
    
    ViewController *vc = [[ViewController alloc] init];
    vc.pageNumber = 0;
    
    ViewController *vc2 = [[ViewController alloc] init];
    vc2.pageNumber = 1;
    
    ViewController *vc3 = [[ViewController alloc] init];
    vc2.pageNumber = 2;
    pageController.viewControllers = [NSMutableArray arrayWithObjects: vc, vc2, vc3, nil];
    
    [pageController reloadChildViewControllers];
    [self.view addSubview:pageController];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
