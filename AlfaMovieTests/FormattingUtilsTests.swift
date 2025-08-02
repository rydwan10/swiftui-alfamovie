//
//  FormattingUtilsTests.swift
//  AlfaMovieTests
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import XCTest
@testable import AlfaMovie

final class FormattingUtilsTests: XCTestCase {
    
    // MARK: - Runtime Formatting Tests
    
    func testFormatRuntime_WithValidMinutes() {
        // Test various runtime values
        XCTAssertEqual(FormattingUtils.formatRuntime(90), "1h 30m")
        XCTAssertEqual(FormattingUtils.formatRuntime(120), "2h 0m")
        XCTAssertEqual(FormattingUtils.formatRuntime(45), "0h 45m")
        XCTAssertEqual(FormattingUtils.formatRuntime(0), "0h 0m")
        XCTAssertEqual(FormattingUtils.formatRuntime(1440), "24h 0m") // 24 hours
    }
    
    func testFormatRuntime_WithInvalidValues() {
        // Test nil and negative values
        XCTAssertEqual(FormattingUtils.formatRuntime(nil), "Unknown")
        XCTAssertEqual(FormattingUtils.formatRuntime(-10), "Unknown")
        XCTAssertEqual(FormattingUtils.formatRuntime(0), "0h 0m") // Edge case: 0 minutes
    }
    
    // MARK: - Budget Formatting Tests
    
    func testFormatBudget_WithValidValues() {
        // Test various budget values
        XCTAssertEqual(FormattingUtils.formatBudget(1000000), "$1M")
        XCTAssertEqual(FormattingUtils.formatBudget(15000000), "$15M")
        XCTAssertEqual(FormattingUtils.formatBudget(1000000000), "$1B")
        XCTAssertEqual(FormattingUtils.formatBudget(2500000000), "$2B")
        XCTAssertEqual(FormattingUtils.formatBudget(500000), "$500000")
        XCTAssertEqual(FormattingUtils.formatBudget(999999), "$999999")
    }
    
    func testFormatBudget_WithInvalidValues() {
        // Test nil and negative values
        XCTAssertEqual(FormattingUtils.formatBudget(nil), "Unknown")
        XCTAssertEqual(FormattingUtils.formatBudget(-1000000), "Unknown")
        XCTAssertEqual(FormattingUtils.formatBudget(0), "Unknown")
    }
    
    // MARK: - Revenue Formatting Tests
    
    func testFormatRevenue_WithValidValues() {
        // Test various revenue values
        XCTAssertEqual(FormattingUtils.formatRevenue(1000000), "$1M")
        XCTAssertEqual(FormattingUtils.formatRevenue(15000000), "$15M")
        XCTAssertEqual(FormattingUtils.formatRevenue(1000000000), "$1B")
        XCTAssertEqual(FormattingUtils.formatRevenue(2500000000), "$2B")
        XCTAssertEqual(FormattingUtils.formatRevenue(500000), "$500000")
        XCTAssertEqual(FormattingUtils.formatRevenue(999999), "$999999")
    }
    
    func testFormatRevenue_WithInvalidValues() {
        // Test nil and negative values
        XCTAssertEqual(FormattingUtils.formatRevenue(nil), "Unknown")
        XCTAssertEqual(FormattingUtils.formatRevenue(-1000000), "Unknown")
        XCTAssertEqual(FormattingUtils.formatRevenue(0), "Unknown")
    }
    
    // MARK: - Currency Formatting Tests
    
    func testFormatCurrency_WithValidValues() {
        // Test various currency values with default dollar sign
        XCTAssertEqual(FormattingUtils.formatCurrency(1000), "$1K")
        XCTAssertEqual(FormattingUtils.formatCurrency(1000000), "$1M")
        XCTAssertEqual(FormattingUtils.formatCurrency(1000000000), "$1B")
        XCTAssertEqual(FormattingUtils.formatCurrency(500), "$500")
        XCTAssertEqual(FormattingUtils.formatCurrency(999), "$999")
    }
    
    func testFormatCurrency_WithCustomCurrency() {
        // Test with different currency symbols
        XCTAssertEqual(FormattingUtils.formatCurrency(1000000, currency: "€"), "€1M")
        XCTAssertEqual(FormattingUtils.formatCurrency(1000000000, currency: "£"), "£1B")
        XCTAssertEqual(FormattingUtils.formatCurrency(1000, currency: "¥"), "¥1K")
    }
    
    func testFormatCurrency_WithInvalidValues() {
        // Test nil and negative values
        XCTAssertEqual(FormattingUtils.formatCurrency(nil), "Unknown")
        XCTAssertEqual(FormattingUtils.formatCurrency(-1000000), "Unknown")
        XCTAssertEqual(FormattingUtils.formatCurrency(0), "Unknown")
    }
    
    // MARK: - Date Formatting Tests
    
