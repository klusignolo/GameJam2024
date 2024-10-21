extends Node

# Constants for level score offsets
const OFFSET = 1000000000
const LEVEL_1_MAX = 1 * OFFSET
const LEVEL_2_MAX = 2 * OFFSET
const LEVEL_3_MAX = 3 * OFFSET
var silentwolf_api_key: String = ""
var is_configured = false

func configure_silentwolf():
	load_api_key()
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
	
	
func _get_top_scores() -> Dictionary:
	# Fetch leaderboard from SilentWolf
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(200
	).sw_get_scores_complete
	
	var score_dict = {1: [],2: [],3: []}
	var top_scores = []
	for score in sw_result.scores:
		var associated_score_level = 0
		# subtract the offset until raw score remains
		while score.score > OFFSET:
			score.score -= OFFSET
			associated_score_level += 1
		score_dict[associated_score_level].append(
			{ "player_name": score.player_name, "time_in_ms": score.score }
		)
	return score_dict
	
func check_if_high_score(level: int, score_to_check: float) -> bool:
	if not is_configured: return false
	var top_scores = await _get_top_scores()
	var top_level_scores = top_scores[level]
	var is_high_score = false
	for score in top_level_scores:
		if score_to_check > score.score:
			return true
	return false
	
