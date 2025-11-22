//
//  VoiceSpeechService.swift
//  Keep
//
//  Created by admin on 15.11.2025.
//

import Foundation
import AVFoundation

protocol SpeechServiceProtocol {
    func speakText(_ text: String, language: String)
    func stopSpeaking()
}

final class VoiceSpeechService: SpeechServiceProtocol {
    private enum Constants {
        static let voiceRSSKey = "02a56aff3f004faab7cc28fb28857197"
        static let voiceRSSURL = "http://api.voicerss.org/"
        static let timeoutIntervalForRequest: TimeInterval = 30
        static let timeoutIntervalForResource: TimeInterval = 60
        static let minimumAudioDataSize = 100
    }
    
    private var audioPlayer: AVAudioPlayer?
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Constants.timeoutIntervalForRequest
        config.timeoutIntervalForResource = Constants.timeoutIntervalForResource
        return URLSession(configuration: config)
    }()
    
    func speakText(_ text: String, language: String) {
        let voiceLanguage = VoiceLanguage.fromLanguageCode(language)
        
        guard let url = buildURL(text: text, language: voiceLanguage) else {
            handleError(.invalidURL)
            return
        }
        
        stopSpeaking()
        
        urlSession.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.handleResponse(data: data, error: error)
            }
        } .resume()
    }
    
    func stopSpeaking() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}

// MARK: - Private Methods

private extension VoiceSpeechService {
    func buildURL(text: String, language: VoiceLanguage) -> URL? {
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        let urlString = "\(Constants.voiceRSSURL)?key=\(Constants.voiceRSSKey)&hl=\(language.rawValue)&src=\(encodedText)&c=MP3"
        return URL(string: urlString)
    }
    
    func handleResponse(data: Data?, error: Error?) {
        if let error = error {
            handleError(.networkError(error))
            return
        }
        
        guard let data = data else {
            handleError(.noAudioData)
            return
        }
        
        if let errorMessage = parseServiceError(from: data) {
            handleError(.serviceError(errorMessage))
            return
        }
        
        guard data.count >= Constants.minimumAudioDataSize else {
            handleError(.invalidAudioData)
            return
        }
        
        playAudioData(data)
    }
    
    func parseServiceError(from data: Data) -> String? {
        guard let responseString = String(data: data, encoding: .utf8),
              responseString.hasPrefix("ERROR:") else {
            return nil
        }
        return responseString
    }
    
    func playAudioData(_ data: Data) {
        do {
            try configureAudioSession()
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            handleError(.audioPlaybackError(error))
        }
    }
    
    func configureAudioSession() throws {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
    }
    
    func handleError(_ error: SpeechServiceError) {
        print(error.errorDescription ?? "Неизвестная ошибка")
    }
}
