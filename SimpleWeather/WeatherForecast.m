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

@property (readonly) NSString *query;
@property (readonly) NSDictionary *weatherResults;

@end


@implementation WeatherForecast


#pragma mark - Synthesize


@synthesize weatherResults = _weatherResults;
@synthesize currentWeatherDescriptionHTML = _currentWeatherDescriptionHTML;


#pragma mark - Constants


static NSString *kYQLCurrentWeatherDescription = @"query.results.channel.item.description";


#pragma mark - Init Methods


- (instancetype)initWithQuery:(NSString *)query
{
    self = [super init];
    if (self) {
        
        if (!query || query.length <= 0) {
            return nil;
        }
        
        _query = query;
    }
    return self;
}


#pragma mark - JSON Parsing and Property Getters


- (NSDictionary *) weatherResults
{
    // Retrieves and stores the JSON data from Yahoo! Weather API
    
    @synchronized(self) {
        if (!_weatherResults) {
            YQL *yql = [[YQL alloc] init];
            
            if (yql) {
                NSDictionary *results = [yql query:[self query]];
                _weatherResults = results;
            }
        }
        return _weatherResults;
    }
}


- (NSString *)currentWeatherDescriptionHTML
{
    // Retrieves and stores the HTML string for the current weather
    
    if (!_currentWeatherDescriptionHTML) {
        NSDictionary *results = [self weatherResults];
        
        if (results && results.count > 0) {
            _currentWeatherDescriptionHTML = [results valueForKeyPath:kYQLCurrentWeatherDescription];
        }
    }
    return _currentWeatherDescriptionHTML;
}


@end