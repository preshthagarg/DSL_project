# Character class , java style [that sounds sooo wrong]
#
#
# require 'text_library_file'
require 'cli/ui'

module Utils
  def prompt(*args)
    print(*args)
    gets.chomp
  end
end

class DnDChar
  def initialize(**kwargs)
    # add basic details
    # find a loop
    @name = kwargs[:name]
    @age = kwargs[:age]
  end

  def roll(skill); end

  def to_hash
  end

  def from_hash(hash)
  end

  def to_json(file=@name+".json"); end

  def from_json(file); end
end

class PC < DnDChar
  def intitialize(*args)
  end

  def update(level); end

end

class NPC < DnDChar
end

class DnDClass
  # TODO: Separate features like ASI, etc. from messy features like sneak attack
  def initialize(*args)
    @name=name
    @desc=desc
    @caster=caster # Spellcaster?
    @subclasses=subclasses
    @features=features
    @proficiencies=proficiencies
    @levels=[] # List of lists. Each list within @levels is a list of features gained at that level. A feature is either a hash or a string.
    # Incomplete
  end
end

class DnDSubClass
  # TODO: Separate features like ASI, etc. from messy features
  def initialize(*args)
    @superclass=superclass
  end
end

class DnDRace
end
class DnDSubRace
end
module UserInterface
  # include libary_module
  include CLI
  include CLI::UI
  CLI::UI::StdoutRouter.enable

  def create_PC
    # get name and age
    # implement are you sure? error checking for things that might be mistakes
    # wrap into a function
    current = PC.new
    current.name = ask_input('Name: ')
    current.age = ask_input('Age: ', true).to_i
  end

  def ask_input(prompt_str, allow_empty = false) # , vals)
    loop do
      entered = Prompt.ask(prompt_str, allow_empty = allow_empty)
      return entered if Prompt.confirm("you chose #{entered}. are you sure?")
    end
  end

  # def are_you_sure(entered)
  #   answer = Utils.prompt("you chose #{entered}. are you sure? (y/n)")
  #   return answer == 'y'
end
module Dice
end
