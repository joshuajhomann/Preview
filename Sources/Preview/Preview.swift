import SwiftUI
import UIKit


@available(iOS 13.0, *)
public enum Preview {
  private struct ViewControllerWrapper: UIViewControllerRepresentable {
    private let factory: () -> UIViewController

    init(_ makeViewController: @escaping () -> UIViewController) {
      self.factory = makeViewController
    }

    func makeUIViewController(context: Context) -> UIViewController {
      factory()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
  }

  private struct ViewWrapper : UIViewRepresentable {

    private let factory: () -> UIView
    init(_ makeView: @escaping () -> UIView) {
      self.factory = makeView
    }

    func makeUIView(context: Context) -> UIView {
      factory()
    }

    func updateUIView(_ view: UIView, context: Context) { }
  }

  public static func makeView(_ makeView: @autoclosure @escaping () -> UIView) -> some View {
    ViewWrapper {
      let top = UIView()
      let bottom = UIView()
      let leading = UIView()
      let trailing = UIView()
      top.setContentHuggingPriority(.init(1), for: .vertical)
      bottom.setContentHuggingPriority(.init(1), for: .vertical)
      leading.setContentHuggingPriority(.init(1), for: .horizontal)
      trailing.setContentHuggingPriority(.init(1), for: .horizontal)
      let hStack = UIStackView(arrangedSubviews: [leading, makeView(), trailing])
      let vStack = UIStackView(arrangedSubviews: [top, hStack, bottom])
      vStack.axis = .vertical
      NSLayoutConstraint.activate([
        top.heightAnchor.constraint(equalTo: bottom.heightAnchor),
        leading.widthAnchor.constraint(equalTo: trailing.widthAnchor)
      ])
      return vStack
    }
  }

  public static func makeView(makeView: @escaping () -> UIView) -> some View {
    Self.makeView(makeView())
  }

  public static func make(_ makeViewController: @autoclosure @escaping () -> UIViewController) -> some View {
    ViewControllerWrapper(makeViewController)
      .edgesIgnoringSafeArea(.all)
  }

  public static func make(makeViewController: @escaping () -> UIViewController) -> some View {
    make(makeViewController())
      .edgesIgnoringSafeArea(.all)
  }

  public static func makeInNavigationController(_ makeViewController: @autoclosure @escaping () -> UIViewController) -> some View {
    ViewControllerWrapper {
      UINavigationController(rootViewController: makeViewController())
    }
  }

  public static func makeInNavigationController(makeViewController: @escaping () -> UIViewController) -> some View {
    makeInNavigationController(makeViewController())
  }

  public static func makeInTabbarController(_ makeViewController: @autoclosure @escaping () -> UIViewController) -> some View {
    ViewControllerWrapper {
      let tabbar = UITabBarController()
      tabbar.addChild(UINavigationController(rootViewController: makeViewController()))
      return tabbar
    }
  }

  public static func makeInTabbarController(makeViewController: @escaping () -> UIViewController) -> some View {
    makeInTabbarController(makeViewController())
  }
}


@available(iOS 13.0, *)
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Preview.makeInNavigationController(UIViewController())
      Preview.makeInNavigationController {
        let v = UIViewController()
        v.view.backgroundColor = .red
        return v
      }
      Preview.makeInTabbarController {
        let v = UIViewController()
        v.view.backgroundColor = .red
        return v
      }
      Preview.make {
        let v = UIViewController()
        v.view.backgroundColor = .blue
        return v
      }
      Preview.makeView {
        let v = UILabel()
        v.text = "Hello!"
        v.backgroundColor = .red
        return v
      }
    }
  }
}
