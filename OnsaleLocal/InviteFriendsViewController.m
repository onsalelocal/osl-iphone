//
//  InviteFriendsViewController.m
//  OnsaleLocal
//
//  Created by Admin on 1/29/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "ECSlidingViewController.h"
#import <Social/Social.h>
//#import <Social/SLComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "NavigationTopViewController.h"

#define FACEBOOK_ROW 0
#define TWITTER_ROW 1
#define SMS_ROW 2
#define EMAIL_ROW 3


@interface InviteFriendsViewController ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) UIBarButtonItem* menuButton;
@end

@implementation InviteFriendsViewController

@synthesize itemLikeDescription = _itemLikeDescription;
@synthesize like = _like;
@synthesize menuButton = _menuButton;

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
    if(self.like){
        self.title = @"Share with Friends";
    }else{
        self.title = @"Invite Friends";
    }
    
    if(!self.like){
        self.menuButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu21.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealMenu:)];
        self.navigationItem.leftBarButtonItem = self.menuButton;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SLComposeViewController *controllerSLC = nil;
    MFMessageComposeViewController *messageVC = nil;
    MFMailComposeViewController *mailVC = nil;

    switch (indexPath.row) {
        case FACEBOOK_ROW:
            controllerSLC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            if(self.like){
                [controllerSLC setInitialText:self.itemLikeDescription];

            }else{
                [controllerSLC setInitialText:@"Check out this amazing app.  OnsaleLocal finds you just about any deal near you thats posted on the internet!"];
            }
            [controllerSLC addURL:[NSURL URLWithString:@"http://www.onsalelocal.com"]];
            //[controllerSLC addImage:[UIImage imageNamed:@"test.jpg"]];
            [self presentViewController:controllerSLC animated:YES completion:nil];
            break;
            
        case TWITTER_ROW:
            controllerSLC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            if(self.like){
                [controllerSLC setInitialText:self.itemLikeDescription];

            }else{
                [controllerSLC setInitialText:@"Check out this amazing app.  OnsaleLocal finds you just about any deal near you thats posted on the internet!"];

            }
            [controllerSLC addURL:[NSURL URLWithString:@"http://www.onsalelocal.com"]];
            //[controllerSLC addImage:[UIImage imageNamed:@"test.jpg"]];
            [self presentViewController:controllerSLC animated:YES completion:nil];
            break;
#warning SMS and email might be different from FB/twitter text
        case SMS_ROW:
            if([MFMessageComposeViewController canSendText]){
                messageVC = [[MFMessageComposeViewController alloc]init];
                NSLog(@"%@", messageVC);
                if(self.like){
                    [messageVC setBody:self.itemLikeDescription];
                }else{
                    [messageVC setBody:[NSString stringWithFormat: @"Check out OnsaleLocal in the App Store or at www.onsalelocal.com.  Its free and can save you tons on Local Deals!" ]];

                }
                messageVC.messageComposeDelegate = self;
                [self presentViewController:messageVC animated:YES completion:nil];
            }
            else{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error Sending Message" message:@"Your device is currently not able to send messages.  Please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
            break;
        case EMAIL_ROW:
            if([MFMailComposeViewController canSendMail]){
                mailVC = [[MFMailComposeViewController alloc]init];
                mailVC.mailComposeDelegate = self;
                [mailVC setMessageBody:[NSString stringWithFormat: @"Check out OnsaleLocal in the App Store.  Its free and can save you tons on Local Deals! Anything from Electronics to Massages or from places like Groupon to Shop Local.  This app has everything you need.  http://www.onsalelocal.com"] isHTML:NO];
                if(self.like){
                    [mailVC setMessageBody: self.itemLikeDescription isHTML:NO];
                }
                [self presentViewController:mailVC animated:YES completion:nil];
            }
            else{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error Sending Email" message:@"Your device is currently not able to send email messages.  Please try again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
            break;
            
        default:
            break;
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
