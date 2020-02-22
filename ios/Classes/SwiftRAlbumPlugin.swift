import Flutter
import UIKit
import Photos
import MobileCoreServices

public class SwiftRAlbumPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.rhyme_lph/r_album", binaryMessenger: registrar.messenger())
    let instance = SwiftRAlbumPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "createAlbum":
        self.createAlbum(call,result: result)
        break
    case "saveAlbum":
        self.saveAlbum(call,result: result)
        break
    default:
        result(FlutterMethodNotImplemented)
    }
  }
    
    private func createAlbum(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        let arguments = call.arguments as! Dictionary<String,Any>
        let albumName = arguments["albumName"] as! String
        AlbumSaver(folderName: albumName).createAlbumIfNeeded(completion: result)
    }
    
    private func saveAlbum(_ call: FlutterMethodCall, result: @escaping FlutterResult){
         let arguments = call.arguments as! Dictionary<String,Any>
         let albumName = arguments["albumName"] as! String
         let filePaths = arguments["filePaths"] as! [String]
         let albumSaver = AlbumSaver(folderName: albumName)
        for path in filePaths {
            let asset = AVURLAsset.init(url: URL(fileURLWithPath: path), options: nil)
            let tracks = asset.tracks(withMediaType: AVMediaType.video)
            if(tracks.count > 0){
                albumSaver.saveVideo(filePath: path)
            }else{
                albumSaver.saveImage(filePath: path)
            }
        }
        result(true)
    }
}

// ref https://stackoverflow.com/questions/28708846/how-to-save-image-to-custom-album
class AlbumSaver: NSObject {
  var albumName: String
  private var assetCollection: PHAssetCollection!

  init(folderName: String) {
    self.albumName = folderName
    super.init()
    if let assetCollection = fetchAssetCollectionForAlbum() {
      self.assetCollection = assetCollection
      return
    }
  }
    
  private func checkAuthorizationWithHandler(completion: @escaping ((_ success: Bool) -> Void)) {
    if PHPhotoLibrary.authorizationStatus() == .notDetermined {
      PHPhotoLibrary.requestAuthorization({ (status) in
        self.checkAuthorizationWithHandler(completion: completion)
      })
    }
    else if PHPhotoLibrary.authorizationStatus() == .authorized {
      self.createAlbumIfNeeded { (success) in
        if success {
          completion(true)
        } else {
          completion(false)
        }

      }

    }
    else {
      completion(false)
    }
  }

  func createAlbumIfNeeded(completion: @escaping ((_ success: Bool) -> Void)) {
    if let assetCollection = fetchAssetCollectionForAlbum() {
      // Album already exists
      self.assetCollection = assetCollection
      completion(true)
    } else {
      PHPhotoLibrary.shared().performChanges({
        PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)   // create an asset collection with the album name
      }) { success, error in
        if success {
          self.assetCollection = self.fetchAssetCollectionForAlbum()
          completion(true)
        } else {
          // Unable to create album
          completion(false)
        }
      }
    }
  }

  private func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumName)
    let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

    if let _: AnyObject = collection.firstObject {
      return collection.firstObject
    }
    return nil
  }

  func saveImage(filePath: String) {
    self.checkAuthorizationWithHandler { (success) in
      if success, self.assetCollection != nil {
        PHPhotoLibrary.shared().performChanges({
          let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: URL(fileURLWithPath: filePath))
          let assetPlaceHolder = assetChangeRequest?.placeholderForCreatedAsset
          if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
            let enumeration: NSArray = [assetPlaceHolder!]
            albumChangeRequest.addAssets(enumeration)
          }

        }, completionHandler: { (success, error) in
          if success {
            print("Successfully saved image to Camera Roll.")
          } else {
            print("Error writing to image library: \(error!.localizedDescription)")
          }
        })
      }
    }
  }
    
 func saveVideo(filePath: String) {
      self.checkAuthorizationWithHandler { (success) in
        if success, self.assetCollection != nil {
          PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
            let assetPlaceHolder = assetChangeRequest?.placeholderForCreatedAsset
            if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
              let enumeration: NSArray = [assetPlaceHolder!]
              albumChangeRequest.addAssets(enumeration)
            }

          }, completionHandler: { (success, error) in
            if success {
              print("Successfully saved video to Camera Roll.")
            } else {
              print("Error writing to video library: \(error!.localizedDescription)")
            }
          })
        }
      }
    }
}
