extends Control

## Game data that contains information related to the current game state.
var game_data: GameData = GameData.new()
## JSON containing the questions to be asked during the game
const QUESTIONS: JSON = preload("res://Data/questions.json")
## Number of questions to ask before the game ends
@export var game_length: int = 3
var button_order: Array[String] = ["good", "evil"]
var current_question: int = 0
var questions_asked: int = 0
## Dictionary containing the strings to show at the end of the game.
const ENDINGS: Dictionary[String, String] = {
	"good": "Look at you, the absolute pinnacle of human decency! You made the right choices, spread kindness like a pro, and probably even recycle. If the world had more people like you, it would be a much better place. Enjoy your well-earned moral superiority—you’ve earned it.",
	"evil": "Well, you certainly committed to the bit. No hesitation, no second thoughts—just pure, unfiltered chaos. And you know what? It worked. Nobody's here to stop you, and frankly, you seem to be doing just fine. Villains don’t always lose, after all. Enjoy your empire of mischief, you earned it.",
	"neutral": "A little good, a little bad—you really kept your options open, huh? Some might call it balance, others might call it indecision. Either way, you made it through without completely ruining everything or achieving sainthood. That’s… something! Now go forth, morally flexible one, and keep doing whatever it is you do."
}

const ALIGNMENT_SYMBOL = {
	"good": "😇",
	"evil": "😈",
}

# Selectors
@onready var question_label: RichTextLabel = %QuestionLabel
@onready var option_0_button: Button = %Option0Button
@onready var option_1_button: Button = %Option1Button
@onready var question_container: VBoxContainer = %QuestionContainer

@onready var load_button: Button = %LoadButton
@onready var save_button: Button = %SaveButton

@onready var outcome_label: RichTextLabel = %OutcomeLabel
@onready var continue_button: Button = %ContinueButton
@onready var outcome_container: VBoxContainer = %OutcomeContainer

@onready var alignment_label: RichTextLabel = %AlignmentLabel

func _ready() -> void:
	game_data.questions_to_be_asked = range(QUESTIONS.data.size()) 
	game_data.questions_to_be_asked.shuffle()
	option_0_button.pressed.connect(_on_option_selected.bind(0))
	option_1_button.pressed.connect(_on_option_selected.bind(1))
	new_turn()
	continue_button.pressed.connect(new_turn)

func new_turn() -> void:
	if game_data.questions_to_be_asked.size() == 0 or questions_asked >= game_length:
		end_game()
		return

	outcome_container.visible = false
	current_question = game_data.questions_to_be_asked.pop_front()
	button_order.shuffle()
	question_label.text = QUESTIONS.data[current_question]["question"]
	_set_button_text(option_0_button, 0)
	_set_button_text(option_1_button, 1)
	question_container.visible = true
	
func _on_option_selected(index: int) -> void:
	questions_asked += 1
	question_container.visible = false

	# Alignment is either good or evil
	var alignment: String = button_order[index]
	_set_outcome_text(alignment)
	_update_aligment_label(alignment)

	if alignment == "good":
		game_data.good += 1
	else:
		game_data.evil += 1

	outcome_container.visible = true

func end_game() -> void:
	question_container.visible = false

	var ending: String
	if game_data.evil == game_length:
		ending = ENDINGS["evil"]
	elif game_data.good == game_length:
		ending = ENDINGS["good"]
	else:
		ending = ENDINGS["neutral"]
	outcome_label.text = ending
	outcome_container.visible = true
	
func _set_button_text(button: Button, index: int) -> void:
	# Alignment is either good or evil
	var alignment: String = button_order[index]
	button.text = QUESTIONS.data[current_question]["answer"][alignment]

## Sets the outcome text based on the player answer
func _set_outcome_text(alignment: String) -> void:
	# Alignment is either good or evil
	outcome_label.text = ALIGNMENT_SYMBOL[alignment] + "\n" + QUESTIONS.data[current_question]["outcome"][alignment]

func _update_aligment_label(alignment: String) -> void:
	alignment_label.text += ALIGNMENT_SYMBOL[alignment]
