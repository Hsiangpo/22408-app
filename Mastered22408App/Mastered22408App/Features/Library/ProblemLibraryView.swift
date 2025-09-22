import SwiftUI

struct ProblemLibraryView: View {
    @EnvironmentObject private var env: AppEnvironment
    @State private var filter = ProblemFilter()
    @State private var problems: [Problem] = []
    @State private var searchText: String = ""

    var body: some View {
        List {
            ForEach(problems) { problem in
                NavigationLink(value: problem.objectID) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(problem.questionText ?? "图像题")
                            .font(.headline)
                        HStack(spacing: 8) {
                            Text(problem.subject)
                            if let chapter = problem.chapter { Text(chapter) }
                            Text("难度\(problem.difficulty)")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        Text("下次复习：\(problem.srsDueDate, formatter: DateFormatter.review)")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("错题库")
        .searchable(text: )
        .onChange(of: searchText) { text in
            filter.searchKeyword = text
            load()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Picker("科目", selection: Binding(
                        get: { filter.subject ?? "全部" },
                        set: { filter.subject = ( == "全部" ? nil : ); load() }
                    )) {
                        Text("全部").tag("全部")
                        ForEach(SampleDataLoader.shared.subjects, id: \.self) { subject in
                            Text(subject).tag(subject)
                        }
                    }
                } label: {
                    Label("筛选", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .task(load)
    }

    private func load() {
        problems = (try? env.problemRepository.fetchAll(filter: filter)) ?? []
    }
}

private extension DateFormatter {
    static let review: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
