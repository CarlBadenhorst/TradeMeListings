//
//  RemoteImage.swift
//  TradeMeListings
//
//  Created by Carl Badenhorst on 2022/02/25.
//

import Foundation
import SwiftUI
import Combine

struct RemoteImage: View {
    @ObservedObject private var loader: Loader
    var loading: AnyView
    var failure: AnyView

    var body: some View {
        selectImage()
    }

    init(url: String, loading: AnyView = AnyView(Image(systemName: "photo")), failure: AnyView = AnyView(Image(systemName: "photo"))) {
        _loader = ObservedObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
    }

    private func selectImage() -> some View {
        switch loader.state {
        case .loading:
            return AnyView(loading.accentColor(Color.gray).scaledToFit()) //as? Image ?? loading
        case .failure:
            return AnyView(failure.accentColor(Color.gray).scaledToFit()) //as? Image ?? failure
        default:
            return AnyView(loader.loadedImage.renderingMode(.original).resizable())
        }
    }
}

private class Loader: ObservableObject {
    enum LoadState {
        case loading, success, failure
    }

    var loadedImage: Image
    @Published var state = LoadState.loading
    private var cancellable: AnyCancellable?

    init(url: String, defaultImage: Image = Image(systemName: "photo")) {
        self.loadedImage = defaultImage
        cancellable = loadImage(for: url).sink { [weak self] image in
            guard let loadImage = image else {
                self?.state = .failure
                return
            }
            self?.loadedImage =  Image(uiImage: loadImage)
            self?.state = .success
        }
    }
    
    private func loadImage(for url: String) -> AnyPublisher<UIImage?, Never> {
        return ImageLoader.shared.loadImage(from: url)
            .eraseToAnyPublisher()
    }
}

public final class ImageLoader {
    public static let shared = ImageLoader()

    private let cache: IImageCache
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 10
        return queue
    }()

    public init(cache: IImageCache = ImageCache()) {
        self.cache = cache
    }

    public func loadImage(from url: String) -> AnyPublisher<UIImage?, Never> {
        if let image = cache[url] {
            return Just(image).eraseToAnyPublisher()
        }
        guard let parsedURL = URL(string: url) else {
            return Just(nil).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: parsedURL)
            .map { (data, _) -> UIImage? in return UIImage(data: data) }
            .catch { _ in return Just(nil) }
            .handleEvents(receiveOutput: {[weak self] image in
                guard let image = image else { return }
                self?.cache[url] = image
            })
            .print("Image loading \(url):")
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

public protocol IImageCache: class {
    func image(for url: String) -> UIImage?
    func insertImage(_ image: UIImage?, for url: String)
    func removeAllImages()
    func removeImage(for url: String)
    subscript(_ url: String) -> UIImage? { get set }
}

public final class ImageCache: IImageCache {
    
    public init(config: Config = Config.defaultConfig) {
        self.config = config
    }

    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    private let lock = NSLock()
    private let config: Config
    
    public struct Config {
        public let countLimit: Int
        public let memoryLimit: Int

        public static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }

    public func image(for url: String) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
            return decodedImage
        }
        return nil
    }
    
    public func insertImage(_ image: UIImage?, for url: String) {
        guard let image = image else { return removeImage(for: url) }
        let decompressedImage = image.decodedImage()

        lock.lock(); defer { lock.unlock() }
        decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decompressedImage.diskSize)
    }
    
    public func removeAllImages() {
        lock.lock(); defer { lock.unlock() }
        decodedImageCache.removeAllObjects()
    }
    
    public func removeImage(for url: String) {
        lock.lock(); defer { lock.unlock() }
        decodedImageCache.removeObject(forKey: url as AnyObject)
    }

    public subscript(_ url: String) -> UIImage? {
        get { return image(for: url) }
        set { return insertImage(newValue, for: url) }
    }
}

fileprivate extension UIImage {
    func decodedImage() -> UIImage {
        guard let cgImage = cgImage else { return self }
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let decodedImage = context?.makeImage() else { return self }
        return UIImage(cgImage: decodedImage)
    }

    var diskSize: Int {
        guard let cgImage = cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
}

