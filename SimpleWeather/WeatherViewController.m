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


#pragma mark - WeatherViewController Methods


- (void)viewDidLoad {
    [super viewDidLoad];

    // Activity indicator when content is loading
    [[self activityIndicator] startAnimating];
    [[self activityIndicator] hidesWhenStopped];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!_weatherForecast) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            _weatherForecast = [[WeatherForecast alloc] initWithQuery:kDefaultQuery];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self webView] loadHTMLString:[[self weatherForecast] currentWeatherDescriptionHTML] baseURL:nil];
            [self setSunriseTime:[[self weatherForecast] sunrise]];
            [self setSunsetTime:[[self weatherForecast] sunset]];
            
            [[self activityIndicator] stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    });
}


#pragma mark - Property Getters


- (WeatherForecast *)weatherForecast
{
    if (!_weatherForecast) {
        _weatherForecast = [[WeatherForecast alloc] initWithQuery:kDefaultQuery];
    }
    return _weatherForecast;
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


#pragma mark - Memory Methods


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
