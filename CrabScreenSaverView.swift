import ScreenSaver
import MetalKit


class CrabScreenSaverView: ScreenSaverView {
    // REVIEW: This is a style thing, but most style guides I've seen have you mark your
    // member variables differently (like a prefix _ or prefix m_ or just m... something
    // so that when you assign and access them, other devs can see that these aren't local.
    // Like, I had to scroll up to check these when I saw them in the "init" function, like
    // "where did these come from?"
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
        
        // REVIEW: Ah, I see, only two crabs...
        crabs = []
        // REVIEW: I find it easier to work with "viewport" sizes rather than screen ratios.
        // So you typically (in GPU systems) have one dimension that is "fixed" (I think
        // usually vertical, but I'd have to play with Unity/Unreal cameras and see) and the
        // other expands to be wider/taller based on ratio.
        // But then, once you have that, I would just tell the crabs what the viewport bounds
        // are (could be 1.33x1, or 133x100, or any arbitrary anything, presumably) and let
        // them position themselves based on pre-calculated world sizes rather than re-deriving
        // that each frame. THIS app isn't really heavy enough to have it matter, but most apps
        // ARE that heavy, and reviewers (IME) like to see attention paid to avoiding redundant
        // work done in code.
        // Premature optimization is the root of all evil; but I would argue that caching a
        // value isn't optimization so much as making sure the work is only done in one place
        // so that if you need to change it, you don't end up with bugs where you forgot to
        // change all the places the work got done.
        crabs.append(Crab(screenRatio: screenRatio))
        crabs.append(Crab(screenRatio: screenRatio))
        
        // REVIEW: You do this while() loop in a couple places, and while it definitely works
        // in trivial-time (whatever that term is) for the 2 crabs choosing from 10 lanes case,
        // imagine if there were 9 crabs -- it might not finish within 1/24th of a frame! In
        // a for-work review I would ask to have a less "up to chance" algorithm for picking
        // a crab's lane.
        while crabs[1].yPosition == crabs[0].yPosition {
            crabs[1].yPosition = Crab.newYPosition()
        }
        
        super.init(frame: frame, isPreview: isPreview)
        
        metalKitView.device = device
        addSubview(metalKitView)
        
        // Set frame rate to 1 ÷ <desired frames per second>
        // REVIEW: I dunno if Swift supports constants or defines, but I would want to see
        // this 24.0 as a defined constant value somewhere and used as a variable here.
        // I've gotten a lot of review feedback about "magic numbers" like this. ;)
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
        
        // REVIEW: It's a little confusing how you have 2 crabs hardcoded, but SOME of
        // the logic is written for N-many crabs, but some assumes only 2 crabs...
        for i in 0..<crabs.count {
            let crab = crabs[i]
            // REVIEW: I would also put this into the Crab class, just... having each
            // object manage its own placement. (That said, coordinating crabs to
            // each other is tricker when each crab moves itself... Maybe a static
            // array that crabs have to claim lanes? (Since "lanes" is functionally
            // what's going on here, it might be good to make it more explicit via
            // variable names or something? People will tend to assume y-position
            // as a float and that crabs will overlap. I know what you're doing, but
            // the code may not "express" that well as-is to newcomers? Feel free to
            // chat me up to discuss more if this is frustrating feedback (which...
            // I imagine it could be...).)
            if crab.xPosition % 4 == 0 {
                crab.flip = !crab.flip
            }
            
            // REVIEW: I recommend caching the screen/viewport bounds rather than
            // recalculating every frame and every Crab. You'd hope a compiler might
            // optimize this, but it's not clear that it would in all cases here.
            if crab.xPosition > Int(200 * screenRatio + 15) {
                crab.xPosition = -15
                crab.yPosition = Crab.newYPosition()
                
                // REVIEW: ...like this is weird looking to me. At minimum I'd want
                // a comment explaining why the index-1 crab is special; but my
                // preference would be to make the whole algorithm a little more
                // explicit -- is it for 2 crabs or N crabs?
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
