import SwiftUI

#Preview {
    TabsView()
}


struct TabsView: View {
    var body: some View {
        TabView {
            FirstTabView()
            .tabItem {
                Label("Today", systemImage: "house")
            }
            
            SecondTabView()
            .tabItem {
                Label("Workout", systemImage: "figure.strengthtraining.traditional")
            }
            
            ThirdTabView()
            .tabItem {
                Label("Explore", systemImage: "magnifyingglass")
            }
            
            ForthTabView()
                .tabItem{
                    Label("Profile", systemImage: "person")
                }
            
        }
    }
}


struct FirstTabView: View {
    var body: some View {
        VStack {
            Text("Home Screen")
                .font(.largeTitle)
                .padding()
            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
    }
}

struct SecondTabView: View {
    var body: some View {
        VStack {
            Text("Profile Screen")
                .font(.largeTitle)
                .padding()
            Image(systemName: "figure.strengthtraining.traditional")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
    }
}


struct ThirdTabView: View {
    var body: some View {
        VStack {
            Text("Settings Screen")
                .font(.largeTitle)
                .padding()
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
    }
}



struct ForthTabView: View {
    var body: some View {
        VStack {
            Text("Profile Screen")
                .font(.largeTitle)
                .padding()
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
    }
}
