import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var environment: AppEnvironment

    var body: some View {
        TabView {
            NavigationStack {
                TodayTrainingView()
            }
            .tabItem {
                Label("今日", systemImage: "sun.max")
            }

            NavigationStack {
                ProblemLibraryView()
            }
            .tabItem {
                Label("错题库", systemImage: "books.vertical")
            }

            NavigationStack {
                DeckView()
            }
            .tabItem {
                Label("速记", systemImage: "bolt.fill")
            }

            NavigationStack {
                StatisticsView()
            }
            .tabItem {\n                Label("统计", systemImage: "chart.bar")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("设置", systemImage: "gearshape")
            }
        }
        .task {
            await environment.notificationScheduler.registerCategories()
        }
    }
}
