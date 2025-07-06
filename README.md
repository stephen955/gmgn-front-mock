# GMGN.AI Demo - Flutter 区块链监控应用

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.1-blue.svg)](https://dart.dev/)
[![Cursor](https://img.shields.io/badge/Built%20with-Cursor-purple.svg)](https://cursor.sh/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 项目简介

这是一个使用 **Cursor AI** 复刻的 **GMGN.AI** 区块链智能监控应用demo。项目基于 Flutter 开发，专注于提供实时的区块链数据监控、智能交易分析和钱包管理功能。应用支持多链操作，包括 Solana、BSC 等主流区块链网络。

### 🎯 项目目标
- 复刻 GMGN.AI 的核心功能和用户体验
- 展示 Flutter 在区块链应用开发中的最佳实践
- 提供完整的移动端区块链监控解决方案

## ✨ 主要功能

### 🔍 智能监控 (Monitor)
- **聪明钱监控**: 实时追踪大户钱包的交易活动
- **KOL监控**: 监控知名交易者的投资动向
- **狙击新币监控**: 及时发现新币种的投资机会
- **智能卡片**: 直观展示代币信息和交易数据

### 📊 市场数据 (Market)
- 实时价格走势图表
- 交易量统计和市场深度
- 多维度筛选和排序功能
- 相关新闻和市场分析

### 🏆 排行榜 (Track)
- 交易者排行榜
- 代币表现排行榜
- 历史数据追踪

### 💰 资产管理 (Asset)
- 多链钱包支持
- 资产余额查看
- 交易历史记录
- 投资组合分析

### 🔐 用户认证
- 邮箱注册/登录
- 安全令牌管理
- 用户偏好设置

## 🛠 技术栈

### 开发工具
- **Cursor AI** - AI驱动的代码编辑器，用于快速开发和代码生成
- **Flutter 3.8.1** - 跨平台UI框架
- **Dart 3.8.1** - 编程语言

### 状态管理
- **flutter_bloc** - BLoC模式状态管理
- **provider** - 依赖注入和状态管理

### 网络和API
- **dio** - HTTP客户端
- **retrofit** - REST API客户端生成
- **cached_network_image** - 图片缓存

### 路由导航
- **auto_route** - 类型安全的路由管理

### 区块链集成
- **web3dart** - Ethereum区块链交互
- **solana** - Solana区块链交互
- **bip39** - 助记词生成
- **ed25519_hd_key** - HD钱包支持

### 本地存储
- **shared_preferences** - 本地数据存储
- **flutter_secure_storage** - 安全存储

### UI组件
- **flutter_svg** - SVG图标支持
- **pull_to_refresh** - 下拉刷新
- **syncfusion_flutter_charts** - 图表组件

### 国际化
- **intl** - 国际化支持
- **flutter_localizations** - Flutter本地化

## 📁 项目结构

```
lib/
├── app.dart                 # 应用入口和配置
├── main.dart               # 主函数
├── core/                   # 核心功能
│   ├── config/            # 配置文件
│   ├── network/           # 网络相关
│   ├── theme/             # 主题配置
│   └── utils/             # 工具类
├── data/                  # 数据层
│   ├── models/            # 数据模型
│   └── repositories/      # 数据仓库
├── modules/               # 功能模块
│   ├── auth/             # 认证模块
│   ├── discover/         # 发现模块
│   ├── monitor/          # 监控模块
│   ├── market/           # 市场模块
│   ├── track/            # 排行榜模块
│   ├── asset/            # 资产管理模块
│   └── wallet/           # 钱包模块
├── router/               # 路由配置
│   ├── app_router.dart   # 主路由
│   └── guards/           # 路由守卫
├── shared/               # 共享组件
│   ├── styles/           # 样式定义
│   ├── utils/            # 工具函数
│   └── widgets/          # 共享组件
└── l10n/                 # 国际化资源
```

## 🚀 快速开始

### 环境要求

- **Cursor AI** - 推荐使用 Cursor 编辑器以获得最佳开发体验
- Flutter SDK: 3.8.1 或更高版本
- Dart SDK: 3.8.1 或更高版本
- Android Studio / VS Code
- iOS开发需要 macOS 和 Xcode

### 安装步骤

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd gmgn_front
   ```

2. **使用 Cursor 打开项目**
   ```bash
   cursor gmgn_front
   ```

3. **安装依赖**
   ```bash
   flutter pub get
   ```

4. **生成代码**
   ```bash
   flutter pub run build_runner build
   ```

5. **运行应用**
   ```bash
   # 调试模式
   flutter run
   
   # 发布模式
   flutter run --release
   ```

### 平台特定设置

#### Android
- 确保 Android SDK 已安装
- 在 `android/app/build.gradle` 中配置应用信息

#### iOS
- 确保 Xcode 已安装
- 运行 `cd ios && pod install` 安装依赖

#### Web
- 启用 Web 支持: `flutter config --enable-web`
- 运行: `flutter run -d chrome`

## 🔧 开发指南

### 使用 Cursor AI 开发
本项目使用 **Cursor AI** 进行开发

### 代码生成
项目使用代码生成来创建路由、模型和API客户端：

```bash
# 生成所有代码
flutter pub run build_runner build

# 监听文件变化自动生成
flutter pub run build_runner watch
```

### 添加新页面
1. 在 `lib/modules/` 下创建新模块
2. 在 `lib/router/app_router.dart` 中添加路由
3. 运行代码生成命令

### 添加新依赖
1. 在 `pubspec.yaml` 中添加依赖
2. 运行 `flutter pub get`
3. 如果需要代码生成，运行 `flutter pub run build_runner build`


## 📱 构建发布

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🧪 测试

### 单元测试
```bash
flutter test
```

### 集成测试
```bash
flutter test integration_test/
```

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。


## 📝 项目说明

这是一个使用 **Cursor AI** 复刻的 **GMGN.AI** Flutter 项目，主要用于学习和展示 

---

**注意**: 这是一个金融相关应用，请在使用前充分了解相关风险。投资有风险，入市需谨慎。
# gmgn-front-mock
