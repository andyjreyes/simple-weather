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

@property WeatherForecast *weatherForecast;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Simple test to make sure WeatherForecast method works
    if (!_weatherForecast) {
        _weatherForecast = [[WeatherForecast alloc] initWithQuery:@"SELECT * FROM weather.forecast WHERE woeid=23424828"];
        NSLog(@"Weather HTML:\n%@", _weatherForecast.currentWeatherDescriptionHTML);
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
