import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var env: AppEnvironment
    @State private var notificationTime: Date = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()

    var body: some View {
        Form {
            Section("智能模块") {
                Toggle("启用 Mathpix OCR", isOn: .isMathpixEnabled)
                Toggle("启用 LLM 辅助", isOn: .isLLMEnabled)
            }
            Section("每日提醒") {
                DatePicker("提醒时间", selection: , displayedComponents: .hourAndMinute)
                Button("保存提醒") {
                    let comps = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
                    env.notificationScheduler.scheduleDaily(subject: "综合", hour: comps.hour ?? 20, minute: comps.minute ?? 0)
                }
            }
            Section("导出") {
                Button("导出 CSV") {
                    // TODO: 实现导出逻辑
                }
                Button("导出 JSON") {
                }
            }
            Section(footer: Text("数据默认仅保存在本地，开启云同步前请先阅读 README/CloudKitSetup.md")) {
                Button("查看隐私说明") {
                    // 可引导至文档
                }
            }
        }
        .navigationTitle("设置")
    }
}
