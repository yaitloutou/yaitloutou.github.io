# == Dependencies ==============================================================

require "rake"

Rake.add_rakelib 'lib/tasks'

# == Configuration =============================================================

source_branch = 'sources'
deploy_branch = 'master'

# == Helpers ===================================================================

def null_device
  Gem.win_platform? ? "/nul" : "/dev/null"
end

class String
  # text decoration
  def bold;           "\033[1m#{self}\033[0m" end
  # text color
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def yellow;         "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end

end

# == Tasks =====================================================================

desc "Deploy to the deploy_branch, and push the sources to source_branch"
task :deploy do

  p "---------------------------"
  p "    START DEPLOY           "
  p "---------------------------"
  puts

  unless posts?
    puts "there is no new or modefied post"
    puts
  else
    Rake::Task['git:add_posts'].invoke
  end

  unless git_clean?
    puts "there is uncommited changes, commit or discard them and run deploy again".red.bold
    puts
  else
    begin
      Rake::Task['jekyll:build'].invoke("production")
      puts "build succeeded".green

      Rake::Task['git:push'].invoke(source_branch)

      Dir.chdir("_site") do
        p "--- >> _site --------------"

        # unless File.exist?(".nojekyll")
        #   File.new(".nojekyll","w")
        # end

        # Rake::Task['git:publish'].reeanble
        puts deploy_branch
        Rake::Task['git:publish'].invoke(deploy_branch)

        p "--- << _site --------------"
      end

    rescue Exception => e
      # puts "build failed".red
      puts e.backtrace
    end

  end

  p "--- END   DEPLOY ----------"
end
