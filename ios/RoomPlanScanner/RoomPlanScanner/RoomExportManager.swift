import Foundation
import RoomPlan

enum RoomExportManager {
    static func export(room: CapturedRoom) throws -> RoomExport {
        let fm = FileManager.default

        let baseDir = try fm.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )

        let stamp = ISO8601DateFormatter().string(from: Date())
            .replacingOccurrences(of: ":", with: "-")
        let dir = baseDir.appendingPathComponent("RoomPlanExport-\(stamp)", isDirectory: true)
        try fm.createDirectory(at: dir, withIntermediateDirectories: true)

        let usdzURL = dir.appendingPathComponent("room.usdz")
        let jsonURL = dir.appendingPathComponent("room.json")

        try room.export(to: usdzURL)

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(room)
        try data.write(to: jsonURL, options: [.atomic])

        return RoomExport(
            directory: dir,
            usdzURL: usdzURL,
            jsonURL: jsonURL,
            createdAt: Date()
        )
    }
}

