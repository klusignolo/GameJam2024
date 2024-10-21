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
		"api_key": silentwolf_api_key,
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
	
	
func get_top_scores() -> Dictionary:
	# Fetch leaderboard from SilentWolf
	print("Getting scores")
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(200
	).sw_get_scores_complete
	
	var score_dict = {1: [],2: [],3: []}
	var top_scores = []
	for score in sw_result.scores:
		var associated_score_level = 0
		# subtract the offset until raw score remains
		print("adjusting score")
		while score.score >= OFFSET:
			print("adjustment")
			score.score -= OFFSET
			associated_score_level += 1
		score_dict[associated_score_level].append(
			{ "player_name": score.player_name, "score": score.score }
		)
	var sorted_scores = score_dict.duplicate()
	for level_num: int in score_dict.keys():
		var level_scores = score_dict[level_num]
		level_scores.sort_custom(_sort_asc)
		sorted_scores[level_num] = level_scores.slice(0,5,1)
	return sorted_scores

func _sort_asc(a, b) -> bool:
	return a.score < b.score

func check_if_high_score(level: int, score_to_check: float) -> bool:
	if not is_configured: return false
	var top_scores = await get_top_scores()
	var top_level_scores = top_scores[level]
	var is_high_score = false
	if top_level_scores.size() < 5: return true
	for score in top_level_scores:
		if score_to_check < score.score:
			return true
	return false
	
