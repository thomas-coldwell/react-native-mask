@objc(MaskViewManager)
class MaskViewManager: RCTViewManager {

  override func view() -> (MaskView) {
    return MaskView()
  }

  @objc override static func requiresMainQueueSetup() -> Bool {
    return false
  }
}

class MaskView : UIView {
  
  private let ciContext = CIContext(options: nil)
  private let greyscaleMaskToAlpha = CIFilter(name: "CIMaskToAlpha")!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.mask = createAlphaMask(maskView: reactSubviews().first!)
  }
  
  private func createAlphaMask(maskView: UIView) -> UIView? {
    // Rasterize the mask UIView
    let size = self.bounds.size
    if size == .zero { return nil }
    UIGraphicsBeginImageContextWithOptions(size, maskView.isOpaque, 0.0)
    maskView.layer.render(in: UIGraphicsGetCurrentContext()!)
    maskView.drawHierarchy(in: self.frame, afterScreenUpdates: true)
    let maskUIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    // UIImage -> CIImage
    let maskCIImage = CIImage(image: maskUIImage)!
    // Grayscale image to alpha
    greyscaleMaskToAlpha.setValue(maskCIImage, forKey: kCIInputImageKey)
    let alphaMask = greyscaleMaskToAlpha.outputImage!.cropped(to: maskCIImage.extent)
    // Create a UIView to use as the mask
    let alphaMaskView = UIView()
    alphaMaskView.frame = maskView.frame
    let alphaMaskLayer = CALayer()
    alphaMaskLayer.frame = maskView.frame
    alphaMaskLayer.contents = ciContext.createCGImage(alphaMask, from: alphaMask.extent)
    alphaMaskView.layer.addSublayer(alphaMaskLayer)
    return alphaMaskView
  }
  
  
  override func didUpdateReactSubviews() {
    // Get the mask view and
    let reactSubviews = reactSubviews()
    guard let reactSubviews = reactSubviews else { return }
    let maskView = reactSubviews.first
    if let maskView = maskView {
      // Need to add to subview so it actually gets laid out!
      maskView.isHidden = true
      self.addSubview(maskView)
    }
    // For all the other subviews add them as default (https://github.com/facebook/react-native/blob/7b05b091fd97f95b778369277ac2147730abc7b8/React/Views/UIView%2BReact.m#L172)
    if (reactSubviews.count <= 1) { return };
    for i in 1...(reactSubviews.count - 1) {
      self.addSubview(reactSubviews[i])
    }
  }
  
}
