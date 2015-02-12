class Dungeon
	attr_accessor :player

	def initialize(player_name)
		@player = Player.new(player_name)
		@rooms = []
	end

	def start(location)
		@player.location = location
		show_current_description
	end

	def show_current_description
		puts find_room_in_dungeon(@player.location).full_description + ". Now which way?"
	end

	def find_room_in_dungeon(reference)
		@rooms.detect { |room| room.reference == reference}
	end

	def find_room_in_direction(direction)
		find_room_in_dungeon(@player.location).connections[direction]
	end

	def go(direction)
		puts "You go " + direction.to_s
		@player.location = find_room_in_direction(direction)
		show_current_description
	end

	def add_room(reference,name,description,connections)
		@rooms << Room.new(reference,name,description,connections)
	end

	class Player
		attr_accessor :name, :location

		def initialize(name)
			@name = name
		end
	end

	class Room
		attr_accessor :reference, :name, :description, :connections

		def initialize(reference, name, description, connections)
			@reference = reference
			@name = name
			@description = description
			@connections = connections
		end

		def full_description
			@name + "\n\nYou are in " + @description
		end
	end
end

my_dungeon = Dungeon.new("Fred Bloggs")

my_dungeon.add_room(:largecave, "Large Cave", "a large cavernous cave", {:west => :smallcave, :north => :freedom, :east => :smallcave, :south => :undergroundriver})

my_dungeon.add_room(:smallcave, "Small Cave", "a small, claustrophobic cave", {:east => :largecave, :north => :undergroundriver, :west => :hiddenpassage, :south => :hiddenpassage})

my_dungeon.add_room(:hiddenpassage, "Hidden Passage", "a mysterious hidden passageway", {:east => :undergroundriver, :west => :undergroundriver, :south => :largecave, :north => :smallcave})

my_dungeon.add_room(:undergroundriver, "Underground River", "a dank, babbling undergound river", {:east => :smallcave, :north => :largecave, :west => :hiddenpassage, :south => :largecave})

my_dungeon.add_room(:freedom, "Freedom!", "an existential parallel universe", {:south => :largecave})

my_dungeon.start(:smallcave)

puts "You're stuck in a Dungeon.  Which way is out?"
input = gets.chomp.downcase

until my_dungeon.player.location == :freedom
	if input == "north" || input == "south" || input == "east" || input == "west"
		my_dungeon.go(input.to_sym)
		input = gets.chomp.downcase
	else
		puts "That is not a valid direction.  Try again."
		input = gets.chomp.downcase
	end
end



