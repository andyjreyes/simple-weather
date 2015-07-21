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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Simple test to make sure WeatherForecast method works
    if (!_weatherForecast) {
        _weatherForecast = [[WeatherForecast alloc] initWithQuery:@"SELECT * FROM weather.forecast WHERE woeid=23424828"];
        
        [[self webView] loadHTMLString:[_weatherForecast currentWeatherDescriptionHTML] baseURL:nil];
    }

    // TODO: Show network activity indicator
    
    // TODO: Possibly show a UI-blocking loading indicator
        // TODO: Get WeatherForecast data
        // TODO: Remove UI-blocking loading indicator
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
