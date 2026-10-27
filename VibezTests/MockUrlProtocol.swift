import Foundation

class MockUrlProtocol: URLProtocol {
    nonisolated(unsafe) static var requestHandler: [String: ((URLRequest) throws -> (HTTPURLResponse, Data))] = [:]

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let urlString = request.url?.absoluteString,
              let handler = Self.requestHandler.first(where: {urlString.contains($0.key)})?.value else {
            fatalError("No mock handler registered for URL: \(request.url?.absoluteString ?? "nil")")
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
