# 1 setup game inviroment. Define a class
# 2 Initialize game variables: Set variables for the players score, current frame number, and wheter the player is in the first or second roll of the frame, number of players. Number of pins knocked down
# 2a ask how many players are participating
# 3 create a loop: start a new fram: begin with the first frame of the game with the 1st player.
# 4 player input: allow the player to input the number of pins knocked down in their roll
# 5 check for strikes or spares. determine if the current frame rresults in a strike or spare, and update the score accordingly
#6  update the fram score: calculate the score for the current fram based on the number of pins.







# 1
class BowlingGame 
  def intialize(input_options)
    @player_score = [:player_score]
    @current_frame = [:current_frame]
    @roll_number = [:roll_number]
    @number_of_players = [:number_of_players]
  end 

# 2
player_score = []
current_frame = 1
roll_number = 1  
pins = 0
# 2a
puts "How many players are in the game?"
number_of_players = gets.chomp.to_i 
# 3 
while current_frame < 11
# 4 
  puts "How many pins did you knock down with your first roll?"
  pins = gets.chomop.to_1 
  # 5   

end  