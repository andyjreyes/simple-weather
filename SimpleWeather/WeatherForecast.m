//
//  WeatherForecast.m
//  SimpleWeather
//
//  Created by Andy Reyes on 7/20/15.
//  Copyright (c) 2015 Andy Reyes. All rights reserved.
//

#import "WeatherForecast.h"
#import "YQL.h"

@interface WeatherForecast ()

@end

@implementation WeatherForecast

- (instancetype)initWithQuery:(NSString *)query
{
    self = [super init];
    if (self) {
        
        NSDictionary *results = [self retrieveYQLResultsWithQuery:query];
        
        if (results) {
            [self populateWeatherForecastWithResults:results];
        }
    }
    return self;
}

- (NSDictionary *)retrieveYQLResultsWithQuery:(NSString *)query
{
    // Make sure query exists
    if (!query || query.length <= 0) {
        return nil;
    }
    
    YQL *yql = [[YQL alloc] init];
    
    if (yql) {
        NSDictionary *results = [yql query:query];
        
        NSLog(@"Results from YQL query:\n%@",[[results valueForKeyPath:@"query.results"] description]);
        
        return results;
    }
    
    return nil;
}

- (void)populateWeatherForecastWithResults:(NSDictionary *)results
{
    // Using the NSDictionary of data, populate the WeatherForecast properties
    
    if (!results || results.count <= 0) {
        // TODO: Possibly make WeatherForecast's initializer failable, return a BOOL here
        return;
    }
    
    // WeatherForecast's properties should only be populated once
    // TODO: Will most likely move each property to its own lazily-instantiated getter method
    if (!_currentWeatherDescriptionHTML) {
        _currentWeatherDescriptionHTML = [results valueForKeyPath:@"query.results.channel.item.description"];
    }
    
}

@end