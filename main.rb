require_relative 'lib/chess'

# setup game with human and cpu player
def setup_one_plr
  puts "White, enter your name:"
  name = STDIN.gets.chomp
  game = Chess.new(name, 'Computer')
  game.plr2.type = :cpu
  game.board.setup_pieces
  game.play
end

# setup game with two human players
def setup_two_plrs
  puts 'White, enter your name:'
  name1 = STDIN.gets.chomp
  puts 'Black, enter your name:'
  name2 = STDIN.gets.chomp
  game = Chess.new(name1, name2)
  game.board.setup_pieces
  game.play
end

# display list of saved games if there are any
def display_saves
  if Dir.glob("saves/*").empty?
    puts 'No saves found!'
    main_menu
  else
    puts "Found the following saves:\n"
    puts Dir.glob("saves/*").join("\n")
  end
end

# init a serialized game object with given name, if it exists
def load_game(name)
  if File.exist?("saves/#{name}")
    Marshal.load(File.open("saves/#{name}", 'r'))
  else
    puts 'Save not found.'
    main_menu
  end
end

# choose a save from the list and load it
def start_loaded_game
  display_saves
  puts 'Type the name of your save:'
  name = STDIN.gets.chomp
  game = load_game(name)
  game.play
end

# display choices for starting a new or saved game
def main_menu
  puts "Welcome to Chess!\n\n[N]ew Game\n[L]oad Game\n[Q]uit\n"
  input = STDIN.gets.chomp.downcase
  case input
  when 'n'
    puts "[1] Player\n[2] Players\n[B]ack\n"
    input = STDIN.gets.chomp.to_s.downcase
    case input
    when '1' then setup_one_plr
    when '2' then setup_two_plrs
    when 'b' then main_menu
    else
      puts 'Invalid input!'
      main_menu
    end
  when 'l'
      start_loaded_game
  when 'q'
    puts 'Thanks for playing! Goodbye!'
    exit
  else
    puts 'Invalid input!'
    main_menu
  end
end

main_menu
