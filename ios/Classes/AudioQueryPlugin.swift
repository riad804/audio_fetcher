import Flutter
import UIKit
import MediaPlayer
import AVFoundation

public class AudioQueryPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "audio_fetcher", binaryMessenger: registrar.messenger())
    let instance = AudioQueryPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getSongs":
      result(getSongs())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

private func getSongs() -> [[String: Any?]] {
    var songs: [[String: Any?]] = []

    // Request access to media library
    let status = MPMediaLibrary.authorizationStatus()
    if status != .authorized {
        MPMediaLibrary.requestAuthorization { _ in }
        return songs
    }

    let query = MPMediaQuery.songs()
    let items = query.items ?? []

    for item in items {
        let id = item.persistentID
        let title = item.title ?? "Unknown Title"
        let artist = item.artist ?? "Unknown Artist"
        let assetURL = item.assetURL?.absoluteString ?? ""

        // Duration (in ms)
        let duration = Int(item.playbackDuration * 1000)

        // Album art (UIImage -> PNG -> Base64 String)
        var imageBase64: String? = nil
        if let artwork = item.artwork {
            if let uiImage = artwork.image(at: CGSize(width: 200, height: 200)) {
                if let pngData = uiImage.pngData() {
                    imageBase64 = pngData.base64EncodedString()
                }
            }
        }

        let song: [String: Any?] = [
            "id": id,
            "title": title,
            "artist": artist,
            "duration": duration,
            "path": assetURL,
            "image": imageBase64
        ]

        songs.append(song)
    }

    return songs
  }
}