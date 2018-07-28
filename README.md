# YSMapNavigation
一句代码调用地图导航（可根据需求自由扩展）

## 使用步骤

1、在plist中添加`LSApplicationQueriesSchemes(Array)`，并添加`item0、item1`(默认支持Apple地图、高德地图、腾讯地图、百度地图)

2、遵守`NavigateMapAlertProvider`协议，并实现协议中的方法

```
navigateAlertUserToDestination(route: NavigateMapRouteType, params: NavigateMapParams, rootVC: UIViewController?)
```