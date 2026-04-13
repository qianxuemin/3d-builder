import SwiftUI

struct ExportedRoomView: View {
    let export: RoomExport
    @State private var sharingItem: ShareItem?

    var body: some View {
        List {
            Section("预览") {
                NavigationLink("QuickLook 预览 room.usdz") {
                    QuickLookPreview(url: export.usdzURL)
                        .navigationTitle("room.usdz")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }

            Section("文件") {
                LabeledContent("导出目录") {
                    Text(export.directory.lastPathComponent)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Button("分享 room.usdz") { sharingItem = ShareItem(url: export.usdzURL) }
                Button("分享 room.json") { sharingItem = ShareItem(url: export.jsonURL) }
            }
        }
        .navigationTitle("导出结果")
        .sheet(item: $sharingItem) { item in
            ShareSheet(activityItems: [item.url])
        }
    }
}

private struct ShareItem: Identifiable {
    let id = UUID()
    let url: URL
}
