import XCTest
@testable import Mastered22408App

final class SrsSchedulerTests: XCTestCase {
    func testCorrectIncreasesInterval() throws {
        let scheduler = SrsScheduler()
        let state = SrsState(ease: 2.5, interval: 1, dueDate: Date(), lapses: 0)
        let next = scheduler.nextState(from: state, result: .correct)
        XCTAssertGreaterThan(next.interval, 1)
        XCTAssertGreaterThan(next.ease, state.ease)
    }

    func testWrongResetsInterval() throws {
        let scheduler = SrsScheduler()
        let state = SrsState(ease: 2.5, interval: 6, dueDate: Date(), lapses: 1)
        let next = scheduler.nextState(from: state, result: .wrong)
        XCTAssertEqual(next.interval, 1)
        XCTAssertLessThan(next.ease, state.ease)
        XCTAssertEqual(next.lapses, state.lapses + 1)
    }
}
