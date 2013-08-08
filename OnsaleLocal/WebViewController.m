//
//  WebViewController.m
//  OnsaleLocal
//
//  Created by Admin on 2/5/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView* webView;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (strong, nonatomic) UIActivityIndicatorView* spinner;

- (IBAction)backPressed:(id)sender ;
- (IBAction)forwardPressed:(id)sender;

@end

@implementation WebViewController

@synthesize webView = _webView;
@synthesize url = _url;
@synthesize spinner = _spinner;



- (IBAction)backPressed:(id)sender {
    if([self.webView canGoBack])
        [self.webView goBack];
}
- (IBAction)forwardPressed:(id)sender {
    if([self.webView canGoForward])
        [self.webView goForward];
}

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
	// Do any additional setup after loading the view.
    [self.bottomBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString* stringURL = @"http://www.maps.google.com/";
    NSURL *url = self.url ? self.url :[NSURL URLWithString:stringURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView{
    self.spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];
    self.navigationItem.titleView = self.spinner;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView{
    [self.spinner stopAnimating];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView* popup = [[UIAlertView alloc]initWithTitle:@"Error Loading Webpage" message:[NSString stringWithFormat:@"Error Code: %@",error.localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [popup show];
    [self.spinner stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"%@",request.URL.scheme);
    if ([[[request URL] scheme] isEqual:@"mailto"]) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

@end
