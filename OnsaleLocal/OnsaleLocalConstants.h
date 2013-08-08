//
//  OnsaleLocalConstants.h
//  OnsaleLocal
//
//  Created by Admin on 1/29/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#ifndef OnsaleLocal_OnsaleLocalConstants_h
#define OnsaleLocal_OnsaleLocalConstants_h

//10800 sec = 3 hrs
#define CACHE_TIMEOUT 10800

#define DEAL_TITLE @"title"
#define DEAL_ID @"id"
#define DEAL_DISCOUNT @"discount"
#define DEAL_PRICE @"price"
#define DEAL_CITY @"city"
#define DEAL_IMAGE_URL @"smallImg"
#define DEAL_STORE @"merchant"
#define DEAL_DISTANCE @"distance"
#define DEAL_CATEGORY @"category"
#define DEAL_SOURCE @"source"
#define DEAL_ADDRESS @"address"
#define DEAL_STATE @"state"
#define DEAL_CITY @"city"
#define DEAL_LAT @"latitude"
#define DEAL_LONG @"longitude"
#define DEAL_PHONE @"phone"
#define DEAL_SUBCATEGORY @"subcategory"
#define DEAL_FROM_URL @"url"
#define DEAL_DESCRIPTION @"description"
#define DEAL_LARGE_IMAGE_URL @"largeImg"
#define DEAL_SHARED_BY @"submitter"

#warning NON OF THESE DEFINES ARE VERIFIED
#define STORE_FOLLOWER_COUNT @"followerCount"
#define STORE_NAME @"merchant"
#define STORE_ADDRESS @"address"
#define STORE_CITY @"city"
#define STORE_STATE @"state"
#define STORE_PHONE @"phone"
//#define STORE_DEAL_COUNT @"count"
#define STORE_IMAGE_URL @"smallImg"
#define STORE_DEAL_COUNT @"updated"
#define STORE_LOOKUP_NAME @"name"
#define STORE_NUMBER_OF_OFFERS @"offers"
#define STORE_ID @"id"
#define STORE_LAT @"latitude"
#define STORE_LONG @"longitude"

#define CATEGORY_NAME @"name"
#define CATEGORY_OFFER_COUNT @"offerCount"

#define CURRENT_LOCATION_ANNOTATION @"CurrentLocation1234"

#define SHOULD_REFRESH 1
#define SHOULD_NOT_REFRESH -1
#define SHOULD_REFRESH_NOT_INITIALIZED 0
#define SOMETHING 0

#define BOOKMARK_FILE_NAME @"bookmarks.plist"
#define FAVORITE_DEALS_FILE_NAME @"favorteDeals.plist"
#define FAVORITE_STORE_FILE_NAME @"favoriteStores.plist"

#define AFTER_FIRST_TIME_USER @"afterFirstTimeUserOnsaleLocal"
#define USER_EMAIL @"login"
#define USER_PASSWORD @"password"
#define USER_FIRST_NAME @"firstName"
#define USER_LAST_NAME @"lastName"
#define USER_ZIP_CODE @"zipcode"
#define USER_ID @"id"

#define FBSessionStateChangedNotification @"FBSessionStateChangedNotification"
#define FB_LOGIN_SUCCESS @"FB_LOGIN_SUCCESS"
#define FB_ACCESS_TOKEN @"FB_ACCESS_TOKEN"

#define GOOGLE_PLACES_KEY @"AIzaSyAzXQc0PqNIm4UzeUYzQBasokcErAgnVso"

#define TOGGLE_FAV_IMAGE @"toggleFavImage"

#define REFRESH_COLLECTION_VIEW @"REFRESH_COLLECTION_VIEW"

#define LS_NOT_DEFINED 1
#define LS_LOCAL_OFFERS_CATEGORIES -1
#define LS_WEEKLY_DEALS_STORES 2

#define LABEL_SPACING 20
#define LABEL_HEIGHT 20
#define TAG_FONT [UIFont fontWithName:@"Helvetica" size:14]

#define PERSONAL_INFO_OBJECT @"PERSONAL_INFO_OBJECT"

#define USER_LOGGED_IN @"USER_LOGGED_IN" 

/*
 NSDictionary* _params = @{DEAL_TITLE:self.dealTitle.text,
 DEAL_DESCRIPTION:self.descriptionField.text,
 DEAL_PRICE:self.originalPrice.text,
 DEAL_DISCOUNT:self.discount.text,
 STORE_NAME:self.storeName.text,
 STORE_ADDRESS:self.storeAddress.text,
 STORE_CITY:self.city.text,
 STORE_STATE:self.state.text,
 STORE_PHONE:self.phoneNumber};
 */


#endif
