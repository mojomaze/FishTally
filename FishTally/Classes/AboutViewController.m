//
//  AboutViewController.m
//  FishTally
//
//  Created by mwinkler on 5/27/13.
//
//

#import "AboutViewController.h"

@interface AboutViewController ()
{
    IBOutlet UIWebView*              oWebView;
}
@end

@implementation AboutViewController


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
	[oWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.fish-tally.com/about"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
