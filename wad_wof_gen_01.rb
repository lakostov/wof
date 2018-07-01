		# Ruby code file - All your code should be located between the comments provided.

		# Main class module
		module WOF_Game
			# Input and output constants processed by subprocesses. MUST NOT change.
			GOES = 5

			class Game
				attr_reader :template, :filename, :phrases, :num_guessed, :wordtable, :console, :num_words, :wheel, :input, :output, :turn, :turnsleft, :reward, :winner, :secretword, :played, :score, :resulta, :resultb, :descr, :secret_clue, :guess, :spin_counter, :guess_counter, :break_flag, :spin_flag, :game_analysis, :statistic, :message, :web_initial, :win, :game_over
				attr_writer :template, :filename, :phrases, :num_guessed, :wordtable, :console, :num_words, :wheel, :input, :output, :turn, :turnsleft, :reward, :winner, :secretword, :played, :score, :resulta, :resultb, :descr, :secret_clue, :guess, :spin_counter, :guess_counter, :break_flag, :spin_flag, :game_analysis, :statistic, :message, :web_initial, :win, :game_over
	        
	        #Class constrictor, sets the initial game state
				def initialize(input, output)
					@input = input
					@output = output
					@played = 0
					@score = 0
					@wordtable = []
					@wheel = ["500","900","700","300","800","550","400","500","600","350","500","900","Bankrupt","650","Free spin","700","Lose a turn","800","500","450","500","300","Bankrupt","5000"]
					@template = ""
					@secretword = ""
					@turn = 0
					@turnsleft = GOES
					@reward = ""
					@num_guessed = 0
					@resulta = []
					@resultb = []
					@descr= []
					@secret_clue = ""
					@num_words = 0
					@console = true
					@break_flag = false
					@spin_flag = false
					@spin_counter=0
					@guess_counter=0
					@filename = "wordfile.txt"
					@phrases = ["Kind of animal that lives by water.","Heavy seabird.","Common wild bird.","Mohawk bird."]
					@game_analysis = Hash.new { |h, k| h[k] = Hash.new { |hh, kk| hh[kk] = {} } }
					@statistic = Hash.new { |h, k| h[k] = Hash.new { |hh, kk| hh[kk] = {} } }
				    @message="Guess a letter from the word/phrase."
				    @web_initial = true
				    @win = false
				    @game_over = false
				end
				
		    
	            #Method not used in this implementation
				#def storeguess(guess, index)
					#if guess != ""
						#@resulta = @resulta.to_a.push "#{guess}"
					#end
				#end

				# Any code/methods aimed at passing the RSpect tests should be added below.
			    def start
			    	@output.puts " "
			    	@output.puts "Welcome to WOF!"
		            @output.puts "Created by: #{created_by} (#{student_id})"
		            @output.puts "Starting game..."
		            @output.puts "Enter 1 to run the game in the command-line window or 2 to run it in a web browser"
			    end

	        #Increments the skore when the puzzle is solved
		        def incement_score
		    	    @score += 2000
		        end
	        
	        #Returns the student's name
			    def created_by
			    	"Lachezar Kostov and Dimitar Bakardzhiev"
		        end

	        #Returns the student's Id
		        def student_id
			    	51771125.51772509
		        end

	        #Displays the console game menu
		        def displaymenu # Console only
		           @output.puts "Menu: (1) Play | (2) New | (3) Analysis | (9) Exit"
		        end

	        #Resets the game to its initial state
		        def resetgame
		        	    @wordtable = []
						@secretword = ""
						@turn = 0
						@resulta = []
						@resultb = []
						@winner = 0
						@guess = ""
						@template = "[]"
						@turnsleft = GOES
						@score = 0
						@reward = ""
						@descr = []
						@num_words = 0
						@spin_flag = false
						@game_analysis.clear
						@spin_counter=0
						@guess_counter=0
						@num_guessed = 0
						@message = "Guess a letter from the word/phrase."
						@web_initial = true
						@win = false
						@game_over = false

		        end

	        #Reads words from text file and loads them in array
		        def readwordfile name
		        	l_num=0
		            File.open(name).each do |l|
		            	@wordtable[l_num] = l.gsub("\r","").gsub("\n","")
		            l_num +=1
		            end
		            return l_num
		        end

	        #Randomly generates secret word/phrase
		        def gensecretword
		        	rand_index = rand(@wordtable.length)
		        	@secret_clue = @descr[rand_index]
		        	@num_words = @wordtable[rand_index].split(" ").length
		            return @wordtable[rand_index].upcase
		        end

	        #Sets the secret word and creates a console template
		        def setsecretword word
		            @secretword = word
		            templ = createtemplate
					word_templ = templ.gsub("[","").gsub("]","")
					i=0
					sec_word_array=@secretword.chars
					while i < sec_word_array.length do
						if sec_word_array[i] == " "
					       @resulta[i] = " "
					    else
					    	@resulta[i] = "_"
				        end
				        i+=1
				    end
		        end

	        #Returns the secret word/phrase
		        def getsecretword
		           return @secretword
		        end

	        #Creates console template (not used in this implementation)
		        def createtemplate
		            chars_num = @secretword.length
		            line = ""
		            line_char = "_"
		            while chars_num > 0 do
		            	line += line_char
		            	chars_num -= 1
		            end
		            templ = "[#{line}]"
		            return templ
		        end

	        #Inkrements the turns taken   
		        def incrementturn
		            @turn +=1
		            getturnsleft
		        end

	        #Returns the number of turns left
		        def getturnsleft
		            @turnsleft = GOES - @turn
		        end

	        #Checks if it is last turn
		        def check_last_turn
		        	if @turnsleft < 2
		        		"Last turn! Try to solve the puzzle."
		        	else
		        		"#{@turnsleft}"
		        	end
		        end

		        #Takes the user's input inside the getguess method and returns it
		        def take_user_word_input
								@input.gets.chomp.upcase
				end

		    #Handles the user's guess
				def getguess guess
					@spin_flag = false
				 if guess.length == 1
				   if check_repeated_choice guess
				     @message = "Already guessed this letter!"
				        if @console
								@output.puts "#{@message}"
								word_input = take_user_word_input
								valid = false
							    while !valid do
		                        if validate_input word_input
		                        valid = true
		                        else
		                        @output.puts "Invalid input"
		                        word_input = take_user_word_input
		                        end
							    end
								if check_enter word_input
										@break_flag = true
								else
								 getguess word_input
								end
						else
							@spin_flag = true
				       end
				   else
				   	@message="Guess a letter from the word/phrase."
				    @guess_counter+=1
				    check_guess guess
				    set_guess_analysis guess
				   end
				    success = check_phrase @resulta.join(',').gsub(",","")
				    return success ? true : false
				else
					 if check_phrase guess
						 phrase = @secretword.chars
						 i = 0
						 while i < phrase.length do
										@resulta[i] = phrase[i]
										i += 1
						 end
						 return true
					 else
						 @num_guessed = 0
						 incrementturn
						 @guess_counter+=1
						 set_guess_analysis guess
						 return false
					 end
				end
				end

		        def set_guess_analysis guess
		        	@game_analysis["Guess_#{@guess_counter}"]["Guess"]=guess
					@game_analysis["Guess_#{@guess_counter}"]["Guessed"]=@num_guessed
					@game_analysis["Guess_#{@guess_counter}"]["Score"]="#{@reward.to_i * @num_guessed}"
					@game_analysis["Guess_#{@guess_counter}"]["Total_Score"]=@score
					@game_analysis["Guess_#{@guess_counter}"]["Result_#{@guess_counter}"]=@resulta.to_s
					@game_analysis["Guess_#{@guess_counter}"]["Turns_Left"]=@turnsleft
		        end

		        def set_spin_analysis
		        	@game_analysis["Spin_#{@spin_counter}"]["Reward"]=@reward
		        end

	        # Checks if the user enters a character that is already guessed
				def check_repeated_choice guess
					@resultb.include? guess
				end

		    #Checks the guess entered by user and sets the result array if the input is a match
				def check_guess guess
				 @resultb.push(guess)
				 phrase = @secretword.chars
				 i = 0
				 @num_guessed = 0
				 while i < phrase.length do
								if phrase[i] == guess
								 @resulta[i] = guess
								 @num_guessed += 1
								end
								i += 1
				 end
								if @num_guessed > 0
								@score += (@reward.to_i * @num_guessed)
							    else
							    incrementturn
								end
		       end

	        #Sets the initial state of the board game
		       def init_word_board
		                if @resulta.size == 0
							readwordfile(@filename)
							@descr = @phrases
							setsecretword(gensecretword)
						end
		       end

		        #Randomly selects a reword from the wheel
						def get_wheel_reward
								return rand(@wheel.length)
						end

		        #Simulates a wheel spin and sets the reward
						def spin
							@spin_flag = true
							@spin_counter+=1
							@reward = @wheel[get_wheel_reward]
							set_spin_analysis
							out = nil
							case @reward
					when "Free spin"
						out = "1"
						@turn -= 1
						getturnsleft
						@spin_flag = false
					when "Lose a turn"
						out = "2"
						incrementturn
						@spin_flag = false
					when "Bankrupt"
						out = "3"
						@score = 0
						@spin_flag = false
					end
								return out
						end
		        #Check the input if the user tries to guess the whole phrase
						def check_phrase guess
								if guess == @secretword
									incement_score
									@win = true
									return true
								else
									return false
								end
						end
		        # Checks if user enters empty input to exit the game and go back to console menu
						def check_enter key
							key == "" || key.match(/\A[[:blank:]]+\z/)
						end
		        # Uncovers the phrase
						def show_phrase
								phrase = @secretword.chars
					i = 0
					while i < phrase.length do
									@resulta[i] = phrase[i]
								i += 1
					end
						end
	             #Validates single letter guess unput
						def validate_input input
							if @console
		                    (input.match(/\A[[:alpha:][:blank:]]+\z/) || (check_enter input)) && (input.size < 2)
		                    else
		                    input.match(/\A[[:alpha:][:blank:]]+\z/) && !(check_enter input)
		                    end
		                end
	            #Validates word/phrase guess unput
		                def validate_input_last input
		                    if @console
		                    input.match(/\A[[:alpha:][:blank:]]+\z/) || (check_enter input)
		                    else
		                    input.match(/\A[[:alpha:][:blank:]]+\z/) && !(check_enter input)
		                    end
		                end

		    # Any code/methods aimed at passing the RSpect tests should be added above.

				end
		end
