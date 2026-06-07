import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var environment: AppEnvironment

    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }
            BlueprintView()
                .tabItem {
                    Label("Blueprint", systemImage: "square.grid.2x2")
                }
            AskView()
                .tabItem {
                    Label("Ask", systemImage: "bubble.left.and.bubble.right")
                }
            ProfileView()
                .tabItem {
                    Label("Mine", systemImage: "person.crop.circle")
                }
        }
        .overlay(alignment: .bottom) {
            if let toast = environment.toast {
                ToastOverlay(toast: toast)
                    .animation(.snappy, value: toast)
            }
        }
    }
}

