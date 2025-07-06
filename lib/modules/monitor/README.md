# Monitor 模块

## 概述

Monitor 模块负责处理智能卡片（SmartCards）数据的展示，包括聪明钱和KOL两种类型的数据。

## 目录结构

```
lib/modules/monitor/
├── monitor_page.dart          # 主页面
├── widgets/                   # 组件目录
│   ├── category_tabbar.dart   # 分类标签栏
│   ├── filter_bar.dart        # 筛选栏
│   ├── smart_money_card.dart  # 智能卡片组件
│   └── wallet_item.dart       # 钱包项组件
└── README.md                  # 本文件
```

## 数据模型

### SmartCardsResponse
智能卡片响应模型，包含：
- `code`: 响应状态码
- `reason`: 响应原因
- `message`: 响应消息
- `data`: 数据内容

### SmartCardsData
智能卡片数据模型，包含：
- `cards`: 卡片列表
- `total`: 总数
- `page`: 当前页码
- `pageSize`: 每页大小

### SmartCard
单个卡片模型，包含：
- `symbol`: 代币符号
- `name`: 代币名称
- `logo`: 代币图标
- `address`: 合约地址
- `price`: 当前价格
- `priceChange24h`: 24小时价格变化
- `priceChangePercent24h`: 24小时价格变化百分比
- `volume24h`: 24小时交易量
- `marketCap`: 市值
- `liquidity`: 流动性
- `holderCount`: 持有人数量
- `buyCount`: 买入次数
- `sellCount`: 卖出次数
- `netInflow`: 净流入
- `wallets`: 钱包信息列表
- `timeInfo`: 时间信息
- `createdTimestamp`: 创建时间戳

### WalletInfo
钱包信息模型，包含：
- `name`: 钱包名称
- `address`: 钱包地址
- `amount`: 金额
- `flow`: 流量
- `trades`: 交易信息
- `people`: 人数
- `timeInfo`: 时间信息

## API 接口

### 获取智能卡片数据
```dart
Future<SmartCardsResponse> fetchSmartCards({
  required String type,      // 类型：'sol' 或 'kol'
  required String timeframe, // 时间范围：'24h'
  Map<String, dynamic>? extraParams,
})
```

### 获取SOL类型数据
```dart
Future<SmartCardsResponse> fetchSolSmartCards({
  String timeframe = '24h',
  Map<String, dynamic>? extraParams,
})
```

### 获取KOL类型数据
```dart
Future<SmartCardsResponse> fetchKolSmartCards({
  String timeframe = '24h',
  Map<String, dynamic>? extraParams,
})
```

## 使用方法

### 1. 在页面中使用
```dart
import 'package:gmgn_front/data/repositories/monitor_repository.dart';
import 'package:gmgn_front/data/models/monitor_models.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final MonitorRepository _repository = MonitorRepository();
  SmartCardsResponse? _data;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      _data = await _repository.fetchSolSmartCards(timeframe: '24h');
    } catch (e) {
      print('加载失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator();
    }

    return ListView.builder(
      itemCount: _data?.data.cards.length ?? 0,
      itemBuilder: (context, index) {
        final card = _data!.data.cards[index];
        return ListTile(
          title: Text(card.name),
          subtitle: Text(card.symbol),
        );
      },
    );
  }
}
```

### 2. 数据展示
```dart
// 显示卡片信息
Text('名称: ${card.name}');
Text('符号: ${card.symbol}');
Text('价格: \$${card.price.toStringAsFixed(2)}');
Text('24h涨跌幅: ${card.priceChangePercent24h.toStringAsFixed(2)}%');

// 显示钱包信息
for (final wallet in card.wallets) {
  Text('钱包: ${wallet.name}');
  Text('地址: ${wallet.address}');
  Text('金额: \$${wallet.amount.toStringAsFixed(2)}');
}
```

## 错误处理

模块包含完整的错误处理机制：
- 网络请求失败时显示错误信息
- 数据为空时显示空状态
- 加载中显示加载指示器
- 支持下拉刷新重新加载数据

## 测试

运行测试脚本验证API调用：
```bash
cd gmgn_front
dart test_monitor_api.dart
```

## 注意事项

1. 确保后端服务器正在运行
2. 检查网络连接和API地址配置
3. 数据模型字段与后端API响应保持一致
4. 图片URL需要完整的服务器地址 