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

  unless posts?
    puts "there is no new or modefied post\n\n"
  else
    Rake::Task['git:add_posts'].invoke
  end

  unless git_clean?
    puts "there is uncommited changes, commit or discard them and run deploy again".red.bold
  else

    Rake::Task['jekyll:build'].invoke("production")

    # git_push(source_branch)

    Dir.chdir("_site") do
      unless File.exist?(".nojekyll")
        File.new(".nojekyll","w")
      end
      # Rake::Task['git:publish'].invoke(deploy_branch)
    end
  end
end
