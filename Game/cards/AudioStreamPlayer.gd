extends AudioStreamPlayer

var first = true

var p1 = preload("res://assets/music/HoliznaCC0 - Exploring Tomorrow Part 1.mp3")
var p2 = preload("res://assets/music/HoliznaCC0 - Exploring Tomorrow Part 2.mp3")
var p3 = preload("res://assets/music/HoliznaCC0 - Swingin\' Richards.mp3")
var p4 = preload("res://assets/music/HoliznaCC0 - WitchCraft.mp3")

var playlist = [p1,p2,p3,p4]


func _on_AudioStreamPlayer_finished():
	if first:
		randomize()
		playlist = playlist[randi() % playlist.size()]
		first = false
		
	var temp = playlist.pop_front()
	stream = temp
	playlist.push_back(temp)
	
