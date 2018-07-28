//
//  NavigateMapAppProtocol.swift
//  YSMapNavigation
//
//  Created by Yuns on 2018/7/26.
//  Copyright © 2018年 Yuns. All rights reserved.
//

import Foundation
import MapKit

/// 导航方式
///
/// - walking: 步行
/// - driving: 驾车
enum NavigateMapRouteType {
    case walking
    case driving
}

/// 导航参数
struct NavigateMapParams {
    var lat: Double = 0.0
    var lng: Double = 0.0
    var name: String = ""
}

/// 统一入口：调用地图app进行导航
protocol NavigateMapAppProtocol: NavigateMapAppAble {
    
    func navigateUserToDestination(map: NavigateMapType, route: NavigateMapRouteType, params: NavigateMapParams)
}

extension NavigateMapAppProtocol {
    func navigateUserToDestination(map: NavigateMapType, route: NavigateMapRouteType, params: NavigateMapParams) {
        switch map {
        case .aMap: aMapNavigate(route: route, params: params)
        case .baiduMap: baiduMapNavigate(route: route, params: params)
        case .qqMap: qqMapNavigate(route: route, params: params)
        default: appleMapNavigate(route: route, params: params)
        }
    }
}

/// 调用指定地图app进行导航
protocol NavigateMapAppAble {
    func appleMapNavigate(route: NavigateMapRouteType, params: NavigateMapParams)
    func aMapNavigate(route: NavigateMapRouteType, params: NavigateMapParams)
    func baiduMapNavigate(route: NavigateMapRouteType, params: NavigateMapParams)
    func qqMapNavigate(route: NavigateMapRouteType, params: NavigateMapParams)
    
    func otherMapNavigate(secheme: String)
}

extension NavigateMapAppAble {
    func appleMapNavigate(route: NavigateMapRouteType, params: NavigateMapParams) {
        // 配置参数
        let currentItem = MKMapItem.forCurrentLocation()
        let toLoc = CLLocationCoordinate2DMake(params.lat, params.lng)
        let toMark = MKPlacemark(coordinate: toLoc, addressDictionary: nil)
        let toItem = MKMapItem(placemark: toMark)
        toItem.name = params.name
        
        // 调用导航
        switch route {
        case .driving:
            MKMapItem.openMaps(with: [currentItem, toItem], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: NSNumber.init(value: MKMapType.standard.rawValue), MKLaunchOptionsShowsTrafficKey: NSNumber.init(value: true)])
        case .walking:
            MKMapItem.openMaps(with: [currentItem, toItem], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking, MKLaunchOptionsMapTypeKey: NSNumber.init(value: MKMapType.standard.rawValue)])
        }
    }
    
    func aMapNavigate(route: NavigateMapRouteType, params: NavigateMapParams) {
        var secheme: String?
        /*
         t = 0 驾车；
         t = 1 公交；
         t = 2 步行
         */
        switch route {
        case .driving:
            secheme = "iosamap://path?sourceApplication=众行EVPOP&dlat=\(params.lat)&dlon=\(params.lng)&dname=\(params.name)&dev=0&t=0"
        case .walking:
            secheme = "iosamap://path?sourceApplication=众行EVPOP&dlat=\(params.lat)&dlon=\(params.lng)&dname=\(params.name)&dev=0&t=2"
        }
        
        if let secheme = secheme {
            otherMapNavigate(secheme: secheme)
        }
    }
    
    func baiduMapNavigate(route: NavigateMapRouteType, params: NavigateMapParams) {
        var secheme: String?
        switch route {
        case .driving:
            secheme = "baidumap://map/direction?origin=我的位置&destination=latlng:\(params.lat),\(params.lng)|name:\(params.name)&mode=driving&src=众行EVPOP"
        case .walking:
            secheme = "baidumap://map/direction?origin=我的位置&destination=latlng:\(params.lat),\(params.lng)|name:\(params.name)&mode=walking&src=众行EVPOP"
        }
        
        if let secheme = secheme {
            otherMapNavigate(secheme: secheme)
        }
    }
    
    func qqMapNavigate(route: NavigateMapRouteType, params: NavigateMapParams) {
        var secheme: String?
        switch route {
        case .driving:
            secheme = "qqmap://map/routeplan?type=drive&from=我的位置&to=\(params.name)&tocoord=\(params.lat),\(params.lng)&referer=众行EVPOP"
        case .walking:
            secheme = "qqmap://map/routeplan?type=walk&from=我的位置&to=\(params.name)&tocoord=\(params.lat),\(params.lng)&referer=众行EVPOP"
        }
        
        if let secheme = secheme {
            otherMapNavigate(secheme: secheme)
        }
    }
    
    func otherMapNavigate(secheme: String) {
        let schemeStr = secheme.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let schemeURL = URL(string: schemeStr)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(schemeURL, options: NSDictionary() as! [String: Any], completionHandler: { (_) in
                print("地图scheme调用结束")
            })
        } else {
            UIApplication.shared.canOpenURL(schemeURL)
        }
    }
}
