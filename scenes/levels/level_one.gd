extends WorldParent

func _ready():
	var rings = get_tree().get_nodes_in_group("Ring")
	Globals.ring_total = len(rings)
	UI.update_ring_score()
