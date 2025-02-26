/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import XCTest

class BaseTestCase: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchArguments = ["testMode", "disableFirstRunUI"]
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        app.terminate()
    }

    //If it is a first run, first run window should be gone
    func dismissFirstRunUI() {
        let firstRunUI = XCUIApplication().buttons["OK, Got It!"]
        let onboardingUI = XCUIApplication().buttons["Skip"]

        if (firstRunUI.exists) {
            firstRunUI.tap()
        }

        if (onboardingUI.exists) {
            onboardingUI.tap()
        }
    }

    func dismissURLBarFocused() {
        if iPad() {
            app.windows.element(boundBy: 0).tap()
        } else {
            waitForExistence(app.buttons["URLBar.cancelButton"], timeout: 15)
            app.buttons["URLBar.cancelButton"].tap()
        }
    }

    func iPad() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        return false
    }

    func waitForEnable(_ element: XCUIElement, timeout: TimeInterval = 5.0, file: String = #file, line: UInt = #line) {
        waitFor(element, with: "exists == enable", timeout: timeout, file: file, line: line)
    }

    func waitForExistence(_ element: XCUIElement, timeout: TimeInterval = 5.0, file: String = #file, line: UInt = #line) {
            waitFor(element, with: "exists == true", timeout: timeout, file: file, line: line)
    }

    func waitForHittable(_ element: XCUIElement, timeout: TimeInterval = 5.0, file: String = #file, line: UInt = #line) {
            waitFor(element, with: "isHittable == true", timeout: timeout, file: file, line: line)
    }

    func waitForNoExistence(_ element: XCUIElement, timeoutValue: TimeInterval = 5.0, file: String = #file, line: UInt = #line) {
           waitFor(element, with: "exists != true", timeout: timeoutValue, file: file, line: line)
    }

    func waitForValueContains(_ element: XCUIElement, value: String, file: String = #file, line: UInt = #line) {
            waitFor(element, with: "value CONTAINS '\(value)'", file: file, line: line)
        }

    private func waitFor(_ element: XCUIElement, with predicateString: String, description: String? = nil, timeout: TimeInterval = 5.0, file: String, line: UInt) {
            let predicate = NSPredicate(format: predicateString)
            let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
            let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
            if result != .completed {
                let message = description ?? "Expect predicate \(predicateString) for \(element.description)"
                var issue = XCTIssue(type: .assertionFailure, compactDescription: message)
                let location = XCTSourceCodeLocation(filePath: file, lineNumber: Int(line))
                issue.sourceCodeContext = XCTSourceCodeContext(location: location)
                self.record(issue)
            }
        }

    func search(searchWord: String, waitForLoadToFinish: Bool = true) {
        let searchOrEnterAddressTextField = app.textFields["Search or enter address"]

        UIPasteboard.general.string = searchWord

        // Must press this way in order to support iPhone 5s
        searchOrEnterAddressTextField.tap()
        searchOrEnterAddressTextField.press(forDuration: 1)
        waitForExistence(app.menuItems["Paste & Go"])
        app.menuItems["Paste & Go"].tap()

        if waitForLoadToFinish {
            let finishLoadingTimeout: TimeInterval = 30
            let progressIndicator = app.progressIndicators.element(boundBy: 0)
            waitFor(progressIndicator,
                    with: "exists != true",
                    description: "Problem loading \(searchWord)",
                timeout: finishLoadingTimeout)
        }
    }
    

    func loadWebPage(_ url: String, waitForLoadToFinish: Bool = true) {
        waitForExistence(app.textFields["URLBar.urlText"], timeout: 3)
        app.textFields["URLBar.urlText"].tap()
        app.textFields["URLBar.urlText"].clearAndEnterText(text: url+"\n")

//        if waitForLoadToFinish {
//            let finishLoadingTimeout: TimeInterval = 30
//            let progressIndicator = app.progressIndicators.element(boundBy: 0)
//            waitFor(progressIndicator,
//                    with: "exists != true",
//                    description: "Problem loading \(url)",
//                    timeout: finishLoadingTimeout)
//        }
    }

    private func waitFor(_ element: XCUIElement, with predicateString: String, description: String? = nil, timeout: TimeInterval = 5.0) {
        let predicate = NSPredicate(format: predicateString)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        if result != .completed {
            let message = description ?? "Expect predicate \(predicateString) for \(element.description)"
            print(message)
        }
    }

    func checkForHomeScreen() {
        waitForExistence(app.buttons["HomeView.settingsButton"], timeout: 10)
    }

    func waitForWebPageLoad () {
        let app = XCUIApplication()
        let finishLoadingTimeout: TimeInterval = 30
        let progressIndicator = app.progressIndicators.element(boundBy: 0)

        expectation(for: NSPredicate(format: "exists != true"), evaluatedWith: progressIndicator, handler: nil)
        waitForExpectations(timeout: finishLoadingTimeout, handler: nil)
    }
}
                       
