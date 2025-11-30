
class SignalProcessor {
    
    private let minimumAmplitude: Float = 0.14
    
    // Smoothing buffer properties
    private let smoothingWindowSize = 5
    private var frequencyBuffer = [Float]()
    
    private func isValidSignal(amplitude: Float) -> Bool {
        return amplitude > minimumAmplitude
    }
    
    func process(_ pitch: Float, amplitude: Float) -> Float? {
        // Reduce sensitivity to background noise to prevent random / fluctuating data.
        guard isValidSignal(amplitude: amplitude) else {
            frequencyBuffer = []
            return nil
        }
        
        frequencyBuffer.append(pitch)
        if frequencyBuffer.count > smoothingWindowSize {
            frequencyBuffer.removeFirst()
        }
        
        return frequencyBuffer.reduce(0, +) / Float(frequencyBuffer.count)
    }
}
