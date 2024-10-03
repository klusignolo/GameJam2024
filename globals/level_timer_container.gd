extends Panel

var time := 0.0
var minutes := 0
var seconds := 0
var msec := 0
var is_running = false

func _process(delta: float) -> void:
	if is_running:
		time += delta
		update_labels_with_current_time()

func update_labels_with_current_time():
	msec = int(fmod(time, 1)) * 100
	seconds = int(fmod(time, 60))
	minutes = int(fmod(time, 3600) / 60)
	$MinutesLabel.text = "%02d:" % minutes
	$SecondsLabel.text = "%02d." % seconds
	$MillisecondsLabel.text = "%03d" % msec
	
func start():
	is_running = true
	set_process(true)
	
func stop():
	is_running = false
	set_process(false)
	
func reset():
	is_running = false
	time = 0.0
	update_labels_with_current_time()
	set_process(true)
	
func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msec]
