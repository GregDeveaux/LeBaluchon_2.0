//
//  UIImageView+WeatherImage.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 01/12/2022.
//

import UIKit

extension UIImageView {

    enum Description: String {
        case clearSky = "clear sky"
        case fewClouds = "few clouds"
        case scatteredClouds = "scattered clouds"
        case brokenClouds = "broken clouds"
        case showerRain = "shower rain"
        case rain
        case thunderstorm
        case snow = "light snow"
        case mist
    }

    static func weatherImage(for description: Description.RawValue, sunrise: Int, sunset: Int, hourOfContry: Int) -> [UIImageView] {
        var weatherImage = [UIImageView]()

        switch description {
        case "clear sky":
            if hourOfContry >= sunrise && hourOfContry <= sunset {
                weatherImage = imagesByDescription(background: "veryLittleCloud", icone: "sun.max.fill", personna: "perso1")
            } else {
                weatherImage = imagesByDescription(background: "skyNight", icone: "moon.stars", personna: "perso1")
            }

        case "few clouds":
            if hourOfContry >= sunrise && hourOfContry <= sunset {
                weatherImage = imagesByDescription(background: "veryLittleCloud", icone: "cloud.sun.fill", personna: "perso1")
            } else {
                weatherImage = imagesByDescription(background: "littleCloudyByNight", icone: "cloud.moon.fill", personna: "perso1")
            }

        case "scattered clouds":
            if hourOfContry >= sunrise && hourOfContry <= sunset {
                weatherImage = imagesByDescription(background: "littleCloudy", icone: "cloud.fill", personna: "CloudCool")
            } else {
                weatherImage = imagesByDescription(background: "littleCloudyByNight", icone: "cloud.fill", personna: "CloudCool")
            }

        case "broken clouds":
            if hourOfContry >= sunrise && hourOfContry <= sunset {
                weatherImage = imagesByDescription(background: "cloudyPower2", icone: "smoke.fill", personna: "CloudCool")
            } else {
                weatherImage = imagesByDescription(background: "CloudyByNight", icone: "smoke.fill", personna: "CloudCool")
            }

        case "shower rain":
            if hourOfContry >= sunrise && hourOfContry <= sunset {
                weatherImage = imagesByDescription(background: "rainByDay", icone: "cloud.rain.fill", personna: "CloudThunder")
            } else {
                weatherImage = imagesByDescription(background: "rainByNight", icone: "cloud.rain.fill", personna: "CloudThunder")
            }

        case "rain":
            if hourOfContry >= sunrise && hourOfContry <= sunset {
                weatherImage = imagesByDescription(background: "rainByDay", icone: "cloud.rain.fill", personna: "CloudThunder")
            } else {
                weatherImage = imagesByDescription(background: "rainByNight", icone: "cloud.rain.fill", personna: "CloudThunder")
            }

        case "thunderstorm":
            if hourOfContry >= sunrise && hourOfContry <= sunset {
                weatherImage = imagesByDescription(background: "stormByDay", icone: "cloud.bolt.rain.fill", personna: "CloudThunder")
            } else {
                weatherImage = imagesByDescription(background: "stormByNight", icone: "cloud.bolt.rain.fill", personna: "CloudThunder")
            }

        case "light snow":
            if hourOfContry >= sunrise && hourOfContry <= sunset {
                weatherImage = imagesByDescription(background: "snowByDay", icone: "cloud.snow.fill", personna: "CloudCool")
            } else {
                weatherImage = imagesByDescription(background: "snowByNight", icone: "cloud.snow.fill", personna: "CloudCool")
            }

        case "mist":
            if hourOfContry >= sunrise && hourOfContry <= sunset {
                weatherImage = imagesByDescription(background: "cloudyPower0", icone: "cloud.fog.fill", personna: "CloudCool")
            } else {
                weatherImage = imagesByDescription(background: "CloudyByNight", icone: "cloud.fog.fill", personna: "CloudCool")
            }
            default:
                break
        }
        return weatherImage
    }

    static private func imagesByDescription(background: String, icone: String, personna: String) -> [UIImageView] {
        let imageBackground = UIImageView(image: UIImage(named: background))
        let imageIcone = UIImageView(image: UIImage(named: icone))
        let imagePersonna = UIImageView(image: UIImage(named: personna))

        return [imageBackground, imageIcone, imagePersonna]
    }
}
