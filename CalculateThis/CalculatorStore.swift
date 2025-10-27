//
//  CalculatorStore.swift
//  CalculateThis
//
//  Local and cloud storage manager for custom calculators
//

import Foundation
import SwiftUI

@MainActor
class CalculatorStore: ObservableObject {
    @Published var myCalculators: [CustomCalculator] = []
    @Published var marketplaceCalculators: [CustomCalculator] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let userDefaultsKey = "savedCalculators"

    init() {
        loadLocalCalculators()
        loadMarketplaceCalculators()
    }

    // MARK: - Local Storage

    func loadLocalCalculators() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let calculators = try? JSONDecoder().decode([CustomCalculator].self, from: data) else {
            // Load templates as starting point
            myCalculators = CustomCalculator.templates
            saveLocalCalculators()
            return
        }
        myCalculators = calculators
    }

    func saveLocalCalculators() {
        if let data = try? JSONEncoder().encode(myCalculators) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    func saveCalculator(_ calculator: CustomCalculator) {
        if let index = myCalculators.firstIndex(where: { $0.id == calculator.id }) {
            myCalculators[index] = calculator
        } else {
            myCalculators.append(calculator)
        }
        saveLocalCalculators()
    }

    func deleteCalculator(_ calculator: CustomCalculator) {
        myCalculators.removeAll { $0.id == calculator.id }
        saveLocalCalculators()
    }

    func duplicateCalculator(_ calculator: CustomCalculator) -> CustomCalculator {
        var copy = calculator
        copy.id = UUID().uuidString
        copy.name = "\(calculator.name) (Copy)"
        copy.isPublished = false
        copy.createdDate = Date()
        saveCalculator(copy)
        return copy
    }

    // MARK: - Marketplace/Cloud

    func loadMarketplaceCalculators() {
        // In a real app, this would fetch from a backend API
        // For now, we'll simulate with some sample calculators
        marketplaceCalculators = generateSampleMarketplaceCalculators()
    }

    func publishCalculator(_ calculator: CustomCalculator) async throws {
        isLoading = true
        errorMessage = nil

        // Simulate API call
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

        // In a real app, this would upload to a backend
        // For now, we'll simulate by adding to marketplace
        var published = calculator
        published.isPublished = true
        published.createdDate = Date()

        // Update local calculator
        if let index = myCalculators.firstIndex(where: { $0.id == calculator.id }) {
            myCalculators[index] = published
            saveLocalCalculators()
        }

        // Add to marketplace
        if let index = marketplaceCalculators.firstIndex(where: { $0.id == published.id }) {
            marketplaceCalculators[index] = published
        } else {
            marketplaceCalculators.insert(published, at: 0)
        }

        isLoading = false
    }

    func downloadCalculator(_ calculator: CustomCalculator) async throws {
        isLoading = true
        errorMessage = nil

        // Simulate download
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        var downloaded = calculator
        downloaded.id = UUID().uuidString // Create new ID for local copy
        downloaded.downloads += 1
        downloaded.isPublished = false

        saveCalculator(downloaded)

        // Update download count in marketplace
        if let index = marketplaceCalculators.firstIndex(where: { $0.id == calculator.id }) {
            marketplaceCalculators[index].downloads += 1
        }

        isLoading = false
    }

    func rateCalculator(_ calculator: CustomCalculator, rating: Int) async throws {
        guard let index = marketplaceCalculators.firstIndex(where: { $0.id == calculator.id }) else {
            return
        }

        var updated = marketplaceCalculators[index]
        let totalRating = updated.rating * Double(updated.ratingCount)
        updated.ratingCount += 1
        updated.rating = (totalRating + Double(rating)) / Double(updated.ratingCount)
        marketplaceCalculators[index] = updated
    }

    // MARK: - Sample Data

    private func generateSampleMarketplaceCalculators() -> [CustomCalculator] {
        var samples: [CustomCalculator] = []

        // Investment Return Calculator
        samples.append(CustomCalculator(
            name: "Investment Return",
            description: "Calculate ROI on your investments with compound interest",
            icon: "chart.line.uptrend.xyaxis",
            color: "green",
            inputs: [
                CalculatorInput(name: "principal", label: "Initial Investment", type: .decimal, placeholder: "10000"),
                CalculatorInput(name: "rate", label: "Annual Return %", type: .slider, defaultValue: "7", minValue: 0, maxValue: 20),
                CalculatorInput(name: "years", label: "Years", type: .number, placeholder: "10")
            ],
            formulas: [
                CalculatorFormula(name: "future", expression: "principal * pow((1 + rate / 100), years)", description: "Future value with compound interest"),
                CalculatorFormula(name: "profit", expression: "future - principal", description: "Total profit")
            ],
            outputs: [
                CalculatorOutput(label: "Future Value", formulaName: "future", format: .currency),
                CalculatorOutput(label: "Total Profit", formulaName: "profit", format: .currency)
            ],
            author: "FinanceGuru",
            downloads: 1247,
            rating: 4.8,
            ratingCount: 156,
            isPublished: true,
            category: .finance
        ))

        // Calorie Burn Calculator
        samples.append(CustomCalculator(
            name: "Calorie Burn",
            description: "Estimate calories burned during exercise",
            icon: "flame.fill",
            color: "red",
            inputs: [
                CalculatorInput(name: "weight", label: "Weight (kg)", type: .decimal, placeholder: "70"),
                CalculatorInput(name: "duration", label: "Duration (min)", type: .number, placeholder: "30"),
                CalculatorInput(name: "met", label: "MET Value", type: .slider, defaultValue: "7", minValue: 1, maxValue: 15)
            ],
            formulas: [
                CalculatorFormula(name: "calories", expression: "met * weight * duration / 60", description: "Calories = MET × weight × time")
            ],
            outputs: [
                CalculatorOutput(label: "Calories Burned", formulaName: "calories", format: .decimal1, unit: "kcal")
            ],
            author: "FitLife",
            downloads: 892,
            rating: 4.6,
            ratingCount: 98,
            isPublished: true,
            category: .health
        ))

        // Pizza Party Calculator
        samples.append(CustomCalculator(
            name: "Pizza Party",
            description: "Calculate how many pizzas you need for your party",
            icon: "birthday.cake.fill",
            color: "orange",
            inputs: [
                CalculatorInput(name: "guests", label: "Number of Guests", type: .number, placeholder: "20"),
                CalculatorInput(name: "slicesPerPerson", label: "Slices per Person", type: .slider, defaultValue: "3", minValue: 1, maxValue: 6),
                CalculatorInput(name: "slicesPerPizza", label: "Slices per Pizza", type: .number, defaultValue: "8")
            ],
            formulas: [
                CalculatorFormula(name: "totalSlices", expression: "guests * slicesPerPerson", description: "Total slices needed"),
                CalculatorFormula(name: "pizzas", expression: "ceil(totalSlices / slicesPerPizza)", description: "Pizzas needed (rounded up)")
            ],
            outputs: [
                CalculatorOutput(label: "Total Slices", formulaName: "totalSlices", format: .number),
                CalculatorOutput(label: "Pizzas to Order", formulaName: "pizzas", format: .number)
            ],
            author: "PartyPlanner",
            downloads: 634,
            rating: 4.9,
            ratingCount: 87,
            isPublished: true,
            category: .lifestyle
        ))

        // Grade Calculator
        samples.append(CustomCalculator(
            name: "Grade Calculator",
            description: "Calculate your final grade with weighted assignments",
            icon: "graduationcap.fill",
            color: "blue",
            inputs: [
                CalculatorInput(name: "homework", label: "Homework %", type: .decimal, placeholder: "85"),
                CalculatorInput(name: "hwWeight", label: "HW Weight", type: .decimal, defaultValue: "20"),
                CalculatorInput(name: "midterm", label: "Midterm %", type: .decimal, placeholder: "78"),
                CalculatorInput(name: "midWeight", label: "Mid Weight", type: .decimal, defaultValue: "30"),
                CalculatorInput(name: "final", label: "Final %", type: .decimal, placeholder: "88"),
                CalculatorInput(name: "finalWeight", label: "Final Weight", type: .decimal, defaultValue: "50")
            ],
            formulas: [
                CalculatorFormula(name: "grade", expression: "(homework * hwWeight + midterm * midWeight + final * finalWeight) / (hwWeight + midWeight + finalWeight)", description: "Weighted average")
            ],
            outputs: [
                CalculatorOutput(label: "Final Grade", formulaName: "grade", format: .decimal2, unit: "%")
            ],
            author: "StudyBuddy",
            downloads: 1891,
            rating: 4.7,
            ratingCount: 234,
            isPublished: true,
            category: .other
        ))

        // Tip Split Calculator
        samples.append(CustomCalculator(
            name: "Tip Split Pro",
            description: "Advanced tip calculator with tax and custom splits",
            icon: "dollarsign.circle.fill",
            color: "purple",
            inputs: [
                CalculatorInput(name: "bill", label: "Bill Amount", type: .decimal, placeholder: "85.50"),
                CalculatorInput(name: "tip", label: "Tip %", type: .slider, defaultValue: "18", minValue: 0, maxValue: 30),
                CalculatorInput(name: "tax", label: "Tax %", type: .decimal, defaultValue: "8.5"),
                CalculatorInput(name: "people", label: "Split Ways", type: .number, defaultValue: "4")
            ],
            formulas: [
                CalculatorFormula(name: "tipAmount", expression: "bill * (tip / 100)", description: "Tip amount"),
                CalculatorFormula(name: "taxAmount", expression: "bill * (tax / 100)", description: "Tax amount"),
                CalculatorFormula(name: "total", expression: "bill + tipAmount + taxAmount", description: "Grand total"),
                CalculatorFormula(name: "perPerson", expression: "total / people", description: "Per person")
            ],
            outputs: [
                CalculatorOutput(label: "Tip", formulaName: "tipAmount", format: .currency),
                CalculatorOutput(label: "Tax", formulaName: "taxAmount", format: .currency),
                CalculatorOutput(label: "Total", formulaName: "total", format: .currency),
                CalculatorOutput(label: "Per Person", formulaName: "perPerson", format: .currency)
            ],
            author: "MathWiz",
            downloads: 2156,
            rating: 4.9,
            ratingCount: 312,
            isPublished: true,
            category: .finance
        ))

        return samples
    }
}
