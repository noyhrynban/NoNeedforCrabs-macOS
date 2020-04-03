class Crab {
    var xPosition: Int
    var yPosition: Int
    var flip: Bool
    
    init(screenRatio: Float) {
        xPosition = Int.random(in: -15...(200 * Int(screenRatio) + 15))
        yPosition = Crab.newYPosition()
        flip = Bool.random()
    }
    
    init(xPosition: Int, yPosition: Int, flip: Bool) {
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.flip = flip
    }
    
    static func newYPosition() -> Int {
        return Int.random(in: 0...9) * 20
    }
}
