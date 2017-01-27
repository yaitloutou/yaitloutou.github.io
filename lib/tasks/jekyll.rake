# == Dependencies ==============================================================

# == Configuration =============================================================

# == Helpers ===================================================================

def null_device
  Gem.win_platform? ? "/nul"  : "/dev/null"
end

def jekyll_build(env)

  ENV["JEKYLL_ENV"] = env                         # set build environment

  build = `bundle exec jekyll b 2>&1 1>#{null_device}`  # build, and return stderr
  $? == 0
end

# == Tasks =====================================================================

namespace :jekyll do

  desc "build"
  task :build, [:env] do |t, args|

    p "---------------------------"
    p "    start jekyll:build     "
    p "---------------------------"
    puts
    # default args values
    defaul_env = "development"
    args.with_defaults(:env => defaul_env)
    # initialize args
    env = args[:env]

    puts "build, with JEKYLL_ENV = #{env}".bold
    p "---------------------------"
    puts

    build_succeed = jekyll_build(env)

    # puts build_succeed ? "build succeeded".green : "build failed".red
    # puts

    p "--- end   jekyll:build ----"
    unless build_succeed
      exit 1
    end
  end
end
