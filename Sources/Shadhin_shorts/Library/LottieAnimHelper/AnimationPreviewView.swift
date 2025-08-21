// Created by Cal Stephens on 6/23/23.
// Copyright © 2023 Airbnb Inc. All rights reserved.

import SwiftUI

// MARK: - AnimationPreviewView

struct AnimationPreviewView: View {

  // MARK: Lifecycle

  init(animationSource: AnimationSource) {
    self.animationSource = animationSource

    switch animationSource {
    case .remote(let urls, _):
      _currentURLIndex = State(initialValue: urls.startIndex)
      self.urls = urls
    default:
      _currentURLIndex = State(initialValue: 0)
      urls = []
    }
  }

  // MARK: Internal

  enum AnimationSource {
    case local(animationPath: String)
    case remote(urls: [URL], name: String)

    var name: String {
      switch self {
      case .local(let name):
        return name
      case .remote(_, let name):
        return name
      }
    }
  }

  let animationSource: AnimationSource

  var body: some View {
    VStack {
      if #available(iOS 15.0, *) {
        LottieView {
          try await Self.loadAnimation(
            from: animationSource,
            urls: urls,
            currentURLIndex: currentURLIndex
          )
        } placeholder: {
          LoadingIndicator()
            .frame(width: 50, height: 50)
        }
        .configuration(LottieConfiguration(renderingEngine: renderingEngine))
        .imageProvider(.exampleAppSampleImages)
        .logger(.printToConsole)
        .resizable()
        .reloadAnimationTrigger(currentURLIndex, showPlaceholder: false)
        .playbackMode(playbackMode)
        .animationDidFinish { completed in
          if completed {
            animationPlaying = false
          }
        }
        .configure { animationView in
          DispatchQueue.main.async {
            currentRenderingEngine = animationView.currentRenderingEngine
          }
        }
        .getRealtimeAnimationProgress(animationPlaying ? $sliderValue : nil)
      } else {
        Text("Requires iOS 15+")
      }

      Spacer()

      HStack {
        #if !os(tvOS)
        Slider(value: $sliderValue, in: 0...1, onEditingChanged: { editing in
          if animationPlaying, editing {
            animationPlaying = false
          }
        })

        Spacer(minLength: 16)
        #endif

        Button {
          animationPlaying.toggle()
        } label: {
          Image(systemName: animationPlaying ? "pause.fill" : "play.fill")
        }
      }
      .padding(.all, 16)
    }
    .navigationTitle(animationSource.name.components(separatedBy: "/").last ?? "Animation")
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.secondaryBackground)
    .onReceive(timer) { _ in
      updateIndex()
    }
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        Text((currentRenderingEngine ?? .coreAnimation).description)
        optionsMenu
      }
    }
  }

  // MARK: Private

  @State private var animationPlaying = true
  @State private var sliderValue: AnimationProgressTime = 0
  @State private var currentURLIndex: Int
  @State private var renderingEngine = RenderingEngineOption.automatic
  @State private var loopMode = LottieLoopMode.loop
  @State private var playFromProgress: AnimationProgressTime = 0
  @State private var playToProgress: AnimationProgressTime = 1
  @State private var currentRenderingEngine: RenderingEngine?

  private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
  private let urls: [URL]

  private var playbackMode: LottiePlaybackMode {
    if animationPlaying {
      .playing(.fromProgress(playFromProgress, toProgress: playToProgress, loopMode: loopMode))
    } else {
      .paused(at: .progress(sliderValue))
    }
  }

  @ViewBuilder
  private var optionsMenu: some View {
    #if !os(tvOS)
    Menu {
      Menu("Rendering Engine") {
        option("Automatic", keyPath: \.renderingEngine, value: .automatic)
        option("Core Animation", keyPath: \.renderingEngine, value: .coreAnimation)
        option("Main Thread", keyPath: \.renderingEngine, value: .mainThread)
      }

      Menu("Loop Mode") {
        option("Play Once", keyPath: \.loopMode, value: .playOnce)
        option("Loop", keyPath: \.loopMode, value: .loop)
        option("Autoreverse", keyPath: \.loopMode, value: .autoReverse)
      }

      Menu("Play from...") {
        option("0%", keyPath: \.playFromProgress, value: 0)
        option("25%", keyPath: \.playFromProgress, value: 0.25)
        option("50%", keyPath: \.playFromProgress, value: 0.5)
        option("75%", keyPath: \.playFromProgress, value: 0.75)
        option("100%", keyPath: \.playFromProgress, value: 1.0)
      }

      Menu("Play to...") {
        option("0%", keyPath: \.playToProgress, value: 0)
        option("25%", keyPath: \.playToProgress, value: 0.25)
        option("50%", keyPath: \.playToProgress, value: 0.5)
        option("75%", keyPath: \.playToProgress, value: 0.75)
        option("100%", keyPath: \.playToProgress, value: 1.0)
      }
    } label: {
      Image(systemName: "gear")
    }
    #endif
  }

  private static func loadAnimation(
    from animationSource: AnimationSource,
    urls: [URL],
    currentURLIndex: Int
  ) async throws -> LottieAnimationSource? {
    switch animationSource {
    case .local(let name):
      if name.hasSuffix(".lottie") {
        return try await DotLottieFile.named(name).animationSource
      } else {
        return LottieAnimation.named(name)?.animationSource
      }
    case .remote:
      return await LottieAnimation.loadedFrom(url: urls[currentURLIndex])?.animationSource
    }
  }

  private func updateIndex() {
    let currentIndex = currentURLIndex
    let nextIndex = currentIndex == urls.index(before: urls.endIndex) ? urls.startIndex : currentIndex + 1
    currentURLIndex = nextIndex
  }

  private func option<T: Equatable>(_ label: String, keyPath: ReferenceWritableKeyPath<Self, T>, value: T) -> some View {
    Button {
      self[keyPath: keyPath] = value
    } label: {
      Text(self[keyPath: keyPath] == value ? "✔ \(label)" : label)
    }
  }
}

// MARK: - Extensions

extension Color {
  static var secondaryBackground: Color {
    if #available(iOS 15.0, *) {
#if os(iOS)
      return Color(uiColor: .secondarySystemBackground)
#else
      return .clear
#endif
    } else {
      return .gray.opacity(0.1)
    }
  }
}

extension AnimationImageProvider where Self == FilepathImageProvider {
  static var exampleAppSampleImages: FilepathImageProvider {
    if #available(iOS 16.0, *) {
      return FilepathImageProvider(
        filepath: Bundle.main.resourceURL!.appendingPathComponent("Samples/Images"),
        contentsGravity: .resizeAspect
      )
    } else {
      return FilepathImageProvider(filepath: Bundle.main.bundleURL, contentsGravity: .resizeAspect)
    }
  }
}

// MARK: - LoadingIndicator

struct LoadingIndicator: View {
  @State private var animating = false

  var body: some View {
    Image(systemName: "rays")
      .rotationEffect(animating ? Angle.degrees(360) : .zero)
      .animation(
        Animation.linear(duration: 2).repeatForever(autoreverses: false),
        value: animating
      )
      .onAppear {
        animating = true
      }
  }
}

