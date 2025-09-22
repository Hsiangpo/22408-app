import SwiftUI

struct DeckView: View {
    @EnvironmentObject private var env: AppEnvironment
    @State private var cards: [DeckCard] = []
    @State private var index: Int = 0
    @State private var showBack = false

    var body: some View {
        VStack(spacing: 24) {
            if cards.isEmpty {
                ContentUnavailableView("速记卡已空", systemImage: "sparkles")
                    .task(load)
            } else {
                let card = cards[index]
                VStack(spacing: 16) {
                    Text(card.front ?? "")
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                    if showBack {
                        Divider()
                        Text(card.back ?? "")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                Spacer()
                HStack {
                    Button(showBack ? "隐藏答案" : "查看答案") {
                        withAnimation { showBack.toggle() }
                    }
                    .buttonStyle(.bordered)
                    Button("记住") { advance(.correct) }
                        .buttonStyle(.borderedProminent)
                    Button("再练") { advance(.wrong) }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                }
            }
        }
        .padding()
        .navigationTitle("速记卡")
    }

    private func load() {
        let request = DeckCard.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "srsDueDate", ascending: true)]
        cards = (try? env.coreDataStack.viewContext.fetch(request)) ?? []
        index = 0
        showBack = false
    }

    private func advance(_ result: ReviewResult) {
        guard !cards.isEmpty else { return }
        let card = cards[index]
        let state = SrsState(ease: card.srsEase, interval: max(1, Int(card.srsInterval)), dueDate: card.srsDueDate, lapses: Int(card.srsLapses))
        let next = env.srsScheduler.nextState(from: state, result: result)
        card.srsEase = next.ease
        card.srsInterval = Int32(next.interval)
        card.srsDueDate = next.dueDate
        card.srsLapses = Int16(next.lapses)
        card.streak = result == .correct ? card.streak + 1 : 0
        try? env.coreDataStack.viewContext.save()
        if index < cards.count - 1 {
            index += 1
            showBack = false
        } else {
            load()
        }
    }
}
