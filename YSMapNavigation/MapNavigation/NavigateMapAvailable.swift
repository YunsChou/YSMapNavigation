//
//  NavigateMapAvailable.swift
//  YSMapNavigation
//
//  Created by Yuns on 2018/7/26.
//  Copyright © 2018年 Yuns. All rights reserved.
//

import UIKit

/// 导航类型
///
/// - aMap: 高德地图
/// - baiduMap: 百度地图
/// - qqMap: 腾讯地图
/// - appleMap: 苹果地图
enum NavigateMapType: String {
    case aMap       = "高德地图"
    case baiduMap   = "百度地图"
    case qqMap      = "腾讯地图"
    case appleMap   = "苹果地图"
}

/// 检测手机可用地图app
protocol NavigateAvailable {
    func navigateAvailableMapType() -> [NavigateMapType]
}

extension NavigateAvailable {
    func navigateAvailableMapType() -> [NavigateMapType] {
        var types = [NavigateMapType]()
        let isInstallGaode = UIApplication.shared.canOpenURL(URL(string: "iosamap://")!)
        let isInstallTencent = UIApplication.shared.canOpenURL(URL(string: "qqmap://")!)
        let isInstallBaidu = UIApplication.shared.canOpenURL(URL(string: "baidumap://")!)
        let isInstallApple = UIApplication.shared.canOpenURL(URL(string: "http://maps.apple.com/")!)
        if isInstallGaode == true { types.append(.aMap) }
        if isInstallBaidu == true { types.append(.baiduMap) }
        if isInstallTencent == true { types.append(.qqMap) }
        if isInstallApple == true { types.append(.appleMap) }
        return types
    }
}
