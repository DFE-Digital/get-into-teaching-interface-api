module ApplyConsole
  def start
    show_environment_banner
    setup_prompt
    IRB::Irb.new.run(IRB.conf)
  end

  def show_environment_banner
    if HostingEnvironment.production?
      puts "*" * 50
      puts "** You are in the Rails console for PRODUCTION! **".red
      puts "*" * 50
    else
      puts "-" * 65
      puts "-- Rails console for the #{HostingEnvironment.environment_name} environment. --"
      puts "-" * 65
    end
  end

  def setup_prompt
    IRB.setup(nil)
    custom_prompt = ConsolePrompt.generate_prompt

    IRB.conf[:PROMPT][:Apply] = {
      PROMPT_I: custom_prompt,
      PROMPT_N: custom_prompt,
      PROMPT_S: nil,
      PROMPT_C: nil,
      RETURN: "=> %s\n",
    }

    IRB.conf[:PROMPT_MODE] = :Apply
  end
end

class ConsolePrompt
  def self.generate_prompt(app_name: self.app_name)
    environment = HostingEnvironment.environment_name.send(env_color)
    "#{app_name} (#{environment})> "
  end

  def self.env_color
    return :red if HostingEnvironment.production?
    HostingEnvironment.review? ? :purple : :yellow
  end

  def self.app_name
    "get-into-teaching-interface-api"
  end
end

if defined?(Rails::Console)
  Rails::Console.prepend(ApplyConsole)
end
