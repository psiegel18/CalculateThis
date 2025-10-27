# Multi Calculator App

A comprehensive multi-platform calculator app built with SwiftUI for iOS, iPadOS, and macOS.

## Features

### 1. Day of Week Calculator
Based on the Doomsday Algorithm, this calculator determines what day of the week any date falls on. It shows detailed calculation steps explaining how the algorithm works.

**Features:**
- Date picker for easy date selection
- Step-by-step calculation breakdown
- Visual display of the Doomsday Algorithm process
- Works for dates from year 1 to 3199

### 2. Tip Calculator
Calculate tips and split bills among multiple people.

**Features:**
- Customizable tip percentage (0-30%)
- Quick tip buttons (10%, 15%, 18%, 20%)
- Split bill between 1-20 people
- Shows total bill, tip amount, and per-person cost

### 3. BMI Calculator
Calculate Body Mass Index with support for both metric and imperial units.

**Features:**
- Toggle between Metric (kg/cm) and Imperial (lbs/inches)
- Color-coded BMI categories
- Visual BMI scale with ranges
- Categories: Underweight, Normal, Overweight, Obese

### 4. Loan Calculator
Calculate monthly loan payments and total interest.

**Features:**
- Support for years or months
- Shows monthly payment prominently
- Displays total amount paid and total interest
- Visual breakdown of principal vs interest
- Percentage breakdown chart

### 5. Unit Converter
Convert between different units across multiple categories.

**Categories:**
- **Length:** Meters, Kilometers, Miles, Feet, Inches, Centimeters
- **Weight:** Kilograms, Grams, Pounds, Ounces
- **Temperature:** Celsius, Fahrenheit, Kelvin
- **Volume:** Liters, Milliliters, Gallons, Cups, Fluid Ounces

**Features:**
- Easy swap button to reverse conversion
- Real-time conversion as you type
- Conversion summary display

### 6. Age Calculator
Calculate exact age and time lived between two dates.

**Features:**
- Shows age in years, months, and days
- Alternative representations (weeks, days, hours, minutes)
- Next birthday countdown
- Days until next birthday

## Installation

### Requirements
- Xcode 15.0 or later
- iOS 17.0+ / iPadOS 17.0+ / macOS 14.0+
- Swift 5.9+

### Setup Instructions

1. **Create a new Xcode project:**
   - Open Xcode
   - Select "Create a new Xcode project"
   - Choose "App" under the iOS tab
   - Name it "MultiCalculatorApp"
   - Select SwiftUI for Interface and Swift for Language

2. **Add the files:**
   - Replace the default ContentView.swift with the provided ContentView.swift
   - Add all calculator files to the project:
     - DayOfWeekCalculator.swift
     - TipCalculator.swift
     - BMICalculator.swift
     - LoanCalculator.swift
     - UnitConverter.swift
     - AgeCalculator.swift
   - Replace the App file with MultiCalculatorApp.swift

3. **Configure for multiple platforms (optional):**
   - In project settings, under "General" → "Supported Destinations"
   - Add iPad and/or Mac (Designed for iPad) as needed

4. **Build and Run:**
   - Select your target device or simulator
   - Press Cmd+R or click the Run button

## Project Structure

```
MultiCalculatorApp/
├── MultiCalculatorApp.swift          # Main app entry point
├── ContentView.swift                 # Navigation menu
├── DayOfWeekCalculator.swift        # Day of week calculator
├── TipCalculator.swift              # Tip and bill splitting calculator
├── BMICalculator.swift              # Body Mass Index calculator
├── LoanCalculator.swift             # Loan payment calculator
├── UnitConverter.swift              # Multi-unit converter
└── AgeCalculator.swift              # Age calculation tool
```

## Usage

1. Launch the app to see the main menu with all available calculators
2. Tap any calculator to open it
3. Enter your values and see real-time results
4. Use the back button to return to the main menu

## Technical Details

### Day of Week Calculator Algorithm

The Day of Week Calculator uses the Doomsday Algorithm, which:
1. Calculates a century code based on the year
2. Processes the last two digits of the year through division operations
3. Uses month-specific "doomsday" dates
4. Combines all values and uses modulo 7 to determine the day

This matches the algorithm from your original JavaScript implementation.

## Customization

You can easily add more calculators by:
1. Creating a new SwiftUI View file
2. Adding a NavigationLink in ContentView.swift
3. Following the existing calculator patterns

## Platform Support

This app is designed to work on:
- **iPhone:** Optimized portrait layout
- **iPad:** Adaptive layout with more spacing
- **Mac:** Designed for iPad mode (Catalyst)

## License

This project is open source and available for personal and educational use.

## Credits

Day of Week Calculator algorithm based on Conway's Doomsday Algorithm.
