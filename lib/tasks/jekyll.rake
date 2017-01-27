# == Dependencies ==============================================================

# == Configuration =============================================================

# == Helpers ===================================================================

def null_device
  Gem.win_platform? ? "/nul"  : "/dev/null"
end

def jekyll_build(env)

  ENV["JEKYLL_ENV"] = env                         # set build environment

  build = `bundle exec jekyll b 2>&1 `  # build, and return stderr
end

# == Tasks =====================================================================

namespace :jekyll do

  desc "build"
  task :build, [:env] do |t, args|

    p "---------------------------"
    p "   start jekyll:build      "
    p "---------------------------"
    puts
    # default args values
    defaul_env = "development"
    args.with_defaults(:env => defaul_env)
    # initialize args
    env = args[:env]

    puts "build, with JEKYLL_ENV = #{env}".bold
    puts
    puts jekyll_build(env)

    # status = build_err ? build_err : "build successfuly".green
    # puts status

    # success = !build_err

    # unless success
    #   exit 1
    # end

    p "---------------------------"
    p "   end   jekyll:build      "
    p "---------------------------"
  end
end
