import SwiftData
import SwiftUI

struct ExerciseParametersView: View {
    let sets: Int
    let reps: Int
    let rest: Int
    let weight: Double
    
    var body: some View {
        VStack(spacing: 15) {
            DetailRow(title: "Sets", value: "\(sets)")
            DetailRow(title: "Reps", value: "\(reps)")
            DetailRow(title: "Rest", value: "\(rest) sec")
            DetailRow(title: "Weight", value: "\(weight) kg")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
