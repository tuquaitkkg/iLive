//
//  PhotoService.swift
//  LiveWallpaper
//
//  Created by lephannam on 10/4/16.
//  Copyright © 2016 lephannam. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

public enum Result<T> {
    case Success(T)
    case Failure(String)
}

protocol Gettable {
    associatedtype Data

    func get(completionHandler: @escaping (Result<Data>) -> Void)
}

struct APIManager {
    static func downloadFile(urlString: String, closure: @escaping (_ response: HTTPURLResponse?, _ error: NSError?) -> Void) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let pathComponent = "Feaured.txt"
        let fileURL: URL = directoryURL.appendingPathComponent(pathComponent)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileURL, [.createIntermediateDirectories, .removePreviousFile])
        }
        let parameters: Parameters = ["foo": "bar"]
        
        Alamofire.download(urlString, method: .get, parameters: parameters, encoding: JSONEncoding.default, to: destination)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, temporaryURL, destinationURL in
                // Custom evaluation closure now includes file URLs (allows you to parse out error messages if necessary)
                return .success
            }
            .response { response in
                if let error = response.error {
                    closure(response.response, error as NSError)
                } else {
                    print("Downloaded file to \(fileURL)")
                    closure(response.response, nil)
                }
        }
    }
}

public struct LivePhotoService: Gettable {
    var path: String?
    func get(completionHandler: @escaping (Result<[LivePhoto]>) -> Void) {
        if let path = path {
            Alamofire.request(path, method: .get, parameters: nil, encoding: JSONEncoding.default)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                            let livePhotoResponse = Mapper<LivePhotoResponse>().map(JSONObject: value)
                            if let livePhotoResponse = livePhotoResponse, let livePhotos = livePhotoResponse.livePhotos {
                                completionHandler(.Success(livePhotos))
                            }
                        } else {
                            completionHandler(.Success([LivePhoto]()))
                        }
                    case .failure(let error):
                        completionHandler(.Failure(error.localizedDescription))
                    }
            }
        }
    }
}

//
//public struct LiveWallpaperService: Gettable {
//    var path: String?
//
//    func get(completionHandler: Result<[LiveWallpaper]> -> Void) {
//        if let path = path {
//            Alamofire.request(.GET, path)
//                .responseJSON { (response) in
//                    switch response.result {
//                    case .Success(let value):
//                        if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
//                            let liveWallpaperResponse = Mapper<LiveWallpaperResponse>().map(value)
//                            if let liveWallpaperResponse = liveWallpaperResponse, liveWallpapers = liveWallpaperResponse.liveWallpapers {
//                                completionHandler(.Success(liveWallpapers))
//                            }
//                        } else {
//                            completionHandler(.Success([LiveWallpaper]()))
//                        }
//                    case .Failure(let error):
//                        completionHandler(.Failure(error.localizedDescription))
//                    }
//            }
//        }
//    }
//}
//
//public struct PostService: Gettable {
//    var path: String?
//
//    func get(completionHandler: Result<[Post]> -> Void) {
//        if let path = path {
//            Alamofire.request(.GET, path)
//                .responseJSON { (response) in
//                    switch response.result {
//                    case .Success(let value):
//                        if response.response?.statusCode == 200 {
//                            let postResponse = Mapper<Posts>().map(value)
//                            if let postResponse = postResponse, posts = postResponse.posts {
//                                var elements = [Post]()
//                                for item in posts {
//                                    if let post = item.post {
//                                        elements.append(post)
//                                    }
//                                }
//                                completionHandler(.Success(elements))
//                            }
//                        } else {
//                            completionHandler(.Success([Post]()))
//                        }
//                    case .Failure(let error):
//                        completionHandler(.Failure(error.localizedDescription))
//                    }
//            }
//        }
//    }
//}
//
//public struct FirstFeaturedService: Gettable {
//    var path: String?
//
//    func get(completionHandler: Result<[FirstFeatured]> -> Void) {
//        if let path = path {
//            Alamofire.request(.GET, path)
//                .responseJSON { (response) in
//                    switch response.result {
//                    case .Success(let value):
//                        if response.response?.statusCode == 200 {
//                            let firstFeaturedResponse = Mapper<FirstFeaturedResponse>().map(value)
//                            if let firstFeaturedResponse = firstFeaturedResponse, datas = firstFeaturedResponse.data {
//                                completionHandler(.Success(datas))
//                            }
//                        } else {
//                            completionHandler(.Success([FirstFeatured]()))
//                        }
//                    case .Failure(let error):
//                        completionHandler(.Failure(error.localizedDescription))
//                    }
//            }
//        }
//    }
//}

