    //
    //  ImagesWeather.swift
    //  LeBaluchon
    //
    //  Created by Greg Deveaux on 01/12/2022.
    //

import UIKit

enum WeatherDescription: String {
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case scatteredClouds = "scattered clouds"
    case brokenClouds = "broken clouds"
    case showerRain = "shower rain"
    case lightRain = "light rain"
    case overcastCloud = "overcast clouds"
    case moderateRain = "moderate rain"
    case rain
    case thunderstorm
    case snow = "light snow"
    case mist
}

enum ImagesWeather {
    enum Background: String {
        case clearSkyDay = "veryLittleCloud.png"
        case fewCloudsDay = "littleCloud.png"
        case clearSkyNight = "skyNight.png"
        case fewCloudsNight = "littleCloudyByNight.png"
        case scatteredCloudsDay = "littleCloudy.png"
        case scatteredCloudsNight = "scatteredCloudsNight.png"
        case brokenCloudsDay = "cloudyPower1.png"
        case brokenCloudsNight = "cloudyByNight.png"
        case overcastCloudsDay = "cloudyPower2.png"
        case overcastCloudsNight = "overcastCloudsNight.png"
        case lightRainDay = "lightRainDay.png"
        case lightRainNight = "lightRainNight.png"
        case moderateRainDay = "moderateRainByDay.png"
        case moderateRainNight = "moderateRainByNight.png"
        case rainDay = "rainByDay.png"
        case rainNight = "rainByNight.png"
        case thunderstormDay = "stormByDay.png"
        case thunderstormNight = "stormByNight.png"
        case snowDay = "snowByDay.png"
        case snowNight = "snowByNight.png"
        case mistDay = "mistDay.png"
        case mistNight = "mistNight.png"
    }

    enum Icon: String {
        case clearSkyDay = "sun.max.fill"
        case clearSkyNight = "moon.stars"
        case fewCloudsDay = "cloud.sun.fill"
        case fewCloudsNight = "cloud.moon.fill"
        case scatteredClouds = "cloud.fill"
        case brokenClouds = "smoke.fill"
        case lightRain = "cloud.drizzle.fill"
        case rain = "cloud.rain.fill"
        case thunderstorm = "cloud.bolt.rain.fill"
        case snow = "cloud.snow.fill"
        case mist = "cloud.fog.fill"
    }

    enum Perso: String {
        case clearSky = "perso1.pdf"
        case fewClouds
        case scatteredClouds
        case brokenClouds
        case snow
        case mist = "cloudCool.pdf"
        case showerRain
        case lightRain
        case rain
        case thunderstorm = "cloudThunder.pdf"
    }
}



extension ImagesWeather {

    static func weatherImage(for description: WeatherDescription, sunrise: Int, sunset: Int, hourOfCountry: Int) -> [String] {
        var weatherImage = [String]()
        
        switch description {
            case .clearSky:
                if hourOfCountry >= sunrise && hourOfCountry <= sunset {
                    weatherImage = imagesByDescription(background: .clearSkyDay, icon: .clearSkyDay, personna: .clearSky)
                } else {
                    weatherImage = imagesByDescription(background: .clearSkyNight, icon: .clearSkyNight, personna: .clearSky)
                }
            case .fewClouds:
                if hourOfCountry >= sunrise && hourOfCountry <= sunset {
                    weatherImage = imagesByDescription(background: .fewCloudsDay, icon: .fewCloudsDay, personna: .fewClouds)
                } else {
                    weatherImage = imagesByDescription(background: .fewCloudsNight, icon: .fewCloudsNight, personna: .fewClouds)
                }
            case .scatteredClouds:
                if hourOfCountry >= sunrise && hourOfCountry <= sunset {
                    weatherImage = imagesByDescription(background: .scatteredCloudsDay, icon: .scatteredClouds, personna: .scatteredClouds)
                } else {
                    weatherImage = imagesByDescription(background: .scatteredCloudsNight, icon: .scatteredClouds, personna: .scatteredClouds)
                }
            case .brokenClouds:
                if hourOfCountry >= sunrise && hourOfCountry <= sunset {
                    weatherImage = imagesByDescription(background: .brokenCloudsDay, icon: .brokenClouds, personna: .brokenClouds)
                } else {
                    weatherImage = imagesByDescription(background: .brokenCloudsNight, icon: .brokenClouds, personna: .brokenClouds)
                }
            case .overcastCloud:
                if hourOfCountry >= sunrise && hourOfCountry <= sunset {
                    weatherImage = imagesByDescription(background: .overcastCloudsDay, icon: .brokenClouds, personna: .brokenClouds)
                } else {
                    weatherImage = imagesByDescription(background: .overcastCloudsNight, icon: .brokenClouds, personna: .brokenClouds)
                }
            case .showerRain:
                if hourOfCountry >= sunrise && hourOfCountry <= sunset {
                    weatherImage = imagesByDescription(background: .rainDay, icon: .rain, personna: .brokenClouds)
                } else {
                    weatherImage = imagesByDescription(background: .rainNight, icon: .rain, personna: .brokenClouds)
                }
            case .lightRain:
                if hourOfCountry >= sunrise && hourOfCountry <= sunset {
                    weatherImage = imagesByDescription(background: .lightRainDay, icon: .lightRain, personna: .brokenClouds)
                } else {
                    weatherImage = imagesByDescription(background: .lightRainNight, icon: .lightRain, personna: .brokenClouds)
                }
            case .moderateRain:
                if hourOfCountry >= sunrise && hourOfCountry <= sunset {
                    weatherImage = imagesByDescription(background: .moderateRainDay, icon: .lightRain, personna: .brokenClouds)
                } else {
                    weatherImage = imagesByDescription(background: .moderateRainNight, icon: .lightRain, personna: .brokenClouds)
                }
            case .rain:
                if hourOfCountry >= sunrise && hourOfCountry <= sunset {
                    weatherImage = imagesByDescription(background: .rainDay, icon: .thunderstorm, personna: .rain)
                } else {
                    weatherImage = imagesByDescription(background: .rainNight, icon: .thunderstorm, personna: .rain)
                }
            case .thunderstorm:
                if hourOfCountry >= sunrise && hourOfCountry <= sunset {
                    weatherImage = imagesByDescription(background: .thunderstormDay, icon: .thunderstorm, personna: .thunderstorm)
                } else {
                    weatherImage = imagesByDescription(background: .thunderstormNight, icon: .thunderstorm, personna: .thunderstorm)
                }
            case .snow:
                if hourOfCountry >= sunrise && hourOfCountry <= sunset {
                    weatherImage = imagesByDescription(background: .snowDay, icon: .snow, personna: .snow)
                } else {
                    weatherImage = imagesByDescription(background: .snowNight, icon: .snow, personna: .snow)
                }
            case .mist:
                if hourOfCountry >= sunrise && hourOfCountry <= sunset {
                    weatherImage = imagesByDescription(background: .mistDay, icon: .mist , personna: .mist)
                } else {
                    weatherImage = imagesByDescription(background: .mistNight, icon: .mist, personna: .mist)
                }
        }
        return weatherImage
    }
    
    static private func imagesByDescription(background: ImagesWeather.Background, icon: ImagesWeather.Icon, personna: ImagesWeather.Perso) -> [String] {
        let imageBackground = background.rawValue
        let imageIcon = icon.rawValue
        let imagePersonna = personna.rawValue

        print(imageBackground)
        print(imageIcon)
        print(imagePersonna)

        return [imageBackground, imageIcon, imagePersonna]
    }
}
