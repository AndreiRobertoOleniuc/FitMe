import SwiftUI

struct ImageView: View {
    let imageURL: URL?
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let systemName: String
    
    static func getFullImageURL(_ path: String?) -> URL? {
        guard let path = path else { return nil }
        return URL(string: path)
    }
    
    static func getSystemImageName(_ category: String?) -> String {
        switch category {
        case "Abs":
            return "figure.core.training"
        case "Arms":
            return "dumbbell.fill"
        case "Back":
            return "figure.strengthtraining.functional"
        case "Calves":
            return "figure.walk"
        case "Cardio":
            return "heart.fill"
        case "Chest":
            return "figure.strengthtraining.functional"
        case "Legs":
            return "figure.run"
        case "Shoulders":
            return "figure.strengthtraining.functional"
        default:
            return "dumbbell.fill"
        }
    }
    
    
    init(imageURL: URL?, width: CGFloat = 60, height: CGFloat = 60,cornerRadius: CGFloat = 8, systemName: String = "dumbbell.fill") {
        self.imageURL = imageURL
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.systemName = systemName
    }

    
    var body: some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        } placeholder: {
            Image(systemName: systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width/2, height: height/2)
                .frame(width: width, height: height)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}
