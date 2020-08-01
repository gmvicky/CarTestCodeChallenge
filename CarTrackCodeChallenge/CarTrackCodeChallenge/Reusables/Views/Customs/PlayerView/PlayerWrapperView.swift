//
//  PlayerView.swift
//  Speshe
//
//  Created by WT-iOS on 4/4/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreMedia
import RxGesture

class PlayerWrapperView: UIView, ViewCoderLoadable {
    
    @IBOutlet private weak var containerView: ContainerView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet private weak var playImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Internal Variables
    
    var videoURLString: String? {
      didSet {
        videoURLStringRelay.accept(videoURLString)
      }
    }
    
    var thumbnailURLString: String? {
      didSet {
        thumbnailURLStringRelay.accept(thumbnailURLString)
      }
    }
    
    var isMuted: Bool! {
      didSet {
        isMutedVideoRelay.accept(isMuted)
      }
    }
    
    private let videoURLStringRelay = BehaviorRelay<String?>(value: nil)
    private let thumbnailURLStringRelay = BehaviorRelay<String?>(value: nil)
    private let isMutedVideoRelay = BehaviorRelay(value: false)
    private let playbackStateRelay = BehaviorRelay(value: PlaybackState.stopped)
    private let loadingStateRelay = BehaviorRelay(value: LoadingState.loading)
    
    private var disposeBag = DisposeBag()
    
    private lazy var player: Player = {
      let player = Player()
      player.autoplay = false
      player.playbackLoops = true
      player.playerDelegate = self
      return player
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLoadableView()
        configureView()
        refreshPlayer()
        
    }
    
    func refreshPlayer() {
       playImageView.isHidden = false
           
//       muteView.isHidden = false
//       muteView.isMuted.value = false
       
       previewImageView.isHidden = false
       previewImageView.image = nil
        previewImageView.backgroundColor = .clear
       
       player.stop()
       player.url = nil
       
       loadingStateRelay.accept(.loading)
       
       disposeBag = DisposeBag()
       setUpObservers()
    }
    
    private func configureView() {
      containerView.backgroundColor = .clear
      containerView.transition(to: player)
      PlayerWrapperManager.shared.addPlayer(player)
      
      previewImageView.backgroundColor = .lightGray
        playImageView.image = playImageView.image?.resize(withMinimumSize: CGSize(width: 50, height: 50))
    }
    
    private func setUpObservers() {
      // Image preview
      thumbnailURLStringRelay
        .unwrap()
        .map { URL(string: $0) }
        .asDriver(onErrorJustReturn: nil)
        .drive(onNext: { [weak self] in
          guard let `self` = self, let url = $0 else { return }
          self.previewImageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2))
        })
        .disposed(by: disposeBag)
      
//      previewImageView.rx.observeWeakly(UIImage.self, "image")
//        .unwrap()
//        .asDriver(onErrorJustReturn: UIImage())
//        .drive(onNext: { [weak self] _ in
//          self?.previewImageView.backgroundColor = .black
//        })
//        .disposed(by: disposeBag)
      
      playbackStateRelay
        .map { $0 == .stopped }
        .not()
        .asDriver(onErrorJustReturn: true)
        .drive(previewImageView.rx.isHidden)
        .disposed(by: disposeBag)
      
      // Video
      let videoTapGesture = containerView.rx.tapGesture()
        .when(.recognized)
        .filter { [weak self] _ in self?.videoURLString != nil }
        .asDriver(onErrorJustReturn: UITapGestureRecognizer())
      
      videoTapGesture
        .filter { [weak self] _ in self?.player.url == nil }
        .drive(onNext: { [weak self] _ in
          guard let `self` = self,
            let videoURLString = self.videoURLString else { return }
          self.previewImageView.isHidden = true
          self.player.url = URL(string: videoURLString)
        })
        .disposed(by: disposeBag)
      
      videoTapGesture
        .drive(onNext: { [weak self] _ in
          PlayerWrapperManager.shared.seekAllPlayersToBeginning(exceptFrom: self?.player)
          PlayerWrapperManager.shared.stopAllPlayers(exceptFrom: self?.player)
        })
        .disposed(by: disposeBag)

      videoTapGesture
        .drive(onNext: { [weak self] _ in
          guard let `self` = self else { return }
          switch self.player.playbackState {
          case .stopped:
            self.player.playFromBeginning()
          case .paused:
            self.player.playFromCurrentTime()
          case .playing:
            self.player.pause()
          default: break
          }
        })
        .disposed(by: disposeBag)

      videoTapGesture
        .map { [weak self] _ in self?.player.playbackState == .playing }
        .drive(playImageView.rx.isHidden)
        .disposed(by: disposeBag)
      
      // Loading indicator
      let tapGesture = videoTapGesture
        .asObservable()
        .mapTo(true)
      
      let isPlaying = playbackStateRelay
        .map { $0 == .playing }
      
      let isBufferring = loadingStateRelay
        .map { $0 == .loading }
      
      Observable.combineLatest(tapGesture, isPlaying, isBufferring) { $0 && $1 && $2 }
        .debug()
        .asDriver(onErrorJustReturn: false)
        .drive(activityIndicator.rx.isAnimating)
        .disposed(by: disposeBag)
      
      // Mute/unmute
//      isMutedVideoRelay
//        .asDriver()
//        .drive(muteView.rx.isHidden)
//        .disposed(by: disposeBag)
      
      isMutedVideoRelay
        .asDriver()
        .drive(onNext: { [weak self] in
          self?.player.muted = $0
        })
        .disposed(by: disposeBag)
      
//      let isMuted = muteView.rx.tapGesture()
//        .when(.recognized)
//        .map { [weak self] _ in
//          self?.player.muted ?? false
//        }
//        .asDriver(onErrorJustReturn: false)
//
//      isMuted
//        .drive(onNext: { [weak self] in
//          self?.player.muted = !$0
//        })
//        .disposed(by: disposeBag)
//
//      isMuted
//        .map { !$0 }
//        .drive(muteView.isMuted)
//        .disposed(by: disposeBag)
    }
}

extension PlayerWrapperView: PlayerDelegate {
    func playerReady(_ player: Player) {
            
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
      playbackStateRelay.accept(player.playbackState)
    }
    
    func playerLoadingStateDidChange(_ player: Player) {
      loadingStateRelay.accept(player.loadingState)
    }
    
    
}


// MARK - PlayerManager

private class PlayerWrapperManager {
  
  static let shared = PlayerWrapperManager()
  
  private init() { }
  
  private let players = NSPointerArray.weakObjects()
  
  func addPlayer(_ player: Player) {
    let pointer = Unmanaged.passUnretained(player).toOpaque()
    players.addPointer(pointer)
  }
  
  func stopAllPlayers(exceptFrom player: Player? = nil) {
    players.allObjects.forEach {
      if let object = $0 as? Player, object != player {
        object.stop()
      }
    }
  }
  
  func seekAllPlayersToBeginning(exceptFrom player: Player? = nil) {
    players.allObjects.forEach {
      if let object = $0 as? Player, object != player {
        object.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
      }
    }
  }
  
}
