# Mastered22408App

考研 22408 场景下的错题本 + 类 Anki 速记 iOS 应用 MVP。

## 功能概览
- 拍题/导入后使用 Vision OCR 抽取题面文本
- Core Data 存储题目、复习记录与速记卡
- SM-2 规则的间隔重复调度
- SwiftUI Tab 架构（今日/错题库/速记/统计/设置）
- 本地通知每日复习提醒
- 去重服务（MinHash / pHash 占位）
- 样例数据自动注入，开箱即可在模拟器运行

## 运行步骤
1. 使用 Xcode 15+ 打开 `Mastered22408App.xcodeproj`
2. 选择 iOS 17+ 模拟器或真机，执行 `⌘+R`
3. 首次运行时允许通知权限，以使用每日提醒

## 数据模型
- Problem: 题目主体，包含题/答文本、图片路径、标签、SRS 状态
- ReviewLog: 复习日志，记录时间、结果、备注
- DeckCard: 速记卡片，与 Problem 关联，共享 SRS 字段

## 目录结构
```
Mastered22408App/
├── Mastered22408App.xcodeproj       # Xcode 工程
├── Mastered22408App/                # App 源码
│   ├── CoreData/                    # Core Data 栈与实体
│   ├── Environment/                 # 依赖注入容器
│   ├── Features/                    # SwiftUI 功能模块
│   ├── Services/                    # SRS、通知、去重、OCR 封装
│   ├── Support/                     # 样例数据注入
│   ├── Model/                       # Core Data 模型文件
│   └── Assets.xcassets              # 资源占位
├── Mastered22408AppTests/           # 单元测试
└── README.md
```

## 配置项
- **Mathpix / LLM**：默认关闭，设置页提供开关。接入时可在 `AppEnvironment` 中替换 `ocrService`
- **CloudKit**：默认不启用。启用前请阅读 `Docs/CloudKitSetup.md`

## 导出/拓展
- CSV / JSON 导出接口位于 `SettingsView` 中，留有 TODO
- 可根据 `ProblemRepository` 补充批量导出逻辑

## 测试
- 运行 `Product > Test`，包含 `SrsSchedulerTests`
- 建议补充 Repository 与 OCR Mock 测试以覆盖更多用例

## 隐私声明
- 默认所有数据存储在本地 Core Data 中
- Mathpix / LLM 等联网能力需在设置页显式开启，并在首次启用前提示用途与费用

## Roadmap
- v1.0：离线错题本 + SRS + 基础统计（当前版本）
- v1.1：可选 CloudKit 同步、导出 CSV/JSON/Anki
- v2.0：Mathpix 公式识别、智能打标签、相似题聚类
