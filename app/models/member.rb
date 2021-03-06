require 'pry'
class Member < ActiveRecord::Base
    has_many :records
    has_many :clubhouses, through: :records

###################################SIGN IN/CREATE PROFILE METHODS#######################################

    def self.greeting_menu
        Interface.greeting
        while 
            input = (gets.chomp).downcase
            case input
                when "sign in"
                    Interface.sign_in_username_prompt
                    break
                when "create profile"
                    Member.create_profile
                    break
                when "exit"
                    Interface.thank_you_exit
                else
                    puts "Please enter a valid option."
                    break
            end
        end
    end
    
    def self.check_username
        loop do 
            user_input = gets.chomp
            if !Member.find_by(name: user_input)
                if user_input.downcase == 'create profile'
                    Member.create_profile
                    break
                end
            Interface.unrecognized_username
            else
                member = Member.find_by(name:user_input)
                $user_id = member.id
                break
            end
        end
    end
    
    # def self.greeting_menu
    #     Interface.greeting
    #     input = gets.chomp
    #     if input.downcase == "sign in"
    #         Interface.sign_in_username_prompt
    #     elsif input.downcase == "create profile"
    #         Member.create_profile
    #     elsif input.downcase == "exit"
    #         Interface.thank_you_exit
    #     end
    # end
  


    def self.get_user_age
        puts "Please enter your age."
        age = gets.chomp
        age = age.to_i
        if age >= 21
            puts "Your account has been created. Time to have some fun!"

        end
    end

    def self.get_user_age
        puts "                 Please enter your age."
        age = gets.chomp
        age = age.to_i
        if age >= 21
            puts "                 Your account has been created. Time to have some fun!"
        else
            Interface.under_age
        end 
        age
    end
    
    def self.get_all_usernames 
        Member.all.map do |x|
            x.name 
        end
    end
    
    def self.create_username
        puts "                 Please enter a username."
        name = gets.chomp
        until !Member.get_all_usernames.include?(name)
            puts "                   This username is already taken."
            puts "                 Please enter a different username."
            name = gets.chomp
        end
        name
    end
    
    def self.create_profile
        name = Member.create_username
        age = Member.get_user_age
        member = Member.create(name: name, age: age, tier: "bronze", visits: 0)
        $user_id = member.id
    end 

########################################################################################################
########################################USER DATA ACCESS METHODS########################################

    def self.set_user_info 
        Member.find_by(id: $user_id)
    end

########################################################################################################
########################################USER OPTIONS METHODS############################################

    def self.change_username
        name = Member.create_username
        Member.set_user_info.update(name: name)
        puts "Username successfully changed."
        Member.member_homepage
    end

    def self.user_visits_count
        member = Member.set_user_info
        member.visits
    end

    def self.member_homepage
        Interface.member_homepage_display
        input = (gets.chomp).downcase
        while
            case input
                when "choose clubhouse"
                    Interface.choose_clubhouse_prompt
                    break
                when "view history"
                    puts "Placeholder for record of clubhouse visits"
                    Member.member_homepage
                    break
                when "change username"
                    Member.change_username
                    break
                when "delete profile"
                    Member.delete_profile
                    break
                when "exit"
                    Interface.thank_you_exit
                else
                    puts "Please enter a valid option."
                break
            end
        end
    end

    def self.delete_profile
        Interface.delete_profile_prompt
        
        while input = (gets.chomp).downcase
            case input
            when "delete"
                obj = Member.set_user_info
                obj.destroy
                puts "           Your profile was successfully deleted."
                Interface.thank_you_exit
                break
            when "go back"
                Member.member_homepage
                break
            else
                puts "Unrecognized entry."
                puts "Please enter 'DELETE' or 'GO BACK'."
            end
        end
    end

        
