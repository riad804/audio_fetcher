import Flutter
import UIKit
import MediaPlayer

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

  private func getSongs() -> [[String: Any]] {
    var songs: [[String: Any]] = []
    let query = MPMediaQuery.songs()
    let items = query.items ?? []

    for item in items {
      var imageBase64: String? = nil
      if let artwork = item.artwork {
        let size = CGSize(width: 200, height: 200)
        if let image = artwork.image(at: size),
           let data = image.jpegData(compressionQuality: 0.6) {
          imageBase64 = data.base64EncodedString()
        }
      }

      songs.append([
        "title": item.title ?? "Unknown",
        "artist": item.artist ?? "Unknown",
        "path": item.assetURL?.absoluteString ?? "",
        "image": imageBase64 ?? ""
      ])
    }
    return songs
  }
}