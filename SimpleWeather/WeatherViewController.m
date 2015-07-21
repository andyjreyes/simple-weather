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

@end

@implementation WeatherViewController


#pragma mark - Constants


static NSString* kDefaultQuery = @"SELECT * FROM weather.forecast WHERE woeid=23424828";


#pragma mark - WeatherViewController Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: Show network activity indicator
    // TODO: Possibly show a UI-blocking loading indicator
    
    [[self webView] loadHTMLString:[[self weatherForecast] currentWeatherDescriptionHTML] baseURL:nil];
    
    // TODO: Remove UI-blocking loading indicator
}


#pragma mark - Property Getters


- (WeatherForecast *)weatherForecast
{
    if (!_weatherForecast) {
        _weatherForecast = [[WeatherForecast alloc] initWithQuery:kDefaultQuery];
    }
    return _weatherForecast;
}


#pragma mark - Memory Methods


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
