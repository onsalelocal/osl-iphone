


//
//  AutocompleteLocationExample.m
//  IOSBoilerplate
//
//  Copyright (c) 2011 Alberto Gimeno Brieba
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "ChangeLocationViewController.h"
#import "StringHelper.h"
#import "JSONKit.h"
#import "AFJSONRequestOperation.h"
#import <MapKit/MapKit.h>
#import "InitialSlidingViewController.h"
#import "MKGooglePointAnnotation.h"
#import "OnsaleLocalConstants.h"
#import "Container.h"

@interface ChangeLocationViewController()<CLLocationManagerDelegate, LocationUpdate>

@property (strong, nonatomic) NSString* address;
//@property (weak, nonatomic) IBOutlet UILabel* addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *coordinateLabel;
@property (strong, nonatomic) UIActivityIndicatorView* spinner;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *useDeviceLocationButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation ChangeLocationViewController

@synthesize address = _address;
//@synthesize addressLabel = _addressLabel;
@synthesize location = _location;
@synthesize spinner = _spinner;
@synthesize useDeviceLocationButton = _useDeviceLocationButton;
@synthesize toolBar = _toolBar;
@synthesize searchBar = _searchBar;

@synthesize suggestions;
@synthesize dirty;
@synthesize loading;
@synthesize label;



- (void) locationUpdate: (CLLocation*) location{
    self.location = location;
    [self.spinner stopAnimating];
}

- (void) setLocation:(CLLocation *)location{
    _location = location;
    
}
/*
- (void) setAddress:(NSString *)address{
    if(_address != address){
        _address = address;
        self.addressLabel.text = address;
    }
}
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark SearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if ([searchText length] > 2) {
		if (loading) {
			dirty = YES;
		} else {
			[self loadSearchSuggestions];
		}
	}
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	return NO;
}


#pragma mark -
#pragma mark Search backend

- (void) loadSearchSuggestions {
	loading = YES;
	NSString* query = self.searchDisplayController.searchBar.text;
    // You could limit the search to a region (e.g. a country) by appending more text to the query
	query = [NSString stringWithFormat:@"%@, USA", query];
	NSString *urlEncode = [query urlEncode];
    //https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=true&key=AIzaSyAOzJADcG1AcQUhAjs7gOLSzyO9uCiq7Ow
    //http://maps.google.com/maps/geo?q=%@&hl=%@&oe=UTF8
	NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=true&key=%@", urlEncode,GOOGLE_PLACES_KEY];
    //urlString = @"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Amoeba&sensor=true&key=AIzaSyAzXQc0PqNIm4UzeUYzQBasokcErAgnVso";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray* sug = [[NSMutableArray alloc] init];
        NSLog(@"%@",JSON);
        NSArray* placemarks = [JSON objectForKey:@"predictions"];
        
        for (NSDictionary* placemark in placemarks) {
            NSString* address = [placemark objectForKey:@"description"];
            
            NSString* reference = placemark[@"reference"];
            
            MKGooglePointAnnotation* place = [[MKGooglePointAnnotation alloc] init];
            place.title = address;
            place.reference = reference;
            
            [sug addObject:place];
            //place release];
        }
        
        self.suggestions = sug;
        //[sug release];
        
        [self.searchDisplayController.searchResultsTableView reloadData];
        loading = NO;
        
        if (dirty) {
            dirty = NO;
            [self loadSearchSuggestions];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id obj) {
        NSLog(@"failure %@", [error localizedDescription]);
        loading = NO;
    }];
    [AFHTTPRequestOperation addAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil]];
    [operation start];
}



#pragma mark -
#pragma mark UITableView methods

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"suggest";
	
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
		cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
	}
	
	MKPointAnnotation* suggestion = [suggestions objectAtIndex:indexPath.row];
	cell.textLabel.text = suggestion.title;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.searchDisplayController setActive:NO animated:YES];
	
	MKGooglePointAnnotation* suggestion = [suggestions objectAtIndex:indexPath.row];
    // You could add "suggestion" to a map since it implements MKAnnotation
    // example: [map addAnnotation:suggestion]
    float lat = suggestion.coordinate.latitude;
    float lon = suggestion.coordinate.longitude;
    CLLocation* location = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
    self.coordinateLabel.text = [NSString stringWithFormat:@"Lat: %f, Long: %f",lat,lon];
    label.text = suggestion.title;
    
    InitialSlidingViewController* isvc = (InitialSlidingViewController*)self.slidingViewController;
    [isvc.locationManager stopMonitoringSignificantLocationChanges];
    //if(DEBUG) NSLog(@"%@", isvc.location);
    isvc.location = location;
    [Container startUpdatingWithLocation:location];
    //if(DEBUG) NSLog(@"%@", isvc.location);

    //[self.navigationController setToolbarItems:[NSArray arrayWithObject: self.useDeviceLocationButton]];
    [self.toolBar setItems:[NSArray arrayWithObject: self.useDeviceLocationButton]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [suggestions count];
}

#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.location != [Container theContainer].location){
        [self.toolBar setItems:[NSArray arrayWithObject: self.useDeviceLocationButton]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.title = @"Search a Location";
    self.location = [Container theContainer].location;
    if(self.location){
        self.coordinateLabel.text = [NSString stringWithFormat:@"Lat: %f, Long: %f",self.location.coordinate.latitude,self.location.coordinate.longitude];
        CLGeocoder *coder = [[CLGeocoder alloc]init];
        [coder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError* error){
            if (error) {
                NSLog(@"Reverse Geocode Error: %@",error.localizedDescription);
            }
            else{
                if(placemarks.count > 0){
                   self.label.text = [NSString stringWithFormat:@"%@ %@, %@ %@",[placemarks[0] name],[placemarks[0] locality], [placemarks[0] administrativeArea], [placemarks[0] ISOcountryCode]];
                }
            }
        }];
  
        
    }
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = self.view.center;
    [self.spinner.layer setBackgroundColor:[[UIColor colorWithWhite:0.0 alpha:.3] CGColor]];
    self.spinner.frame = CGRectMake(self.view.center.x-70, self.view.center.y-100, 140, 100);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    self.useDeviceLocationButton = [[UIBarButtonItem alloc]initWithTitle:@"Use Device Location" style:UIBarButtonItemStyleBordered target:self action:@selector(changeLocation:)];
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"]];
    
}

- (IBAction)changeLocation:(UIBarButtonItem*)sender {
    InitialSlidingViewController* isvc = (InitialSlidingViewController*)self.slidingViewController;
    //NSLog(@"%@", isvc.location);
    isvc.location = isvc.deviceLocation;
    //NSLog(@"%@", isvc.location);
    self.location = isvc.deviceLocation;
    self.coordinateLabel.text = [NSString stringWithFormat:@"Lat: %f, Long: %f",self.location.coordinate.latitude,self.location.coordinate.longitude];
    [isvc.locationManager startMonitoringSignificantLocationChanges];
    CLGeocoder *coder = [[CLGeocoder alloc]init];
    [coder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError* error){
        if (error) {
            NSLog(@"Reverse Geocode Error: %@",error.localizedDescription);
        }
        else{
            if(placemarks.count > 0){
                self.label.text = [NSString stringWithFormat:@"%@ %@, %@ %@",[placemarks[0] name],[placemarks[0] locality], [placemarks[0] administrativeArea], [placemarks[0] ISOcountryCode]];
            }
        }
    }];
    //[self.spinner startAnimating];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc {
    /*
    [suggestions release];
    [label release];
    [super dealloc];
     */
}

@end
