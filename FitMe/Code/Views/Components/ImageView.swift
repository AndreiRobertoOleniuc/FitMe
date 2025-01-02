import SwiftUI

struct ImageView: View {
    let imageURL: URL?
    let size: CGFloat
    let cornerRadius: CGFloat
    
    static func getFullImageURL(_ path: String?) -> URL? {
        guard let path = path else { return nil }
        return URL(string: path)
    }
    
    init(imageURL: URL?, size: CGFloat = 60, cornerRadius: CGFloat = 8) {
        self.imageURL = imageURL
        self.size = size
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        } placeholder: {
            Image(systemName: "dumbbell.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size/2, height: size/2)
                .frame(width: size, height: size)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}
