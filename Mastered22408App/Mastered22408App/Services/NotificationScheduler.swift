import UserNotifications

final class NotificationScheduler {
    func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    @discardableResult
    func registerCategories() async {
        let start = UNNotificationAction(identifier: "start", title: "开始练", options: [.foreground])
        let later = UNNotificationAction(identifier: "later", title: "稍后", options: [])
        let category = UNNotificationCategory(identifier: "REVIEW", actions: [start, later], intentIdentifiers: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    func scheduleDaily(subject: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "今日复习：\(subject)"
        content.body = "抽空完成今日错题复盘。"
        content.sound = .default
        content.categoryIdentifier = "REVIEW"
        var date = DateComponents()
        date.hour = hour
        date.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "review-\(subject)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
