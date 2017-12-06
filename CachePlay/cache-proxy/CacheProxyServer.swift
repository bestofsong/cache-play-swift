import Foundation

public class CacheProxyServer: NSObject, URLSessionDataDelegate {
  lazy var urlSession: URLSession = {
    let sessionConf = URLSessionConfiguration.default
    sessionConf.networkServiceType = .video
    let session = URLSession(configuration: sessionConf,
                             delegate: self,
                             delegateQueue: nil)
    return session
  }()
  
  
  static let instance: CacheProxyServer = {
    let ret = CacheProxyServer()
    return ret
  }()
  
  func start() throws -> Void {
  }
}
