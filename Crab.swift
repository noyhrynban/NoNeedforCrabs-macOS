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
        // REVIEW: Here are some more "magic" numbers that I would want to pull out into
        // const values. Like... I'd maybe want to see instead of "20" having values like
        // VIEWPORT_HEIGHT = 200
        // NUM_CRAB_LANES = 10
        // CRAB_LANE_HEIGHT = VIEWPORT_HEIGHT / NUM_CRAB_LANES
        // return Int.random(in: 0..NUM_CRAB_LANES) * CRAB_LANE_HEIGHT
        // ...assuming that there's a syntax for "0..10" with only 2 dots where it's not inclusive
        // otherwise maybe "LAST_LANE_IDX = NUM_CRAB_LANES - 1" or just... use NUM_CRAB_LANES - 1?
        return Int.random(in: 0...9) * 20
    }
}
