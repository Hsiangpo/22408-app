import SwiftUI

struct TodayTrainingView: View {
    @EnvironmentObject private var env: AppEnvironment
    @State private var queue: [Problem] = []
    @State private var index: Int = 0
    @State private var isAnswerVisible = false
    @State private var note = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if queue.isEmpty {
                ContentUnavailableView("今日任务完成！", systemImage: "checkmark.seal")
                    .task(loadQueue)
            } else {
                let problem = queue[index]
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(problem.questionText ?? "图像题")
                            .font(.title2)
                        if !problem.imagePaths.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(problem.imagePaths, id: \.self) { path in
                                        if let url = URL(string: path) {
                                            AsyncImage(url: url) { image in
                                                image.resizable()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 140, height: 140)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                        }
                                    }
                                }
                            }
                        }
                        Button(isAnswerVisible ? "隐藏答案" : "查看答案") {
                            withAnimation { isAnswerVisible.toggle() }
                        }
                        if isAnswerVisible {
                            Text(problem.answerText ?? "尚未整理答案")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.bottom, 12)
                }
                Divider()
                TextField("复做备注", text: , prompt: Text("可选"))
                    .textFieldStyle(.roundedBorder)
                HStack {
                    Button(role: .destructive) {
                        record(.wrong)
                    } label: { Label("做错", systemImage: "xmark.circle") }
                    .buttonStyle(.borderedProminent)

                    Button {
                        record(.correct)
                    } label: { Label("做对", systemImage: "checkmark.circle") }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
        .navigationTitle("今日复习")
        .toolbar {
            Button("刷新", action: loadQueue)
        }
    }

    private func loadQueue() {
        let now = Date()
        let due = (try? env.problemRepository.fetchDueProblems(on: now)) ?? []
        queue = due.sorted { env.srsScheduler.scoring(for: , reference: now) > env.srsScheduler.scoring(for: , reference: now) }
        index = 0
        isAnswerVisible = false
        note = ""
    }

    private func record(_ result: ReviewResult) {
        guard !queue.isEmpty else { return }
        let current = queue[index]
        let state = SrsState(
            ease: current.srsEase,
            interval: max(1, Int(current.srsInterval)),
            dueDate: current.srsDueDate,
            lapses: Int(current.srsLapses)
        )
        let next = env.srsScheduler.nextState(from: state, result: result)
        try? env.problemRepository.updateSRS(id: current.id, state: next)
        env.problemRepository.logReview(problemId: current.id, result: result, duration: 0, note: note.isEmpty ? nil : note)
        note = ""
        isAnswerVisible = false
        if index < queue.count - 1 {
            index += 1
        } else {
            loadQueue()
        }
    }
}
