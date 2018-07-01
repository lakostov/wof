	# Ruby code file - All your code should be located between the comments provided.

	# Add any additional gems and global variables here
	require 'sinatra'

	# The file where you are to write code to pass the tests must be present in the same folder.
	# See http://rspec.codeschool.com/levels/1 for help about RSpec
	require "#{File.dirname(__FILE__)}/wad_wof_gen_01"

	# Main program
	$games_payed=0
	$games_won=0
	$total_score=0
	$won=false
	$solve=false

	module WOF_Game
		@input = STDIN
		@output = STDOUT
		g = Game.new(@input, @output)
		playing = true
		playing_console = true
		#input = ""
		#menu = ""
		#guess = ""
		#secret = ""
		#filename = "wordfile.txt"
		#turn = 0
		#win = 0
		#game = ""
		#words = 0

    #Increments global track variables games_won and total_score used in the global statistics tracking both versions of the game.
	def self.set_games_won game
	$games_won += 1
	$total_score += game.score
	end

    #Increments global track variable games_played in the global statistics tracking both versions of the game.
	def self.set_global_games_played
	$games_payed += 1
	end
    
    #Renders a console version of the board for taking user's guess
	def self.render_board game
	@output.puts " "
	@output.puts "Clue: #{game.secret_clue}"
	@output.puts "Number of words: #{game.num_words}"
	@output.puts ("#{game.resulta}").gsub(",","")
	@output.puts "Total score: #{game.score}"
	@output.puts "Turns left: " + game.check_last_turn
	@output.puts "Letters tried: #{game.resultb.sort}"
	@output.puts "#{game.message}"
	end

    #Renders a console version of the board for displaying result of user's guess
	def self.render_board_result game
	@output.puts " "
	@output.puts "Result:"
	@output.puts ("#{game.resulta}").gsub(",","")
	@output.puts "Guessed #{game.num_guessed}"
	@output.puts "Total score: #{game.score}"
	@output.puts "Turns left: " + game.check_last_turn
	@output.puts "Letters tried: #{game.resultb.sort}"
	@output.puts " "
	end

        #While loop for playing game allowing to switch between console and web game
		while playing do
			g.start #Renders game's main menu
			@output.puts "Enter any other key to exit the game" #game exits if no game is selected
			game = @input.gets.chomp
			if game == "1"
				@output.puts "Command line game"
			elsif game == "2"
				g.resetgame
				@output.puts "Web-based game"
				@output.puts " "
				@output.puts "Open a web browser and navigate to localhost:4567"
				@output.puts " "
				break
			else
				@output.puts "Goodbye!"
				exit
			end


			if game == "1"

				# Any code added to command line game should be added below.

				playing_console = true #flag variable for console game
                
                # Console Game Engine
				def self.play g
					playing_console = true
					g.break_flag = false
					g.init_word_board
					if !g.spin_flag
					    @output.puts " "
					    @output.puts "Clue: #{g.secret_clue}"
						@output.puts "Number of words: #{g.num_words}"
						@output.puts ("#{g.resulta}").gsub(",","")
					end
					while g.turnsleft > 0 do
						if !g.spin_flag
						if g.turnsleft > 1
						@output.puts " "
						@output.puts "Spin the wheel for reward points or solve the puzzle."
						@output.puts " "
						@output.puts "Possible Rewards:"
						@output.puts " "
						@output.puts ("#{g.wheel}").gsub(",","")
						spin = ""
						not_valid_input = true
						while not_valid_input do
								@output.puts " "
								@output.puts "Enter 1 to spin the wheel or 2 to solve the puzzle."
								spin = @input.gets.chomp
							if spin == "1"
							special=true
							while special do
							out = g.spin  # Step1
							@output.puts "Spinning..."
							@output.puts " "
							case out
							when "1"
								@output.puts "You have one extra turn!"
								@output.puts " "
								@output.puts "Enter any key to spin again for reward"
								spin = @input.gets.chomp
							when "2"
								@output.puts "You lost one turn!"
								@output.puts " "
								@output.puts "Enter any key to spin again for reward"
								spin = @input.gets.chomp
							when "3"
								@output.puts "Bankrupt! You lost all your points!"
								@output.puts " "
								@output.puts "Enter any key to spin again for reward"
								spin = @input.gets.chomp
							else
								@output.puts "Reward #{g.reward} points for every uncovered letter."
								special = false
								not_valid_input = false
								spin = ""
							end
						    end
						    elsif spin =="2"
						    	@output.puts "Solve the puzzle."
						    	phrase = @input.gets.chomp
						    	valid_in = false
						    	while !valid_in do
						    	   if g.check_enter phrase
									playing_console = true
									throw :stop
								   else
	                               if g.validate_input_last phrase
	                                  valid_in = true
	                               else
	                                  @output.puts "Invalid input"
	                                  phrase = @input.gets.chomp
	                               end
	                               end
						        end
						    	if g.getguess phrase.upcase
	                            not_valid_input = false
	                            $won=true
	                            else
	                            #result
	                            render_board_result g
						    	end
						    else
						    	if g.check_enter spin
									playing_console = true
									throw :stop
								else
						    	@output.puts "Invalid Input!"
						        end
						    end #End if spin 1
						end #End while not valid input
					    end #End if turnsleft > 1
					    end # If not spin_flag
					    if g.turnsleft < 1 || $won
					    	break
					    end
					    if g.turnsleft > 1
						#board
					    render_board g
						guess = @input.gets.chomp.upcase
						valid = false
						while !valid do
	                    if g.validate_input guess
	                       valid = true
	                    else
	                       @output.puts "Invalid input"
	                       guess = @input.gets.chomp.upcase
	                    end
						end
						if g.check_enter guess
							playing_console = true
							throw :stop
						end
						if g.getguess guess # Step2
							break
						end
						if g.break_flag
							playing_console = true
							throw :stop
						end
					    else
					    	if g.spin_flag
					    	#board
					    	render_board g
					        end
						@output.puts "Solve the puzzle"
						guess = @input.gets.chomp.upcase
						valid = false
						while !valid do
	                    if g.validate_input_last guess
	                       valid = true
	                    else
	                       @output.puts "Invalid input"
	                       guess = @input.gets.chomp.upcase
	                    end
						end
						if g.check_enter guess
							playing_console = true
							throw :stop
						end
						if g.getguess guess
							break
						end
						if g.break_flag
							playing_console = true
							throw :stop
						end
					    end #End if turnsleft > 1
					    #result
						render_board_result g
						if g.turnsleft < 1
					    	break
					    end
					end #end while loop
					if  g.win
						set_games_won g
						@output.puts " "
						@output.puts "Congratulations! You won!"	
					else
						g.score = 0
						@output.puts " "
						@output.puts "You lost!"
					end
					g.show_phrase
					@output.puts "**************************************"
					@output.puts "Secret word/phrase:"
					@output.puts "#{g.resulta}"
					@output.puts " "
					@output.puts "Total score: #{g.score}"
					@output.puts "**************************************"
					@output.puts "Game over!"
					@output.puts "**************************************"
					@output.puts " "
					@output.puts " "
					@output.puts " "
					set_global_games_played
					g.resetgame
				end
				# End of Console Game Engine
                
                #Console Game loop
				while playing_console do
					#catches stops when the game is paused
					catch(:stop) do
						@output.puts " "
						@output.puts "Games played: #{$games_payed}"
						@output.puts "Games won: #{$games_won}"
						@output.puts "Accumulated score: #{$total_score}"
						if $games_payed > 0
						@output.puts "Success rate: #{(($games_won.to_f / $games_payed.to_f)*100).round(1)}%"
					    end
						@output.puts " "
						@output.puts " "
						g.displaymenu
						@output.puts " "
						@output.puts "Enter empty input at any stage during the game to pause the game and go back to this menu."
						menu_action = @input.gets.chomp


						if menu_action == "1"
							playing_console = true
							$won=false
							play g

						elsif menu_action == "2"
							g.resetgame
							$won=false
							playing_console = true
							play g
						elsif menu_action == "3"
							if g.game_analysis.empty?
							@output.puts " "
							@output.puts "How to play:"
							@output.puts " "
							@output.puts "You have 5 turns to solve the puzzle."
							@output.puts "Spin the wheel to get reward points and try to guess a letter."
							@output.puts "Or if you think you can, try to solve the puzzle."
							@output.puts "Get reward for every guessed letter"
							@output.puts "Win extra 2000 point if you solve the puzzle."
							@output.puts "One turn is taken for every wrong guess."
							@output.puts "Good luck!"
							@output.puts " "
						else
							@output.puts " "
							@output.puts "********************************************************"
							@output.puts "* Game Analysis ****************************************"
							@output.puts "********************************************************"
							@output.puts " "
							@output.puts "Current state:"
							@output.puts " "
					        @output.puts "Clue: #{g.secret_clue}"
						    @output.puts "Number of words: #{g.num_words}"
						    @output.puts ("#{g.resulta}").gsub(",","")
						    @output.puts " "
						    @output.puts "Steps taken:"
							g.game_analysis.each do |key, value|
							@output.puts "********************************************************"
							@output.puts " "
							if key.start_with?("Spin")
	                        @output.puts "Spin: "
							else
							@output.puts "#{key}"
						    end
							@output.puts " "
							        value.each do |k, v|
							@output.puts "#{k}: #{v}"
							        end
							    end
							@output.puts "********************************************************"
						end
							playing_console = true
						elsif menu_action == "9"
							@output.puts "Quit"
							playing_console = false
							playing = true
							break
						else
							@output.puts "Invalid input!"
							playing_console = true
						end
					end #catch stop
				end #End while playing_console

				# Any code added to command line game should be added above.
				#exit	# Does not allow command-line game to run code below relating to web-based version
			end   #End If game
		end   # While playing
	end
	# End modules

	# Sinatra routes

	# Any code added to web-based game should be added below.

    #***************************************************************************************************
    #The web-based game uses a self created look and feel and self created animation.
    #The animation for the wheel is self created in Adobe Animate CC and exported as HTML5 cancas animation 
    #The statistics view uses http://www.chartjs.org/ libraries to render animated statistics chart
    #***************************************************************************************************
    #Web_Game class inheriting the WOF_Game - Game class
	class Web_Game < WOF_Game::Game
		#spin overriding the parent class spin method
		def spin reward_index
				@spin_flag = true
				@reward=@wheel[reward_index]
				@spin_counter+=1
				set_spin_analysis
				case reward_index
				when 12
					@score = 0
				when 14
					@turn -= 1
					getturnsleft
					
				when 16
					incrementturn
			    when 22
					@score = 0
				end
		end
		#End of spin

		#Method seting global statistics
		def set_games_won
	        $games_won += 1
	        $total_score += @score
	    end

        #Method seting global statistics
	    def set_global_games_played
	        $games_payed += 1
	    end
	end

	#Instance of the Web_Game class
	g=Web_Game.new(nil,nil)

    #Root
	get '/' do
	g.console = false
	g.init_word_board
	erb :start #Web game manu
	end
	#End Root

    #spin
	get '/spin' do
		if g.turnsleft < 2
	       $solve=true #Flag variable for solvin the puzzle option selected
	       g.message = "Solve the puzzle"
	       redirect '/board'
	    else
	       $solve=false
	    end
		if g.spin_flag #Flag variable for state of the game (wheel span or not)
	    redirect '/board'
	    else
	    if g.web_initial #Flag variable for initial state of the game
	    	g.web_initial = false
	    end
		@game=g
		erb :spin
	    end
	end
	#End spin
    
    #Get board
	get '/board/?:solve?' do
	if params[:solve]
		g.spin_flag = true
		$solve=true
		g.message = "Solve the puzzle"
	end
	@game=g
	erb :board
	end
	#End Get board

    #Post board
	post '/board' do
	@game=g
	if g.validate_input params[:guess]
	if g.turnsleft > 1
	g.message = "Guess a letter from the word/phrase."
	else
	g.message = "Solve the puzzle"
	end
	guess = params[:guess].upcase
	else
	g.spin_flag = true
	g.message = "Invalid input"
	redirect '/board'
	end
		if g.getguess guess
		g.game_over = true
	    redirect '/win'
	    end
	    if g.turnsleft < 1
	    	g.game_over = true
	    	redirect '/win'
	    end
	    if g.turnsleft < 2
	    	g.spin_flag = true
	    	$solve=true
	    	g.message = "Solve the puzzle"
	    end
	    erb :board
	end
	#End Post board

    #Get win
	get '/win' do
	@game=g
	if g.game_over
	erb :win
	else
	redirect '/'
	end
	end
	#End Get win

    #Get new
	get '/new' do
	g.resetgame
	g.init_word_board
	redirect '/board'
	end
	#End Get new

    #Get analysis
	get '/analysis' do
	@game=g
	erb :analysis
	end
	#End Get analysis
    
    #Get statistics
	get '/statistics' do
	@game=g
	erb :statistics
	end
	#End Get statistics

	# Any code added to web-based game should be added above.

	# End program
