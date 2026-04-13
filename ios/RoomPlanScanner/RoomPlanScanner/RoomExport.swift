import Foundation

struct RoomExport: Identifiable {
    let id = UUID()
    let directory: URL
    let usdzURL: URL
    let jsonURL: URL
    let createdAt: Date
}

