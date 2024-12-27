
import SwiftUI

struct CalendarView: View {
    var body: some View {
        VStack {
            Text("Calendar Screen")
                .font(.largeTitle)
                .padding()
            Image(systemName: "calendar")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
    }
}
