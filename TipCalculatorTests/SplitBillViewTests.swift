//
//  SplitBillViewTests.swift
//  TipCalculatorTests
//
//  Created by Gülfem Albayrak on 26.06.2024.
//

import XCTest
@testable import TipCalculator
final class SplitBillViewTests: XCTestCase {

    func testValidNumberOfPeople() {
        let totalAmount = 100.0
        let numberOfPeople = "4"
        var perPersonAmount = 0.0
        var showAlert = false
        var splitBillView = SplitBillView(totalAmount: .constant(totalAmount))
        
        let calculation = BillCalculation()
        calculation.calculatePerPersonAmount(totalAmount: totalAmount, numberOfPeople: numberOfPeople) { result, alert in
            perPersonAmount = result
            showAlert = alert
        }
        
        // Then
        XCTAssertEqual(perPersonAmount, 25.0)
        XCTAssertFalse(showAlert)
    }
    func testInvalidNumberOfPeople() {
        let totalAmount = 100.0
        let numberOfPeople = "-4"
        var perPersonAmount = 0.0
        var showAlert = false
        var splitBillView = SplitBillView(totalAmount: .constant(totalAmount))
        
        let calculation = BillCalculation()
        calculation.calculatePerPersonAmount(totalAmount: totalAmount, numberOfPeople: numberOfPeople) { result, alert in
            perPersonAmount = result
            showAlert = alert
        }
        
        // Then
        XCTAssertEqual(perPersonAmount, 0.0)
        XCTAssertTrue(showAlert)
    }

}
