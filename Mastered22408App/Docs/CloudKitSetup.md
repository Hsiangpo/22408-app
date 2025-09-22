# CloudKit 开启指引

1. 在 Xcode `Signing & Capabilities` 中启用 `iCloud`，勾选 `CloudKit`。
2. 将 `CoreDataStack` 中的 `NSPersistentContainer` 替换为 `NSPersistentCloudKitContainer`，为 store 描述设置 `NSPersistentCloudKitContainerOptions`。
3. 更新 `Entitlements`，开启 `iCloud` 并配置 container identifier，例如 `iCloud.com.example.mastered22408`。
4. 初始化时调用 `CloudKitToggle.enableMirroring(for:)`，并处理 `NSPersistentCloudKitContainer` 事件（如导入冲突）。
5. 在设置页提供开关，明确提示用户：
   - 需要登录同一 Apple ID
   - CloudKit 数据受苹果配额限制，首次同步可能较慢
   - 所有图片同样会上传，建议压缩
6. 通过 TestFlight 验证多设备同步，关注冲突处理是否符合预期。
