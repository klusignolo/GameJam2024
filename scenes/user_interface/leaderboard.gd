extends HBoxContainer

@onready var score_label_dict = {
	1: $LevelOneContainer/LevelOneScoreLabel,
	2: $LevelTwoContainer/LevelTwoScoreLabel,
	3: $LevelThreeContainer/LevelThreeScoreLabel
}
func load_high_scores():
	var high_scores = await Leaderboard.get_top_scores()
	for level_num in high_scores.keys():
		var level_scores = high_scores[level_num]
		var label_text = "Level " + str(level_num) + "\n"
		for i in range(5):
			var score = level_scores[i] if i < level_scores.size() else null
			if score:
				label_text += score.player_name + ": " + format_time(score.score) + "\n"
			else:
				label_text += "--\n"
		score_label_dict[level_num].text = label_text
	
func format_time(time_in_ms: int) -> String:
	var total_seconds: int = int(time_in_ms / 1000.0)
	var minutes: int = total_seconds / 60
	var seconds: int = total_seconds % 60
	var milliseconds: int = time_in_ms % 1000
	if minutes > 0:
		return "%d:%02d.%03d" % [minutes, seconds, milliseconds]
	else:
		return "%02d.%03d" % [seconds, milliseconds]
	
