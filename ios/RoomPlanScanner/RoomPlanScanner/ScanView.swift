import SwiftUI
import RoomPlan

struct ScanView: View {
    @ObservedObject var model: RoomCaptureModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            RoomCaptureViewContainer(roomCaptureView: model.roomCaptureView)
                .ignoresSafeArea()
                .onAppear {
                    model.startCapture()
                }
                .onDisappear {
                    model.stopCaptureIfNeeded()
                }

            VStack(spacing: 10) {
                if let error = model.lastErrorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.red.opacity(0.75))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }

                HStack(spacing: 12) {
                    Button(role: .destructive) {
                        model.cancelCapture()
                        dismiss()
                    } label: {
                        Text("取消")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.gray.opacity(0.8))

                    Button {
                        Task {
                            let export = await model.stopAndExport()
                            if export != nil {
                                dismiss()
                            }
                        }
                    } label: {
                        if model.isExporting {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("结束并导出")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(model.isExporting)
                }
            }
            .padding()
            .background(.black.opacity(0.25))
        }
        .navigationTitle("扫描中")
        .navigationBarTitleDisplayMode(.inline)
    }
}

