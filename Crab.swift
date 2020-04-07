// REVIEW: May want to put the model matrix generation in here, since each crab has its own
// and calling "getTransformMatrix" or something is cleaner in your render loop than generating
// it. (Also, if you ever had objects that haven't moved, you could cache the matrix.)
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
