import Foundation
import SwiftData

enum OpenAIServiceError: Error {
    case missingModel
    case invalidHTTPStatus(Int)
    case invalidResponse
    case decodingFailed
}

public struct OpenAIService {
    private static let endpoint = URL(string: "https://api.openai.com/v1/responses")!
    
    static func sendMessageOpenAI(message: Message, in conversation: Conversation, apiKey: String) async throws -> Message {
        
        let model = conversation.model ?? "gpt-4o-mini"
        
        let systemPrompt = conversation.agent?.prompt ?? ""
        
        let requestBody = ResponsesRequest(
            model: model,
            input: [
                ResponsesRequest.InputItem(
                    role: "system",
                    content: [ResponsesRequest.ContentPart(type: "text", text: systemPrompt)]
                ),
                ResponsesRequest.InputItem(
                    role: "user",
                    content: [ResponsesRequest.ContentPart(type: "text", text: message.content)]
                )
            ],
            temperature: nil
        )
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(requestBody)
        
        print(request)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAIServiceError.invalidResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw OpenAIServiceError.invalidHTTPStatus(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        let decodedResponse: ResponsesOutput
        do {
            decodedResponse = try decoder.decode(ResponsesOutput.self, from: data)
        } catch {
            throw OpenAIServiceError.decodingFailed
        }
        
        let reply = decodedResponse.output_text ??
            decodedResponse.output?.flatMap { $0.content ?? [] }.compactMap { $0.text }.joined(separator: "\n")
        
        guard let replyText = reply, !replyText.isEmpty else {
            throw OpenAIServiceError.invalidResponse
        }
        
        let responseMessage = Message(role: "assistant", content: replyText, conversation: conversation)
        return responseMessage
    }
    
    private struct ResponsesRequest: Encodable {
        let model: String
        let input: [InputItem]
        let temperature: Double?
        
        struct InputItem: Encodable {
            let role: String
            let content: [ContentPart]
        }
        
        struct ContentPart: Encodable {
            let type: String
            let text: String
        }
    }
    
    private struct ResponsesOutput: Decodable {
        let output_text: String?
        let output: [MessageBlock]?
        
        struct MessageBlock: Decodable {
            let role: String?
            let content: [Content]?
        }
        
        struct Content: Decodable {
            let type: String?
            let text: String?
        }
    }
}

// MARK: - Example usage

/*
import SwiftData

@MainActor
class ChatViewModel: ObservableObject {
    @Environment(\.modelContext) private var modelContext
    @Published var conversation: Conversation
    @Published var apiKey: String
    
    init(conversation: Conversation, apiKey: String) {
        self.conversation = conversation
        self.apiKey = apiKey
    }
    
    func sendMessage(_ message: Message) async {
        do {
            let assistantMessage = try await OpenAIService.sendMessageOpenAI(message: message, in: conversation, apiKey: apiKey)
            modelContext.insert(assistantMessage)
            try modelContext.save()
        } catch {
            // handle error
            print("OpenAIService error: \(error)")
        }
    }
}
*/
