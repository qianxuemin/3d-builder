import SwiftUI
import RoomPlan

struct RoomCaptureViewContainer: UIViewRepresentable {
    let roomCaptureView: RoomCaptureView

    func makeUIView(context: Context) -> RoomCaptureView {
        roomCaptureView
    }

    func updateUIView(_ uiView: RoomCaptureView, context: Context) {
        // no-op
    }
}