######################################################################################################## 
########################################USER CLUBHOUSE METHODS##########################################

    def self.getting_clubs_matching_members
        #returns an array of all the clubhouses for a gold, silver, or bronze member
         
            # tiers 'gold' > 'silver' > 'bronze'
            if Member.set_user_info.tier == 'gold'

                puts <<-GOLD
    __________________________________
    ___________________________          
    ____██████╗ ██████╗  ██████╗ ███╗   ██╗███████╗███████╗       &&&&& 
    __  ██╔══██╗██╔══██╗██╔═══██╗████╗  ██║╚══███╔╝██╔════╝      &&   &&
    _   ██████╔╝██████╔╝██║   ██║██╔██╗ ██║  ███╔╝ █████╗          &&&
        ██╔══██╗██╔══██╗██║   ██║██║╚██╗██║ ███╔╝  ██╔══╝        &&   &&
        ██████╔╝██║  ██║╚██████╔╝██║ ╚████║███████╗███████╗     &&     &&
        ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝       &&&&&  &&
          
         ███████╗██╗██╗    ██╗   ██╗███████╗██████╗      ██████╗██╗     ██╗   ██╗██████╗ ███████╗
         ██╔════╝██║██║    ██║   ██║██╔════╝██╔══██╗    ██╔════╝██║     ██║   ██║██╔══██╗██╔════╝
         ███████╗██║██║    ██║   ██║█████╗  ██████╔╝    ██║     ██║     ██║   ██║██████╔╝███████╗
         ╚════██║██║██║    ╚██╗ ██╔╝██╔══╝  ██╔══██╗    ██║     ██║     ██║   ██║██╔══██╗╚════██║
         ███████║██║███████╗╚████╔╝ ███████╗██║  ██║    ╚██████╗███████╗╚██████╔╝██████╔╝███████║___
         ╚══════╝╚═╝╚══════╝ ╚═══╝  ╚══════╝╚═╝  ╚═╝     ╚═════╝╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝___
                                                                              ______________________
                                                                                      ______________
                                                                                              ______
                                                                                                                        
                        
                ------------------PLUS YOU HAVE UNLOCKED ACCESS TO ALL------------------------
                ██████╗  ██████╗ ██╗     ██████╗      ██████╗██╗     ██╗   ██╗██████╗ ███████╗
                ██╔════╝ ██╔═══██╗██║     ██╔══██╗    ██╔════╝██║     ██║   ██║██╔══██╗██╔════╝
                ██║  ███╗██║   ██║██║     ██║  ██║    ██║     ██║     ██║   ██║██████╔╝███████╗
                ██║   ██║██║   ██║██║     ██║  ██║    ██║     ██║     ██║   ██║██╔══██╗╚════██║
                ╚██████╔╝╚██████╔╝███████╗██████╔╝    ╚██████╗███████╗╚██████╔╝██████╔╝███████║
                ╚═════╝  ╚═════╝ ╚══════╝╚═════╝      ╚═════╝╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝
                ------------------------------------------------------------------------------

                


            GOLD
                    clubhouses = Clubhouse.all.select do |club|
            

        
                club.tier == 'gold' ||  club.tier == 'silver' || club.tier == 'bronze'


                
                    end
                

                elsif Member.set_user_info.tier == 'silver'

                    puts <<-PART1


__________________________________
___________________________          
____██████╗ ██████╗  ██████╗ ███╗   ██╗███████╗███████╗       &&&&& 
____██╔══██╗██╔══██╗██╔═══██╗████╗  ██║╚══███╔╝██╔════╝      &&   &&
__  ██████╔╝██████╔╝██║   ██║██╔██╗ ██║  ███╔╝ █████╗          &&&
    ██╔══██╗██╔══██╗██║   ██║██║╚██╗██║ ███╔╝  ██╔══╝        &&   &&
    ██████╔╝██║  ██║╚██████╔╝██║ ╚████║███████╗███████╗     &&     &&
    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝       &&&&&  &&
        

             PART1
             puts <<-SILVER            
             ███████╗██╗██╗    ██╗   ██╗███████╗██████╗      ██████╗██╗     ██╗   ██╗██████╗ ███████╗
             ██╔════╝██║██║    ██║   ██║██╔════╝██╔══██╗    ██╔════╝██║     ██║   ██║██╔══██╗██╔════╝
             ███████╗██║██║    ██║   ██║█████╗  ██████╔╝    ██║     ██║     ██║   ██║██████╔╝███████╗
             ╚════██║██║██║    ╚██╗ ██╔╝██╔══╝  ██╔══██╗    ██║     ██║     ██║   ██║██╔══██╗╚════██║
             ███████║██║███████╗╚████╔╝ ███████╗██║  ██║    ╚██████╗███████╗╚██████╔╝██████╔╝███████║
             ╚══════╝╚═╝╚══════╝ ╚═══╝  ╚══════╝╚═╝  ╚═╝     ╚═════╝╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝
                                                                                     ________________
                                                                                            _________
                                                                                               ______
                                                                                                        
         SILVER
                    clubhouses = Clubhouse.all.select do |club|
                        club.tier == 'silver' || club.tier == 'bronze' 
                        
               

                    end
                else
                    
                    puts  <<-BRONZE
                
        
                    ██████╗ ██████╗  ██████╗ ███╗   ██╗███████╗███████╗     ██████╗██╗     ██╗   ██╗██████╗ ███████╗
                    ██╔══██╗██╔══██╗██╔═══██╗████╗  ██║╚══███╔╝██╔════╝    ██╔════╝██║     ██║   ██║██╔══██╗██╔════╝
                    ██████╔╝██████╔╝██║   ██║██╔██╗ ██║  ███╔╝ █████╗      ██║     ██║     ██║   ██║██████╔╝███████╗
                    ██╔══██╗██╔══██╗██║   ██║██║╚██╗██║ ███╔╝  ██╔══╝      ██║     ██║     ██║   ██║██╔══██╗╚════██║
                    ██████╔╝██║  ██║╚██████╔╝██║ ╚████║███████╗███████╗    ╚██████╗███████╗╚██████╔╝██████╔╝███████║
                    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝     ╚═════╝╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝
                                                                                                                    
                BRONZE
                    clubhouses = Clubhouse.all.select do |club|
                        club.tier == Member.set_user_info.tier
           
                     

                    end


                
                end

                clubhouses.each do |club|
                puts "#{club.name}-#{club.tier}"
            end
        
    end
# def self.getting_club_name_tier

#     getting_clubs_matching_members.each do |club|
#         puts "#{club.name}-#{club.tier}"

# end
# end

########################################################################################################

end


