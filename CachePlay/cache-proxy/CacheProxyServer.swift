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
  
}
