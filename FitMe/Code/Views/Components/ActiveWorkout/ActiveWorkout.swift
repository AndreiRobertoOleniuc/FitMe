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
        VStack(alignment: .leading){
            Text(workout.name)
                .font(.title3)
                .bold()
                .padding([.bottom,.top], 5)
            Divider()
            HStack{
                TimerView(
                    secondsElapsed: $secondsElapsed,
                    timerIsActive: $timerIsActive,
                    timer: timer
                )
                Spacer()
                VStack(alignment: .trailing){
                    Text("Volume")
                        .bold()
                    Text("0 kg")
                }
                Spacer()
                VStack(alignment: .trailing){
                    Text("Sets")
                        .bold()
                    Text("0")
                }
            }
            .padding(.vertical)
            Divider()
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
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
        }
        .padding(.horizontal)
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
        VStack(alignment: .leading) {
            Text("Duration")
                .bold()
            Text(formattedTime)
                .font(.body)
                .foregroundColor(Color.blue)
                .monospacedDigit()
        }
        .onReceive(timer) { _ in
            if timerIsActive {
                secondsElapsed += 1
            }
        }
    }
}
