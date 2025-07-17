extends Node

# Generate simple audio streams programmatically
func generate_gunshot_sound() -> AudioStreamWAV:
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_8_BITS
	stream.mix_rate = 22050
	stream.stereo = false
	
	# Generate a simple "pop" sound
	var data = PackedByteArray()
	var duration = 0.1  # 100ms
	var samples = int(duration * stream.mix_rate)
	
	for i in range(samples):
		var t = float(i) / samples
		var amplitude = 127 * (1.0 - t) * sin(t * 50)  # Decaying sine wave
		data.append(int(amplitude) + 128)  # Convert to unsigned 8-bit
	
	stream.data = data
	return stream

func generate_impact_sound() -> AudioStreamWAV:
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_8_BITS
	stream.mix_rate = 22050
	stream.stereo = false
	
	# Generate a simple "thud" sound
	var data = PackedByteArray()
	var duration = 0.15  # 150ms
	var samples = int(duration * stream.mix_rate)
	
	for i in range(samples):
		var t = float(i) / samples
		var amplitude = 100 * (1.0 - t * t) * sin(t * 30)  # Decaying sine wave with different frequency
		data.append(int(amplitude) + 128)  # Convert to unsigned 8-bit
	
	stream.data = data
	return stream 