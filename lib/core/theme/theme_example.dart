import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

/// 主题切换示例页面
class ThemeExample extends StatelessWidget {
  const ThemeExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('主题切换示例'),
        actions: [
          // 主题切换按钮
          Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, child) {
              return IconButton(
                icon: Icon(
                  themeNotifier.isDark ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => themeNotifier.toggleTheme(),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 主题状态显示
            Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '当前主题',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          themeNotifier.isDark ? '暗色模式' : '亮色模式',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // 主题切换控制
            Text(
              '主题控制',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            
            Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) {
                return Column(
                  children: [
                    // 开关控制
                    SwitchListTile(
                      title: const Text('暗色模式'),
                      subtitle: const Text('切换亮色/暗色主题'),
                      value: themeNotifier.isDark,
                      onChanged: (value) => themeNotifier.setDark(value),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 按钮控制
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => themeNotifier.setLight(),
                            child: const Text('亮色模式'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => themeNotifier.setDarkMode(),
                            child: const Text('暗色模式'),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 切换按钮
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => themeNotifier.toggleTheme(),
                        child: const Text('切换主题'),
                      ),
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // 主题预览
            Text(
              '主题预览',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            
            // 卡片预览
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '卡片标题',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '这是一个卡片示例，展示了当前主题的样式效果。包括背景色、文字颜色、阴影等。',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('主要按钮'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('次要按钮'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 输入框预览
            TextField(
              decoration: InputDecoration(
                labelText: '输入框示例',
                hintText: '请输入内容',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 列表预览
            Card(
              child: Column(
                children: List.generate(3, (index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text('列表项 ${index + 1}'),
                    subtitle: Text('这是第 ${index + 1} 个列表项的详细描述'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 