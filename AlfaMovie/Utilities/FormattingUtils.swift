//
//  FormattingUtils.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import Foundation

struct FormattingUtils {
    
    // MARK: - Runtime Formatting
    static func formatRuntime(_ runtime: Int?) -> String {
        guard let runtime = runtime, runtime >= 0 else { return "Unknown" }
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)h \(minutes)m"
    }
    
    // MARK: - Budget Formatting
    static func formatBudget(_ budget: Int?) -> String {
        guard let budget = budget, budget > 0 else { return "Unknown" }
        if budget >= 1_000_000_000 {
            return "$\(budget / 1_000_000_000)B"
        } else if budget >= 1_000_000 {
            return "$\(budget / 1_000_000)M"
        } else {
            return "$\(budget)"
        }
    }
    
    // MARK: - Revenue Formatting
    static func formatRevenue(_ revenue: Int?) -> String {
        guard let revenue = revenue, revenue > 0 else { return "Unknown" }
        if revenue >= 1_000_000_000 {
            return "$\(revenue / 1_000_000_000)B"
        } else if revenue >= 1_000_000 {
            return "$\(revenue / 1_000_000)M"
        } else {
            return "$\(revenue)"
        }
    }
    
    // MARK: - Currency Formatting
    static func formatCurrency(_ amount: Int?, currency: String = "$") -> String {
        guard let amount = amount, amount > 0 else { return "Unknown" }
        if amount >= 1_000_000_000 {
            return "\(currency)\(amount / 1_000_000_000)B"
        } else if amount >= 1_000_000 {
            return "\(currency)\(amount / 1_000_000)M"
        } else if amount >= 1_000 {
            return "\(currency)\(amount / 1_000)K"
        } else {
            return "\(currency)\(amount)"
        }
    }
    
    // MARK: - Date Formatting
    static func formatDate(_ dateString: String, format: String = "MMM dd, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = format
        return displayFormatter.string(from: date)
    }
    
    // MARK: - Rating Formatting
    static func formatRating(_ rating: Double, maxRating: Double = 10.0) -> String {
        return String(format: "%.1f", rating)
    }
    
    // MARK: - File Size Formatting
    static func formatFileSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
} 