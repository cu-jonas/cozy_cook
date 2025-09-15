extends RichTextLabel

signal word_completed

var current_word: String = ""
var revealed_counts: Dictionary = {}  # { "a": 2, "t": 1, ... }

func set_word(word: String) -> void:
	revealed_counts.clear()
	current_word = word
	_update_word()

func add_letter(letter: String) -> void:
	if letter.is_empty():
		return
	var c := String(letter.substr(0, 1))  # use first character

	# Count how many of this char exist in the target word
	var total_in_word := 0
	for ch in current_word:
		if String(ch) == c:
			total_in_word += 1

	if total_in_word == 0:
		return  # not in the word → ignore

	var have := int(revealed_counts.get(c, 0))
	if have < total_in_word:
		revealed_counts[c] = have + 1
		AudioManager.play_sfx("LetterFound")
		_update_word()
	# else: already have enough of this letter → ignore

func _update_word() -> void:
	clear()
	var result := ""
	var all_found := true

	# While building, track how many reveals of each letter we've "spent"
	var used_so_far: Dictionary = {}  # { "a": 1, "t": 2, ... }

	for ch in current_word:
		var cs := String(ch)

		# Preserve spaces exactly (and skip styling for them)
		if cs == " ":
			result += " "
			continue

		var allowed_reveals := int(revealed_counts.get(cs, 0))
		var spent := int(used_so_far.get(cs, 0))

		if spent < allowed_reveals:
			# reveal this occurrence
			result += "[color=#ffffff]" + cs + "[/color]"
			used_so_far[cs] = spent + 1
		else:
			# still hidden
			all_found = false
			result += "[u][color=#00000060]" + cs + "[/color][/u]"

	append_text(result)

	if all_found and current_word.strip_edges() != "":
		word_completed.emit()
