//
//  A00MetricKitUITestsLaunchTests.swift
//  A00MetricKitUITests
//
//  Created by 邓立兵 on 2023/12/2.
//

import XCTest

final class A00MetricKitUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let bundleid = ProcessInfo.processInfo.environment["BUNDLE_ID"]!
        print("bundleid: \(bundleid)")
        let options = XCTMeasureOptions()
        options.iterationCount = 1
        measure(metrics: [XCTOSSignpostMetric.applicationLaunch], options: options) {
            // Clean up the application state before each launch, if necessary
//                let jx = "com.360buy.jdpingou"
//                let jxtj = "com.jd.jdmobilelite"
            let app = XCUIApplication(bundleIdentifier: bundleid)
            app.launch()
        }
    }
}
