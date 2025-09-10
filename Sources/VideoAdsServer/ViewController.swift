import UIKit

final class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "AntPath Ads iOS"

    let btn = UIButton(type: .system)
    btn.setTitle("Play with Ads (IMA)", for: .normal)
    btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
    btn.addTarget(self, action: #selector(openPlayer), for: .touchUpInside)
    btn.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(btn)
    NSLayoutConstraint.activate([
      btn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      btn.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

  @objc private func openPlayer() {
    navigationController?.pushViewController(PlayerViewController(), animated: true)
  }
}