    func testFormatDate_WithValidDateString() {
        // Test valid date formatting
        XCTAssertEqual(FormattingUtils.formatDate("2024-01-15"), "Jan 15, 2024")
        XCTAssertEqual(FormattingUtils.formatDate("2023-12-31"), "Dec 31, 2023")
        XCTAssertEqual(FormattingUtils.formatDate("2024-02-29"), "Feb 29, 2024") // Leap year
    }
    
    func testFormatDate_WithCustomFormat() {
        // Test custom date format
        XCTAssertEqual(FormattingUtils.formatDate("2024-01-15", format: "yyyy"), "2024")
        XCTAssertEqual(FormattingUtils.formatDate("2024-01-15", format: "MM/dd"), "01/15")
        XCTAssertEqual(FormattingUtils.formatDate("2024-01-15", format: "EEEE"), "Monday")
    }
    
    func testFormatDate_WithInvalidDateString() {
        // Test invalid date strings
        XCTAssertEqual(FormattingUtils.formatDate("invalid-date"), "invalid-date")
        XCTAssertEqual(FormattingUtils.formatDate(""), "")
        XCTAssertEqual(FormattingUtils.formatDate("2024-13-45"), "2024-13-45") // Invalid month/day
    }
    
    // MARK: - Rating Formatting Tests
    
    func testFormatRating_WithValidRatings() {
        // Test various rating values
        XCTAssertEqual(FormattingUtils.formatRating(8.5), "8.5")
        XCTAssertEqual(FormattingUtils.formatRating(10.0), "10.0")
        XCTAssertEqual(FormattingUtils.formatRating(0.0), "0.0")
        XCTAssertEqual(FormattingUtils.formatRating(7.123), "7.1")
        XCTAssertEqual(FormattingUtils.formatRating(9.999), "10.0")
    }
    
    func testFormatRating_WithCustomMaxRating() {
        // Test with different max ratings
        XCTAssertEqual(FormattingUtils.formatRating(4.5, maxRating: 5.0), "4.5")
        XCTAssertEqual(FormattingUtils.formatRating(8.0, maxRating: 10.0), "8.0")
    }
    
    // MARK: - File Size Formatting Tests
    
    func testFormatFileSize_WithValidSizes() {
        // Test various file sizes
        XCTAssertEqual(FormattingUtils.formatFileSize(1024), "1 KB")
        XCTAssertEqual(FormattingUtils.formatFileSize(1048576), "1 MB")
        XCTAssertEqual(FormattingUtils.formatFileSize(1073741824), "1,07 GB")
        XCTAssertEqual(FormattingUtils.formatFileSize(100), "0 KB")
        XCTAssertEqual(FormattingUtils.formatFileSize(1536), "2 KB")
    }
    
    func testFormatFileSize_WithZeroAndNegative() {
        // Test edge cases
        XCTAssertEqual(FormattingUtils.formatFileSize(0), "Zero KB")
        XCTAssertEqual(FormattingUtils.formatFileSize(-1024), "-1 KB")
    }
    
    // MARK: - Edge Cases and Integration Tests
    
    func testFormattingUtils_Consistency() {
        // Test that formatting is consistent across similar values
        let budget1 = FormattingUtils.formatBudget(1000000)
        let budget2 = FormattingUtils.formatBudget(1000000)
        XCTAssertEqual(budget1, budget2)
        
        let revenue1 = FormattingUtils.formatRevenue(1000000)
        let revenue2 = FormattingUtils.formatRevenue(1000000)
        XCTAssertEqual(revenue1, revenue2)
    }
    
    func testFormattingUtils_Performance() {
        // Test performance with multiple calls
        measure {
            for _ in 0..<1000 {
                _ = FormattingUtils.formatRuntime(120)
                _ = FormattingUtils.formatBudget(1000000)
                _ = FormattingUtils.formatRevenue(1000000)
                _ = FormattingUtils.formatCurrency(1000000)
                _ = FormattingUtils.formatDate("2024-01-15")
                _ = FormattingUtils.formatRating(8.5)
                _ = FormattingUtils.formatFileSize(1048576)
            }
        }
    }
    
    // MARK: - Real-world Movie Data Tests
    
    func testFormattingUtils_WithRealMovieData() {
        // Test with realistic movie data scenarios
        
        // Runtime: 2h 15m
        XCTAssertEqual(FormattingUtils.formatRuntime(135), "2h 15m")
        
        // Budget: $150M
        XCTAssertEqual(FormattingUtils.formatBudget(150000000), "$150M")
        
        // Revenue: $1.2B
        XCTAssertEqual(FormattingUtils.formatRevenue(1200000000), "$1B")
        
        // Rating: 8.5/10
        XCTAssertEqual(FormattingUtils.formatRating(8.5), "8.5")
        
        // Release Date
        XCTAssertEqual(FormattingUtils.formatDate("2024-01-15"), "Jan 15, 2024")
    }
} 
