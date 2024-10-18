extends Node

# Constants for level score offsets
const OFFSET = 1000000000
var silentwolf_api_key: String = ""
var is_configured = false

func configure_silentwolf():
	if silentwolf_api_key == "": return
	SilentWolf.configure({
		"api_key": "",
		"game_id": "threeringcircus",
		"log_level": 0
	})
	SilentWolf.configure_scores({"open_scene_on_close": "res://scenes/main_menu.tscn"})
	is_configured = true

func load_api_key() -> void:
	var config_file = ConfigFile.new()
	var error = config_file.load("res://config.cfg")

	if error == OK:
		silentwolf_api_key = config_file.get_value("API", "silentwolf_key", "")
	else:
		print("Error loading config file: %s" % str(error))

# Method to add a score to SilentWolf leaderboard for a specific level
func add_score(player_name: String, time_in_ms: int, level: int) -> void:
	if not is_configured: return
	
	var score = time_in_ms + OFFSET * level

	# Add score to SilentWolf leaderboard
	var sw_result: Dictionary = await SilentWolf.Scores.save_score(player_name, score).sw_save_score_complete
	print("Score persisted successfully: " + str(sw_result.score_id))

# Method to retrieve top scores for a specific level from SilentWolf
func get_top_scores(level: int, top_n: int = 10) -> void:
	if not is_configured: return
	
	var offset = OFFSET * level
	var start_score_range = offset
	var end_score_range = offset + OFFSET
	
	# Fetch leaderboard from SilentWolf
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(200
	).sw_get_scores_complete
	_on_leaderboard_fetched(sw_result.scores, {"level": level, "offset": offset})

# Callback function once SilentWolf fetches the leaderboard
func _on_leaderboard_fetched(scores: Array, metadata: Dictionary) -> void:
	var level = metadata["level"]
	var offset = metadata["offset"]
	
	var top_scores = []
	for score in scores:
		var adjusted_score = score.score - offset
		top_scores.append({ "player_name": score.player_name, "time_in_ms": adjusted_score })

	# Now top_scores contains the adjusted times for the specific level
	print("Top scores for Level %d:" % level)
	for score in top_scores:
		print("Player: %s, Time: %d ms" % [score.player_name, score.time_in_ms])

# Custom sort function to sort by score (if needed locally)
func sort_by_score(a: Dictionary, b: Dictionary) -> int:
	return int(a.score) - int(b.score)
