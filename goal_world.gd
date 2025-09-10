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
	clear()  # clear previous bbcode
	var result := ""
	
	var all_found = true
	
	# Build bbcode string per letter
	for i in current_word:
		
		#ignore spaces
		if i == ' ':
			result += " "
		
		if revealed_letters.has(i):
			# fully visible
			result += "[color=#ffffff]"+i+"[/color]"
		else:
			# faded out
			all_found = false
			result += "[u][color=#00000060]"+i+"[/color][/u]"
	
	append_text(result)
	if all_found:
		word_completed.emit()
