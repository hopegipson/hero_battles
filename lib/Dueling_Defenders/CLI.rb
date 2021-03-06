class CLI

    def run
        system("clear")
        @user_input = nil
        @userhero = nil
        @enemyhero = nil
        welcome

        until @user_input == "6"
          main_menu
        end
      end
    
    def welcome
        puts "Welcome to the Superhero Battleground".colorize(:blue)
        puts "
         ________________             
       //.,------------,\\\\            
      //  .=^^^^^^^^^^\__|\\\\           
      \\\\   `--------.   .//           
       \\\\--........_  `;//            
         \\\\.-,______;.//              
           \\\\---..--//                
             \\\\    //                 
               \\\\//                   ".colorize(:color => :red, :background => :blue)   
    end

    def goodbye
        puts "\n"
        puts "Goodbye, go save the world!".colorize(:blue)
        puts "\n"
    end

    def main_menu
        puts "\n"
        puts "What would you like to do?"
        puts "1. Search for information on a Hero"
        puts "2. Change Your User Hero"
        puts "3. Learn about User Hero"
        puts "4. Battle a Different Hero"
        puts "5. How many battles has each hero won/lost?"
        puts "6. Exit"
    
        @user_input = gets.chomp

        case @user_input
        when "1"
          search_for_hero
        when "2"
         make_hero_user
        when "3"
          learn_about_user
        when "4"
            battle
        when "5"
            battlecount
        when "6"
            goodbye
          exit
        else
          puts "Invalid input".colorize(:red)
        end
    end

    def search_for_hero
        print "What hero would you like to search for? "
        heroinput = gets.chomp
        hero = Hero.find_or_create_by_name(heroinput)
        noheroexists?(hero) || hero.printnicely
    end

    def noheroexists?(hero)
        if hero == "No hero like that exists"
            puts "\n"
            puts hero.colorize(:red)
            return true
        else
            return false
        end
    end

    def make_hero_user
        print "What hero would you like to become?"
        herotobecome = gets.chomp
        hero = Hero.find_or_create_by_name(herotobecome)
        noheroexists?(hero) || (@userhero = hero 
        puts "\n"
        puts "Your hero is now #{hero.name}".colorize(:blue))
    end

    def learn_about_user
        nouserhero? || @userhero.printnicely
    end

    def nouserhero?
        if @userhero == nil
            puts "\n"
            puts "You need to pick a hero first, change user hero".colorize(:red)
            return true
        else
            return false
        end
    end

    def battle
        nouserhero? || make_enemy_user
       if @enemyhero!=nil 
        sureaboutbattle
       end
    end
    
    def make_enemy_user
        @enemyhero = nil
        puts "\n"
        print "What hero would you like to battle?"
        enemyinput = gets.chomp
            hero = Hero.find_or_create_by_name(enemyinput)
            noheroexists?(hero) || (@enemyhero = hero
            if @enemyhero.name.downcase == @userhero.name.downcase
                puts "\n"
                puts "You can't fight yourself.".colorize(:red)
                make_enemy_user
            else
                puts "\n"
                puts "You have chosen #{@enemyhero.name} to fight.".colorize(:red)
        end)
    end

    def sureaboutbattle
        puts "\n"
        puts "Are you ready to battle #{@enemyhero.name}?"
        puts "Yes"
        puts "No"

        sureaboutbattleinput = gets.chomp
        input = sureaboutbattleinput.downcase

        case input
        when "yes"
            testusers
        when "no"
            puts "\n"
            puts "Coward.".colorize(:red)
        else 
            puts "I didn't understand that.".colorize(:red)
            sureaboutbattle
        end
    end

    def testusers
        puts "\n"
        puts "The heroes are fighting...."
        sleep(2)
        puts "\n"

        @enemyheropoints = 0
        @userheropoints = 0

        test_attributes

        if @enemyheropoints > @userheropoints
            puts "#{@enemyhero.name} has defeated you!".colorize(:red)
            @userhero.loseabattle
            @enemyhero.winabattle

        elsif @userheropoints > @enemyheropoints
            puts "#{@userhero.name} has won the battle! Hooray!".colorize(:green)
            @userhero.winabattle
            @enemyhero.loseabattle
        elsif @userheropoints == @enemyheropoints
           puts "Our heroes are evenly matched...maybe they should fight together, not each other...".colorize(:blue)
        end
    end
   
    def test_attributes 
        @userhero.attributes.each_index do |i|
          if @enemyhero.attributes[i].to_i > @userhero.attributes[i].to_i;
              @enemyheropoints += 1;
          elsif @enemyhero.attributes[i].to_i < @userhero.attributes[i].to_i;
              @userheropoints += 1
              end 
        end
    end

    def battlecount
        if Hero.all == []
            puts "\n"
            puts "No heroes in battleground yet. Search for heroes to add them to battleground, or become one.".colorize(:red)
        else
            Hero.all.each do |hero|
            puts "\n"
            puts "#{hero.name}:".colorize(:blue)
            puts  "Has won #{hero.battleswon} battle(s)."
            puts  "Has lost #{hero.battleslost} battle(s)."
            end
        end
    end

end