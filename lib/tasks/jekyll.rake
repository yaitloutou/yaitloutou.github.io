# == Dependencies ==============================================================

# == Configuration =============================================================

# == Helpers ===================================================================

def jekyll_build(env)

  ENV["JEKYLL_ENV"] = env                         # set build environment

  puts build = `bundle exec jekyll b`# 2>&1 1>#{null_device}`  # build, and return stderr
  $? == 0
end

# == Tasks =====================================================================

namespace :jekyll do

  desc "build"
  task :build, [:env] do |t, args|

    p "---------------------------"
    p "    start jekyll:build     "
    p "---------------------------"
    # default args values
    defaul_env = "development"
    args.with_defaults(:env => defaul_env)
    # initialize args
    env = args[:env]

    puts "JEKYLL_ENV = '#{env}' jekyll build".bold
    p "---------------------------"

    build_succeed = jekyll_build(env)

    # puts build_succeed ? "build succeeded".green : "build failed".red
    # puts
    puts
    p "--- end   jekyll:build ----"
    puts
    unless build_succeed
      exit 1
    end
  end
end
