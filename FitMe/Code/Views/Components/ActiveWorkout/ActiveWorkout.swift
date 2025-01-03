import SwiftUI
import Combine

struct ActiveWorkout: View{
    @ObservedObject var viewModel: WorkoutViewModel
    let workout: Workout
    
    //Timer
    @State private var secondsElapsed = 0
    @State private var timerIsActive = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack{
            Text("Active Workout")
                .padding()
            TimerView(secondsElapsed: $secondsElapsed, 
                     timerIsActive: $timerIsActive,
                     timer: timer)
            Spacer()
            HStack {
                Button(action: {
                    if timerIsActive {
                        timer.upstream.connect().cancel()
                    } else {
                        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    }
                    timerIsActive.toggle()
                }) {
                    Text(timerIsActive ? "Pause" : "Start")
                        .font(.title)
                        .padding()
                        .background(timerIsActive ? Color.blue : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                Button(action: {
                    timer.upstream.connect().cancel()
                    timerIsActive = false
                    secondsElapsed = 0
                }) {
                    Text("End")
                        .font(.title)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}


struct TimerView: View {
    @Binding var secondsElapsed: Int
    @Binding var timerIsActive: Bool
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    private var formattedTime: String {
        let hours = secondsElapsed / 3600
        let minutes = (secondsElapsed % 3600) / 60
        let seconds = secondsElapsed % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(formattedTime)
                .font(.largeTitle)
                .monospacedDigit()
        }
        .onReceive(timer) { _ in
            if timerIsActive {
                secondsElapsed += 1
            }
        }
    }
}
