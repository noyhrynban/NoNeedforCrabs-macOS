import ScreenSaver
import MetalKit


class CrabScreenSaverView: ScreenSaverView {
    var metalKitView: MTKView
    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    
    var renderer: Renderer
    let screenRatio: Float
    var crabs: [Crab]

    override var frame: NSRect {
        didSet {
            self.metalKitView.frame = frame
        }
    }
    
    override init?(frame: NSRect, isPreview: Bool) {
        device = MTLCreateSystemDefaultDevice()!
        metalKitView = MTKView()
        commandQueue = device.makeCommandQueue()!
        renderer = Renderer(view: metalKitView, device: device)
        screenRatio = Float(frame.width / frame.height)
        crabs = []
        crabs.append(Crab(screenRatio: screenRatio))
        crabs.append(Crab(screenRatio: screenRatio))
        while crabs[1].yPosition == crabs[0].yPosition {
            crabs[1].yPosition = Crab.newYPosition()
        }
        
        super.init(frame: frame, isPreview: isPreview)
        
        metalKitView.device = device
        addSubview(metalKitView)
        
        // Set frame rate to 1 ÷ <desired frames per second>
        animationTimeInterval = 1.0 / 24.0
        startAnimation()
    }

    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveCrabs() -> () {
        crabs[0].xPosition += 1
        crabs[1].xPosition -= 1
        
        for i in 0..<crabs.count {
            let crab = crabs[i]
            if crab.xPosition % 4 == 0 {
                crab.flip = !crab.flip
            }
            if crab.xPosition > Int(200 * screenRatio + 15) {
                crab.xPosition = -15
                crab.yPosition = Crab.newYPosition()
                if i == 1 {
                    while crab.yPosition == crabs[0].yPosition {
                        crab.yPosition = Crab.newYPosition()
                    }
                }
            }
            if crab.xPosition < -15 {
                crab.xPosition = Int(floor(200 * screenRatio + 15))
                crab.yPosition = Crab.newYPosition()
                if i == 1 {
                    while crab.yPosition == crabs[0].yPosition {
                        crab.yPosition = Crab.newYPosition()
                    }
                }
            }
        }
    }

    override func draw(_ rect: NSRect) {
        renderer.draw(crabs: crabs)
    }

    override func animateOneFrame() {
        super.animateOneFrame()
        moveCrabs()
        setNeedsDisplay(_: metalKitView.frame)
    }
    
    class override func performGammaFade() -> Bool {
        return false
    }
}
