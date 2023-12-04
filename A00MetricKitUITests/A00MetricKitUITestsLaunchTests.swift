//
//  A00MetricKitUITestsLaunchTests.swift
//  A00MetricKitUITests
//
//  Created by 邓立兵 on 2023/12/2.
//

import XCTest

final class A00MetricKitUITestsLaunchTests: XCTestCase {
    func testLaunch() throws {
        let bundleid = ProcessInfo.processInfo.environment["BUNDLE_ID"]!
//        let jxtj = "com.jd.jdmobilelite"
//        let jx = "com.360buy.jdpingou"
        print("bundleid: \(bundleid)")
        let options = XCTMeasureOptions()
        options.iterationCount = 1
        measure(metrics: [XCTApplicationLaunchMetric()], options: options) {
            let app = XCUIApplication(bundleIdentifier: bundleid)
            app.launch()
        }
    }
}
