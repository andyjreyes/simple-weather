//
//  WeatherViewController.m
//  SimpleWeather
//
//  Created by Andy Reyes on 7/20/15.
//  Copyright (c) 2015 Andy Reyes. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherForecast.h"

@interface WeatherViewController ()

@property (nonatomic)  WeatherForecast *weatherForecast;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end


@implementation WeatherViewController


#pragma mark - Constants


static NSString* kDefaultQuery = @"SELECT * FROM weather.forecast WHERE woeid=23424828";
static NSString* kSunrisePrefix = @"Sunrise: %@";
static NSString* kSunsetPrefix = @"Sunset: %@";
static NSString* kErrorTitle = @"Could not update weather";
static NSString* kErrorMessage = @"Please try again";


#pragma mark - WeatherViewController Methods


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshView];
}


- (void)refreshView
{
    @synchronized(self)
    {
        // Show activity indicator when content is loading
        [[self activityIndicator] startAnimating];
        [[self activityIndicator] hidesWhenStopped];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _weatherForecast = nil;
            NSString *query = _yqlQuery ? _yqlQuery : kDefaultQuery;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            _weatherForecast = [[WeatherForecast alloc] initWithQuery:query];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_weatherForecast) {
                    [[self webView] loadHTMLString:_weatherForecast.currentWeatherDescriptionHTML baseURL:nil];
                    [self setSunriseTime:_weatherForecast.sunrise];
                    [self setSunsetTime:_weatherForecast.sunset];
                }
                else{
                    NSLog(@"Something went wrong, we don't have a weather forecast! Is your YQL query correct?");
                    
                    [self presentErrorAlert];
                }
                
                // Hide activity and network indicators
                [[self activityIndicator] stopAnimating];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        });
    }
}


- (void)setSunriseTime:(NSString *)time
{
    if (!time || time.length <= 0) {
        time = @"N/A";
    }
    
    _sunriseLabel.text = [[NSString alloc] initWithFormat:kSunrisePrefix, time];
}


- (void)setSunsetTime:(NSString *)time
{
    if (!time || time.length <= 0) {
        time = @"N/A";
    }
    
    _sunsetLabel.text = [[NSString alloc] initWithFormat:kSunsetPrefix, time];
}


- (IBAction)refreshButtonPressed:(UIBarButtonItem *)sender {
    
    [self refreshView];
}

- (void)presentErrorAlert
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:kErrorTitle
                                          message:kErrorMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK button pressed");
                               }];
    
    if (alertController && okAction) {
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        NSLog(@"An error occurred while showing our error alert message. Oh dear.");
    }
}


#pragma mark - Memory Methods


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
