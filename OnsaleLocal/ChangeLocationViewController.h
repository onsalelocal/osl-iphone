

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@interface ChangeLocationViewController : UIViewController

@property (nonatomic, retain) NSMutableArray* suggestions;
@property (nonatomic, retain) IBOutlet UILabel* label;
@property (assign) BOOL dirty;
@property (assign) BOOL loading;
@property (strong, nonatomic) CLLocation* location;
//@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (void) loadSearchSuggestions;

//- (IBAction)revealMenu:(id)sender;
//- (IBAction)revealUnderRight:(id)sender;

@end
