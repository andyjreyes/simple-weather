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
@synthesize sunrise = _sunrise;
@synthesize sunset = _sunset;


#pragma mark - Constants


static NSString *kYQLCurrentWeatherDescription = @"query.results.channel.item.description";
static NSString *kYQLSunrise = @"query.results.channel.astronomy.sunrise";
static NSString *kYQLSunset = @"query.results.channel.astronomy.sunset";


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


- (NSString *)sunrise
{
    // Gets the sunrise time, example: @"6:14 am"
    
    if (!_sunrise) {
        NSDictionary *results = [self weatherResults];
        NSString* tempString = [[NSMutableString alloc] init];
        
        if (results && results.count > 0) {
            tempString = [results valueForKeyPath:kYQLSunrise];
            
            // There is no available sunrise time
            if ([tempString hasPrefix:@" "]) {
                tempString = @"N/A";
            }
        }
        
        _sunrise = tempString;
    }
    
    return _sunrise;
}


- (NSString *)sunset
{
    // Gets the sunset time, example: @"7:22 pm"
    
    if (!_sunset) {
        NSDictionary *results = [self weatherResults];
        NSString* tempString = [[NSMutableString alloc] init];
        
        if (results && results.count > 0) {
            tempString = [results valueForKeyPath:kYQLSunset];
            
            // There is no available sunset time
            if ([tempString hasPrefix:@" "]) {
                tempString = @"N/A";
            }
        }
        
        _sunset = tempString;
    }
    
    return _sunset;
}


@end