import SwiftUI

struct ImageView: View {
    let imageURL: URL?
    let width: CGFloat?
    let height: CGFloat?
    let cornerRadius: CGFloat
    let systemName: String
    
    static func getFullImageURL(_ path: String?) -> URL? {
        guard let path = path else { return nil }
        return URL(string: path)
    }
    
    
    init(imageURL: URL?, width: CGFloat? = nil, height: CGFloat? = nil, cornerRadius: CGFloat = 8, systemName: String = "dumbbell.fill") {
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
                .frame(maxWidth: width ?? .infinity, maxHeight: height ?? width ?? 200) // Outer frame
                .background(Color.white) // Background to maintain consistency
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        } placeholder: {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.gray.opacity(0.1))
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(40) // Adjust padding to make the icon smaller
            }
            .frame(maxWidth: width ?? .infinity, maxHeight: height ?? width ?? 200) // Outer frame
        }
    }
}
