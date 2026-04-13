import Foundation
import RoomPlan

@MainActor
final class RoomCaptureModel: NSObject, ObservableObject {
    @Published var isExporting: Bool = false
    @Published var lastErrorMessage: String?
    @Published var latestExport: RoomExport?

    let roomCaptureView: RoomCaptureView
    private let sessionConfig: RoomCaptureSession.Configuration

    private var capturedRoom: CapturedRoom?
    private var isCapturing: Bool = false

    override init() {
        self.roomCaptureView = RoomCaptureView(frame: .zero)
        self.sessionConfig = .init()
        super.init()

        roomCaptureView.captureSession.delegate = self
    }

    func startCapture() {
        lastErrorMessage = nil
        capturedRoom = nil
        isCapturing = true
        roomCaptureView.captureSession.run(configuration: sessionConfig)
    }

    func stopCaptureIfNeeded() {
        guard isCapturing else { return }
        isCapturing = false
        roomCaptureView.captureSession.stop()
    }

    func cancelCapture() {
        stopCaptureIfNeeded()
        capturedRoom = nil
        lastErrorMessage = nil
    }

    func stopAndExport() async -> RoomExport? {
        lastErrorMessage = nil
        isExporting = true
        defer { isExporting = false }

        stopCaptureIfNeeded()

        guard let room = capturedRoom else {
            lastErrorMessage = "未获得扫描结果：请确保使用支持 LiDAR 的真机，并完整绕房间扫描。"
            return nil
        }

        do {
            let export = try RoomExportManager.export(room: room)
            latestExport = export
            return export
        } catch {
            lastErrorMessage = "导出失败：\(error.localizedDescription)"
            return nil
        }
    }
}

extension RoomCaptureModel: RoomCaptureSessionDelegate {
    nonisolated func captureSession(_ session: RoomCaptureSession, didUpdate room: CapturedRoom) {
        Task { @MainActor in
            self.capturedRoom = room
        }
    }

    nonisolated func captureSession(_ session: RoomCaptureSession, didEndWith data: CapturedRoomData, error: Error?) {
        guard let error else { return }
        Task { @MainActor in
            self.lastErrorMessage = "扫描结束（有错误）：\(error.localizedDescription)"
        }
    }
}
