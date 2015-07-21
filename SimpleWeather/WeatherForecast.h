//
//  WeatherForecast.h
//  SimpleWeather
//
//  Created by Andy Reyes on 7/20/15.
//  Copyright (c) 2015 Andy Reyes. All rights reserved.
//
//  This class is our model for all weather-related data.
//  This class is also in charge of downloading and parsing the Yahoo! JSON weather data.

#import <UIKit/UIKit.h>

@interface WeatherForecast : NSObject

- (instancetype) initWithQuery:(NSString*)query;

@end
