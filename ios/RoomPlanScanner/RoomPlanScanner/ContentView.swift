import SwiftUI

struct ContentView: View {
    @StateObject private var model = RoomCaptureModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("RoomPlan 扫描原型")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("拿着手机绕房间走一圈，结束后导出 USDZ 3D 模型。")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                NavigationLink {
                    ScanView(model: model)
                } label: {
                    Text("开始扫描")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                if let export = model.latestExport {
                    NavigationLink {
                        ExportedRoomView(export: export)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("最近一次导出")
                                .font(.headline)
                            Text(export.directory.lastPathComponent)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("3D Builder")
        }
    }
}

#Preview {
    ContentView()
}

