//
//  NavigateMapAlertProvider.swift
//  YSMapNavigation
//
//  Created by Yuns on 2018/7/26.
//  Copyright © 2018年 Yuns. All rights reserved.
//

import UIKit
import CoreLocation

/// 一句话集成地图弹窗和调用地图导航
protocol NavigateMapAlertProvider: NavigateMapAppProtocol, NavigateAvailable {
    func navigateAlertUserToDestination(route: NavigateMapRouteType, params: NavigateMapParams, rootVC: UIViewController?)
}

extension NavigateMapAlertProvider {
    func navigateAlertUserToDestination(route: NavigateMapRouteType, params: NavigateMapParams, rootVC: UIViewController?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // 通过检测手机可用地图，自动创建alert个数和对应事件
        let maps = navigateAvailableMapType()
        for map in maps {
            let action = UIAlertAction(title: map.rawValue, style: .default, handler: { (_) in
                if map == .baiduMap { // 如果是百度地图，对经纬度进行一次转码
                    let gcj02 = CLLocationCoordinate2DMake(params.lat, params.lng)
                    let bd09 = LocationTransform.gcj2bd(gcjLat: gcj02.latitude, gcjLng: gcj02.longitude)
                    let baiduParams = NavigateMapParams(lat: bd09.bdLat, lng: bd09.bdLng, name: params.name)
                    self.navigateUserToDestination(map: map, route: route, params: baiduParams)
                } else {
                    self.navigateUserToDestination(map: map, route: route, params: params)
                }
            })
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancel)
        // 调起弹窗
        let VC = rootVC != nil ? rootVC : (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController
        VC?.present(alert, animated: true, completion: nil)
    }
}
