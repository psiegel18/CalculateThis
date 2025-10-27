import SwiftUI

struct BMICalculator: View {
    @State private var weight = ""
    @State private var height = ""
    @State private var useMetric = true
    
    var bmi: Double {
        let w = Double(weight) ?? 0
        let h = Double(height) ?? 0
        
        guard w > 0 && h > 0 else { return 0 }
        
        if useMetric {
            // kg and cm
            let heightInMeters = h / 100
            return w / (heightInMeters * heightInMeters)
        } else {
            // lbs and inches
            return (w / (h * h)) * 703
        }
    }
    
    var bmiCategory: (String, Color) {
        switch bmi {
        case 0..<18.5:
            return ("Underweight", .blue)
        case 18.5..<25:
            return ("Normal", .green)
        case 25..<30:
            return ("Overweight", .orange)
        case 30...:
            return ("Obese", .red)
        default:
            return ("", .gray)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Unit Toggle
                Picker("Unit System", selection: $useMetric) {
                    Text("Metric").tag(true)
                    Text("Imperial").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Weight Input
                VStack(alignment: .leading, spacing: 10) {
                    Text("Weight")
                        .font(.headline)
                    
                    HStack {
                        TextField(useMetric ? "kg" : "lbs", text: $weight)
                            .keyboardTypeCompat(.decimalPad)
                            .font(.title2)
                        Text(useMetric ? "kg" : "lbs")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.systemGray6)
                    .cornerRadius(10)
                }
                
                // Height Input
                VStack(alignment: .leading, spacing: 10) {
                    Text("Height")
                        .font(.headline)
                    
                    HStack {
                        TextField(useMetric ? "cm" : "inches", text: $height)
                            .keyboardTypeCompat(.decimalPad)
                            .font(.title2)
                        Text(useMetric ? "cm" : "in")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.systemGray6)
                    .cornerRadius(10)
                }
                
                // BMI Result
                if bmi > 0 {
                    VStack(spacing: 15) {
                        Text("Your BMI")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(String(format: "%.1f", bmi))
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(bmiCategory.1)
                        
                        Text(bmiCategory.0)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(bmiCategory.1)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(bmiCategory.1.opacity(0.2))
                            .cornerRadius(20)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(bmiCategory.1.opacity(0.1))
                    .cornerRadius(15)
                    
                    // BMI Scale
                    VStack(alignment: .leading, spacing: 10) {
                        Text("BMI Categories")
                            .font(.headline)
                        
                        BMIScaleRow(label: "Underweight", range: "< 18.5", color: .blue)
                        BMIScaleRow(label: "Normal", range: "18.5 - 24.9", color: .green)
                        BMIScaleRow(label: "Overweight", range: "25 - 29.9", color: .orange)
                        BMIScaleRow(label: "Obese", range: "≥ 30", color: .red)
                    }
                    .padding()
                    .background(Color.systemGray6)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("BMI Calculator")
        .navigationBarTitleDisplayModeCompat(.inline)
    }
}

struct BMIScaleRow: View {
    let label: String
    let range: String
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(label)
                .fontWeight(.medium)
            Spacer()
            Text(range)
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    NavigationView {
        BMICalculator()
    }
}
