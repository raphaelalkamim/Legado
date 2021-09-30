////
////  FileHelperAudio.swift
////  olds
////
////  Created by Caroline Taus on 29/09/21.
////
//
//import Foundation
//import UIKit
//import AVFoundation
//
//
//
//class FileHelperAudio{
//    
//    // achar diretorio onde salva os audio
//    static func getDocumentDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//    
//    
//    
//    static func saveAUdio() {
//        //Set arquivo do audio para armazenar no coreData
//        
//        
//        let audioFileName = UUID().uuidString + ".m4a"
//        let audioFileURL = getDocumentDirectory().appendingPathComponent(audioFileName)
//        
//        
//        
//        //sessão de audio
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord)), mode: .default)
//        } catch _ {
//        }
//        
//        // Define the recorder setting
//        
//        let recorderSetting = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
//        
//        audioRecorder = try? AVAudioRecorder(url: audioFileURL, settings: recorderSetting)
//        audioRecorder?.delegate = self
//        audioRecorder?.isMeteringEnabled = true
//        audioRecorder?.prepareToRecord()
//        
//    }
//    
//    
//    // salvar arquivo
//    
//    static func saveToFiles(audio: AVAudioRecorder?) -> String {
//        let recorderSetting = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
//        if let data = try? audio(URL(){
//            let directory = getDocumentDirectory()
//            let path = directory.appendingPathComponent("\(UUID().uuidString).jpeg")
//            try? data.write(to: path)
//            return path.lastPathComponent
//        }
//        return ""
//    }
//    
//    // deletar arquivo
//    static func deleteImage(path: String) -> Bool {
//        let imagePath = getDocumentDirectory().appendingPathComponent(path)
//        if FileManager.default.fileExists(atPath: imagePath.relativePath) {
//            try! FileManager.default.removeItem(at: imagePath)
//            return true
//        }
//        return false
//    }
//    
//    // buscar imagens
//    static func getFilePath(fileName: String) -> String {
//        let imagePath = getDocumentDirectory().appendingPathComponent(fileName)
//        return imagePath.relativePath
//    }
//    
//    static fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
//        return input.rawValue
//    }
//    
//}
//oi
