# 3d-builder（RoomPlan 原型）

目标：做一个“像 Polycam 一样”的最小可用原型——拿手机在房间扫一圈，导出房间的 3D 模型文件。

本仓库当前实现的是 **iOS + RoomPlan** 路线（RoomPlan 本身就是 Apple 的房间扫描/重建能力）。Android/无 LiDAR 的纯拍照测量（SfM/Photogrammetry）不在这个最小原型范围内。

## 运行要求

- macOS + Xcode 14+（建议 Xcode 15+）
- iOS 16+ 真机
- **带 LiDAR 的设备**（常见：iPhone Pro 系列 / iPad Pro）。没有 LiDAR 往往无法获得可用的 RoomPlan 扫描结果。

## 快速开始（直接运行）

1. 用 Xcode 打开：`ios/RoomPlanScanner/RoomPlanScanner.xcodeproj`
2. Target `RoomPlanScanner` → Signing & Capabilities：选择你的 Team（首次打开 Xcode 通常会提示你修复签名）
3. 选择真机运行（RoomPlan 需要真机 + 传感器）

说明：
- 相机权限文案已在 `ios/RoomPlanScanner/RoomPlanScanner/Info.plist` 配好（`NSCameraUsageDescription`）

## 没有 Xcode 也想装到自己手机（普通 Apple ID）

你仍然需要“某处有 Xcode”来编译生成 `.ipa`。如果本机没有 Xcode，可以用 GitHub Actions 在云端构建 **unsigned ipa**，然后在本机用工具用你的 Apple ID 重新签名并安装到真机（通常 7 天需要重装/重签）。

1. 把仓库推到 GitHub（私有仓库也可以）
2. GitHub → Actions → `Build unsigned iOS IPA (RoomPlanScanner)` → Run workflow
3. 下载产物 `RoomPlanScanner-unsigned.ipa`
4. 用以下任一工具安装到手机（会用你的 Apple ID 签名）：
   - AltStore（需要 AltServer 常驻）
   - Sideloadly

备注：RoomPlan 仍然需要 iOS 16+ 真机，且最好是带 LiDAR 的设备。

## 功能

- 开始/结束扫描（RoomPlan）
- 导出：
  - `room.usdz`（3D 模型）
  - `room.json`（结构化房间数据）
- 扫描完成后可在 App 内 QuickLook 预览 USDZ，并可系统分享导出文件

## 目录

- `ios/RoomPlanScanner/RoomPlanScanner`：SwiftUI + RoomPlan 核心代码
