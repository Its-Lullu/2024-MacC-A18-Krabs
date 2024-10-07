//
//  MetronomeOnOffUseCase.swift
//  Macro
//
//  Created by Yunki on 10/1/24.
//

import Foundation
import Combine

class MetronomeOnOffUseCase {
    private var jangdanAccentList: [Accent]
    private var bpm: Int
    private var currentBeat: Int
    
    var cancelBag: Set<AnyCancellable> = []
    var jangdanSubscription: AnyCancellable?
    var bpmSubscription: AnyCancellable?
    
    // timer
    private var timer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "metronomeTimer", qos: .background) // 다른 스레드
    private var interval: TimeInterval {
        60.0 / Double(bpm)
    }
    
    private var templateUseCase: JangdanSelectInterface
    private var beatDisplayUseCase: UpdateBeatDisplayInterface
    private var soundManager: PlaySoundInterface
    
    init(templateUseCase: JangdanSelectInterface, beatDisplayUseCase: UpdateBeatDisplayInterface, soundManager: PlaySoundInterface) {
        self.jangdanAccentList = []
        self.bpm = 120
        self.currentBeat = 0
        
        self.templateUseCase = templateUseCase
        self.beatDisplayUseCase = beatDisplayUseCase
        self.soundManager = soundManager
        
        self.jangdanSubscription = templateUseCase.jangdanPublisher.sink { [weak self] jangdan in
            guard let self else { return }
            self.jangdanAccentList = jangdan
        }
        self.jangdanSubscription?.store(in: &self.cancelBag)
        self.bpmSubscription = templateUseCase.bpmPublisher.sink { [weak self] bpm in
            guard let self else { return }
            self.bpm = bpm
        }
        self.bpmSubscription?.store(in: &self.cancelBag)
    }
}

// Play / Stop
extension MetronomeOnOffUseCase {
    func play() {
        // 데이터 갱신
        self.currentBeat = 0
        
        // Timer 설정
        if let timer { self.stop() }
        self.timer = DispatchSource.makeTimerSource(queue: self.queue)
        self.timer?.schedule(deadline: .now(), repeating: self.interval)
        self.timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            self.timerHandler()
        }
        
        // Timer 실행
        self.timer?.resume()
    }
    
    func stop() {
        self.timer?.cancel()
        self.timer = nil
    }
    
    private func timerHandler() {
        Task {
            await self.beatDisplayUseCase.nextBeat()
        }
        
        let accent: Accent = jangdanAccentList[self.currentBeat % jangdanAccentList.count]
        self.soundManager.beep(accent)
        self.currentBeat += 1
    }
}

// BPM 갱신
extension MetronomeOnOffUseCase {
    func updateBPM(to value: Int) {
        self.bpm = value
        // TODO: - 실행시켜보고 뭔가 이상하면 deadline 변경해볼것 [.now() + interval -> .now()]
        self.timer?.schedule(deadline: .now() + self.interval, repeating: self.interval)
    }
}