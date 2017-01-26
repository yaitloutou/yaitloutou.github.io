# == Dependencies ==============================================================

# == Configuration =============================================================

# == Helpers ===================================================================

def null_device
  Gem.win_platform? ? "/nul"  : "/dev/null"
end

def jekyll_build(env)

  ENV["JEKYLL_ENV"] = env                         # set build environment

  build_err =
    `bundle exec jekyll b 2>&1 1>#{null_device}`  # build, and return stderr
end

# == Tasks =====================================================================

namespace :jekyll do

  desc "build"
  task :build, [:env] do |t, args|
    # default args values
    defaul_env = "development"
    args.with_defaults(:env => defaul_env)
    # initialize args
    env = args[:env]

    p "build, with JEKYLL_ENV = "+ env
    build_err = jekyll_build(env)

    status = build_err ? build_err : "build successfuly"
    p status

    success = !build_err

    unless success
      exit 1
    end
  end

end
