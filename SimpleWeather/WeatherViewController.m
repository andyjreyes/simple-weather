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


static NSString* kDefaultQuery = @"SELECT * FROM weather.forecast WHERE woeid=23424827";
static NSString* kSunrisePrefix = @"Sunrise: %@";
static NSString* kSunsetPrefix = @"Sunset: %@";


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
        // Activity indicator when content is loading
        [[self activityIndicator] startAnimating];
        [[self activityIndicator] hidesWhenStopped];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _weatherForecast = nil;
            NSString *query = _yqlQuery ? _yqlQuery : kDefaultQuery;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            _weatherForecast = [[WeatherForecast alloc] initWithQuery:query];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self webView] loadHTMLString:_weatherForecast.currentWeatherDescriptionHTML baseURL:nil];
                [self setSunriseTime:_weatherForecast.sunrise];
                [self setSunsetTime:_weatherForecast.sunset];
                
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


#pragma mark - Memory Methods


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
