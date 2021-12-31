#Character class , java style [that sounds sooo wrong]
#
#
#require 'text_library_file'
require 'cli/ui'


class Utils
  private :new

  def prompt(*args)
    print(*args)
    gets.chomp
  end

end

class DnDChar

  def initialize(**kwargs)
    #add basic details
    #find a loop
    @name = kwargs[:name]
    @age = kwargs[:age]
  end

  def to_json
  end

  def from_json
  end


end


class PC < DnDChar


  def intitialize
    #walk people through character creation

  end

  def update(level)

  end

  def roll(skill)
  end

end


class NPC <DnDChar

end


module UserInterface

  #include libary_module
  include CLI
  include CLI::UI
  CLI::UI::StdoutRouter.enable

  def create_PC

    #get name and age
       #implement are you sure? error checking for things that might be mistakes
    #wrap into a function
    current = PC.new()
    current.name = ask_input("Name: ")
    current.age = ask_input("Age: ",true).to_i


  end

  def ask_input(prompt_str,allow_empty= false)#, vals)
     loop do
      entered = Prompt.ask(prompt_str, allow_empty=allow_empty)
      if Prompt.confirm("you chose #{entered}. are you sure?")
        return entered
      end
     end
  end

  # def are_you_sure(entered)
  #   answer = Utils.prompt("you chose #{entered}. are you sure? (y/n)")
  #   return answer == 'y'


end
