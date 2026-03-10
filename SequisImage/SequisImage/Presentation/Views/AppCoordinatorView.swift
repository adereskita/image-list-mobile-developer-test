import SwiftUI

struct AppCoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        Group {
            switch coordinator.currentRoute {
            case .splash:
                SplashView {
                    withAnimation {
                        coordinator.navigate(to: .imageList)
                    }
                }
            case .imageList:
                let viewModel = ImageListViewModel(getImagesUseCase: coordinator.getImagesUseCase)
                ImageListView(viewModel: viewModel)
            }
        }
        .environmentObject(coordinator)
    }
}
