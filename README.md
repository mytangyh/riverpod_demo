# Riverpod Demo

这是一个用于演示 **Flutter Riverpod** 状态管理和 **GoRouter** 路由功能的示例项目。

项目包含多个独立的 Demo，旨在清晰地展示 Riverpod 中不同 Provider 的典型用法。

## 功能特性

- **状态管理**: 使用 [flutter_riverpod](https://riverpod.dev/) 作为核心状态管理库。
- **路由**: 使用 [go_router](https://pub.dev/packages/go_router) 管理应用内的所有页面导航。
- **主题切换**: 支持动态切换浅色/深色主题模式。
- **HTTP 请求**: 演示如何结合 `FutureProvider` 从网络 API 获取数据。
- **文本转换**: 实时将 Markdown 格式的文本转换为纯文本。
- **清晰的结构**: 项目代码按功能模块划分，易于理解和扩展。

## Demos

本项目包含以下几个核心功能的演示：

1.  **Counter Demo (`StateProvider`)**
    - 使用 `StateProvider` 管理一个简单的计数器状态。
    - 点击按钮时，计数器加一。
    - 使用 `ref.listen` 监听状态变化，并在计数值达到 5 时显示一个 SnackBar。

2.  **Todo List Demo (`NotifierProvider`)**
    - 使用 `NotifierProvider` 和 `Notifier` 来管理一个待办事项列表。
    - 支持添加、删除和切换待办事项的完成状态。
    - 演示了如何处理相对复杂的业务逻辑和状态变更。

3.  **Async Post Demo (`FutureProvider`)**
    - 使用 `FutureProvider` 从 [JSONPlaceholder](https://jsonplaceholder.typicode.com/) API 异步加载一篇文章。
    - 优雅地处理加载中、成功和错误三种状态。
    - 支持下拉刷新，通过 `ref.invalidate` 重新获取数据。

4.  **Markdown to Text Demo (`StateProvider` 和 `Provider`)**
    - 使用 `StateProvider` 保存用户输入的 Markdown 文本。
    - 使用 `Provider` 监听输入变化，并实时将其转换为纯文本。
    - 演示了 Provider 之间如何组合和依赖，实现衍生状态的计算。

## 项目结构

```
lib/
├── core/
│   ├── routing/
│   │   └── app_router.dart      # GoRouter 路由配置
│   └── theme/
│       └── theme_provider.dart  # 主题切换 (StateNotifierProvider)
│
├── features/
│   ├── demo_async_post/
│   │   ├── post_provider.dart   # FutureProvider
│   │   └── post_screen.dart     # UI
│   │
│   ├── demo_counter/
│   │   ├── counter_provider.dart# StateProvider
│   │   └── counter_screen.dart  # UI
│   │
│   ├── demo_md_to_txt/
│   │   ├── md_to_txt_provider.dart # StateProvider 和 Provider
│   │   └── md_to_txt_screen.dart   # UI
│   │
│   ├── demo_todos/
│   │   ├── models/              # 数据模型
│   │   ├── widget/              # UI 组件
│   │   ├── todos_provider.dart  # NotifierProvider
│   │   └── todos_screen.dart    # UI
│   │
│   └── home/
│       └── home_screen.dart     # 主屏幕，导航到各个 Demo
│
└── main.dart                    # 应用入口，设置 ProviderScope
```

## 依赖

- **flutter_riverpod**: 核心状态管理库。
- **go_router**: 声明式路由库。
- **http**: 用于发起网络请求。
- **uuid**: 用于生成唯一的 ID。
- **markdown**: 用于将 Markdown 转换为 HTML。

## 如何开始

这是一个标准的 Flutter 项目。克隆仓库后，运行以下命令即可启动：

```bash
# 获取依赖
flutter pub get

# 运行应用
flutter run
```
