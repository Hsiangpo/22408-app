import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject private var env: AppEnvironment
    @State private var dailySeries: [DailyReview] = []
    @State private var accuracy: Double = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("最近正确率")
                        .font(.headline)
                    ProgressView(value: accuracy) {
                        Text("当前正确率" )
                    }
                    .progressViewStyle(.linear)
                    Text("\(Int(accuracy * 100))%")
                        .font(.title)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("近30天复习走势")
                        .font(.headline)
                    Chart(dailySeries) { series in
                        LineMark(
                            x: .value("日期", series.date),
                            y: .value("数量", series.count)
                        )
                        PointMark(
                            x: .value("日期", series.date),
                            y: .value("数量", series.count)
                        )
                    }
                    .frame(height: 200)
                }
            }
            .padding()
        }
        .navigationTitle("统计")
        .task(load)
    }

    private func load() {
        let logs = (try? env.reviewLogRepository.recentLogs(limit: 200)) ?? []
        if logs.isEmpty {
            dailySeries = []
            accuracy = 0
            return
        }
        let groups = Dictionary(grouping: logs) { log in
            Calendar.current.startOfDay(for: log.timestamp)
        }
        dailySeries = groups.map { DailyReview(date: .key, count: .value.count) }
            .sorted { .date < .date }
        let correct = logs.filter { .result == .correct }.count
        accuracy = Double(correct) / Double(logs.count)
    }
}

struct DailyReview: Identifiable {
    let date: Date
    let count: Int
    var id: Date { date }
}
