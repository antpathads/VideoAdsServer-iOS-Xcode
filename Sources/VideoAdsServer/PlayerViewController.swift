import UIKit
import AVKit
import GoogleInteractiveMediaAds

final class PlayerViewController: UIViewController {

  private let contentURL = URL(string: "https://adserver.antpathads.com/videotest/videotest.mp4")!
  private let preRollTag = "https://adserver.antpathads.com/www/delivery/fc.php?script=apVideo:vast2&zoneid=1"
  private let midRollTag = "https://adserver.antpathads.com/www/delivery/fc.php?script=apVideo:vast2&zoneid=2"
  private let postRollTag = "https://adserver.antpathads.com/www/delivery/fc.php?script=apVideo:vast2&zoneid=3"

  private var player: AVPlayer!
  private var playerLayer: AVPlayerLayer!
  private var adsLoader: IMAAdsLoader!
  private var adsManager: IMAAdsManager?
  private var midrollRequested = false

  private let playButton: UIButton = {
    let b = UIButton(type: .system)
    b.setTitle("Play", for: .normal)
    b.titleLabel?.font = .boldSystemFont(ofSize: 18)
    return b
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    title = "AntPath Ads • iOS"

    player = AVPlayer(url: contentURL)
    playerLayer = AVPlayerLayer(player: player)
    playerLayer.videoGravity = .resizeAspect
    playerLayer.frame = view.bounds
    view.layer.addSublayer(playerLayer)

    playButton.addTarget(self, action: #selector(startPlayback), for: .touchUpInside)
    playButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(playButton)
    NSLayoutConstraint.activate([
      playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])

    let settings = IMASettings()
    settings.enableBackgroundPlayback = true
    adsLoader = IMAAdsLoader(settings: settings)
    adsLoader.delegate = self

    player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] _ in
      self?.checkForMidroll()
    }

    NotificationCenter.default.addObserver(self, selector: #selector(contentDidEnd),
                                           name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    playerLayer.frame = view.bounds
  }

  @objc private func startPlayback() { requestAds(with: preRollTag) }

  private func requestAds(with tag: String) {
    let container = IMAAdDisplayContainer(adContainer: view, viewController: self)
    let req = IMAAdsRequest(adTagUrl: tag, adDisplayContainer: container, contentPlayhead: nil, userContext: nil)
    adsLoader.requestAds(with: req)
  }

  private func checkForMidroll() {
    guard let item = player.currentItem else { return }
    let duration = item.duration.seconds
    let current = item.currentTime().seconds
    guard duration.isFinite && duration > 0 else { return }
    if !midrollRequested && current / duration >= 0.5 {
      midrollRequested = true
      requestAds(with: midRollTag)
    }
  }

  @objc private func contentDidEnd() { requestAds(with: postRollTag) }
}

extension PlayerViewController: IMAAdsLoaderDelegate, IMAAdsManagerDelegate {
  func adsLoader(_ loader: IMAAdsLoader, adsLoadedWith data: IMAAdsLoadedData) {
    adsManager = data.adsManager
    adsManager?.delegate = self
    adsManager?.initialize(with: IMAAdsRenderingSettings())
  }
  func adsLoader(_ loader: IMAAdsLoader, failedWith adErrorData: IMAAdLoadingErrorData) {
    print("Ad load error: \(adErrorData.adError.message)")
    player.play()
  }
  func adsManager(_ manager: IMAAdsManager, didReceive event: IMAAdEvent) {
    switch event.type {
    case .STARTED: print("Ad started")
    case .COMPLETE: print("Ad complete")
    default: break
    }
  }
  func adsManager(_ manager: IMAAdsManager, didReceive error: IMAAdError) {
    print("Ads error: \(error.message)")
    player.play()
  }
  func adsManagerDidRequestContentPause(_ manager: IMAAdsManager) { player.pause() }
  func adsManagerDidRequestContentResume(_ manager: IMAAdsManager) { player.play() }
}
