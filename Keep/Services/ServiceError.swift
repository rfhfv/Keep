//
//  ServiceError.swift
//  Keep
//
//  Created by admin on 15.11.2025.
//

import Foundation

enum SpeechServiceError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case noAudioData
    case serviceError(String)
    case invalidAudioData
    case audioPlaybackError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL-адрес"
        case .networkError(let error):
            return "Ошибка сервера: \(error.localizedDescription)"
        case .noAudioData:
            return "Аудиоданные не получены"
        case .serviceError(let message):
            return "Ошибка речевого сервиса: \(message)"
        case .invalidAudioData:
            return "Аудио не обнаружено"
        case .audioPlaybackError(let error):
            return "Ошибка воспроизведения аудио: \(error.localizedDescription)"
        }
    }
}
