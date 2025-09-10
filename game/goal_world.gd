extends RichTextLabel

signal word_completed

var current_word: String = ""
var revealed_letters: Array = []  # keeps track of letters added by player

func set_word(word: String):
	revealed_letters.clear()
	current_word = word
	_update_word()

func add_letter(letter: String):
	revealed_letters.append(letter)
	_update_word()

func _update_word():
	clear()
	var result := ""
	var all_found := true
	
	# Make a temporary copy so we can "consume" letters
	var temp_revealed = revealed_letters.duplicate()

	for i in current_word:
		if i == " ":
			result += " "
			continue

		var idx = temp_revealed.find(i)
		if idx != -1:
			# consume one instance of that letter
			temp_revealed.remove_at(idx)
			result += "[color=#ffffff]" + i + "[/color]"
		else:
			all_found = false
			result += "[u][color=#00000060]" + i + "[/color][/u]"

	append_text(result)
	
	if all_found:
		word_completed.emit()
