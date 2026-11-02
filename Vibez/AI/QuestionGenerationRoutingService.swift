import Foundation
import FoundationModels

enum ActiveTier {
    case foundationModels
    case llamaModelDownloaded
    case llamaModelNeedsDownload
    case llamaModelDeclined
    case llamaModelNotPrompted
    case remoteOrStaticFallback
}

protocol QuestionGenerationRoutingProtocol: Sendable {
    var currentTierStatus: ActiveTier { get }
    var isLlamaModelApproved: Bool? { get nonmutating set}

    func downloadModel(progressHandler: @Sendable @escaping (Double) -> Void) async throws
    func generatePrompts(for overview: String) async throws -> [String]
}

struct QuestionGenerationRoutingService: QuestionGenerationRoutingProtocol {
    private let tier1Service: LLMWorkerServiceProtocol
    private let tier2Service: LLMWorkerServiceProtocol
    private let tier3Service: LLMWorkerServiceProtocol
    private let tier4Service: LLMWorkerServiceProtocol
    private let userDefaults: UserDefaults

    init(
        tier1Service: LLMWorkerServiceProtocol = FoundationModelsService(),
        tier2Service: LLMWorkerServiceProtocol = LlamaModelService(),
        tier3Service: LLMWorkerServiceProtocol = RemoteModelService(),
        tier4Service: LLMWorkerServiceProtocol = StaticService(),
        userDefaults: UserDefaults = .standard
    ) {
        self.tier1Service = tier1Service
        self.tier2Service = tier2Service
        self.tier3Service = tier3Service
        self.tier4Service = tier4Service
        self.userDefaults = userDefaults
    }

    var isLlamaModelApproved: Bool? {
        get { userDefaults.isLlamaModelApproved }
        nonmutating set { userDefaults.isLlamaModelApproved = newValue}
    }

    var currentTierStatus: ActiveTier {
        if tier1Service.isAvailable {
            return .foundationModels
        }

        switch isLlamaModelApproved {
        case .none:
            return .llamaModelNotPrompted
        case .some(false):
            return .remoteOrStaticFallback
        case .some(true):
            return tier2Service.isAvailable ? .llamaModelDownloaded : .llamaModelNeedsDownload
        }
    }

    var isAvailable: Bool {
        tier1Service.isAvailable
        || (isLlamaModelApproved == true && tier2Service.isAvailable)
        || tier3Service.isAvailable
    }

    func downloadModel(progressHandler: @escaping @Sendable (Double) -> Void) async throws {
        try await LlamaModelManager.shared.downloadModel(progressHandler: progressHandler)
    }

    func generatePrompts(for overview: String) async throws -> [String] {
        if tier1Service.isAvailable {
            return try await tier1Service.generatePrompts(for: overview)
        }

        if isLlamaModelApproved == true && tier2Service.isAvailable {
            return try await tier2Service.generatePrompts(for: overview)
        }

        if tier3Service.isAvailable {
            do {
                return try await tier3Service.generatePrompts(for: overview)
            } catch {
                print("Remote model calling failed, falling back to static prompts")
            }
        }

        return try await tier4Service.generatePrompts(for: overview)
    }

}
