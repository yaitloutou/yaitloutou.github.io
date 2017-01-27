# == Dependencies ==============================================================

# == Configuration =============================================================

# == Helpers ===================================================================

def get_post_title (post)
  unless (post =~ /_posts/)
    puts "[#{post}] is not a post"
  else
    title_start = "_posts/2017-01-01-".length
    title_end = post.reverse.index(".") + 2
    post_title = post[title_start..-title_end]
  end
end

# general git methods
def git_status
  `git status 2>#{null_device} | tail -n +2`
end

def git_clean?
  git_status = `git status 2>#{null_device} | tail -n1`
  clean = git_status.match(/ clean/)

  !!clean
end

def posts? no_posts = (new_posts.empty? and modified_posts.empty?)

  (no_posts ? nil : [new_posts.length, modified_posts.length])
end

# add <file>, and commit it with <msg>
def git_add(file, msg)
  `git add #{file} && git commit -m \"#{msg}\"`
end

def git_push(to)
  `git push #{to}`
end

# jekyll git methods

def new_posts
  untracked_files = git_status.match(/Untracked[\d\w\s:("<>.)\/-]*\n\n/).to_s
  untracked_posts = untracked_files.match(/(_posts\/[\d\w\/.-]*[\s]*)+/).to_s[0..-3].split("\n\t")
end

def modified_posts
  modified_files = git_status.match(/modified[\d\w\s\/.:-]*\n\n/).to_s
  modified_posts = modified_files.match(/(modified:   _posts[\d\w\/.:-]*[\s]*)+/).to_s[0..-3].split("\n\t")
  modified_posts.collect { |post|
    post[post.index("_posts")..-1]
  }
end

def add_posts(posts, msg_prefix)
  if posts
    posts.each do |post|
      msg = msg_prefix + get_post_title(post)
      puts git_add(post,msg)
      puts
    end
  end
end

# == Tasks =====================================================================

namespace :git do

  # general git tasks -----------------------------------------------------------

  desc "add <file> (default: all), and commit with given <msg> (default: 'Site updated at: TIME_UTC')"
  task :add, [:msg,:file] do |t, args|

    p "---------------------------"
    p "    start git:add          "
    p "---------------------------"
    # default args values
    defaul_file = "-A"
    defaul_msg = "Site updated at #{Time.now.utc}"
    args.with_defaults(:file => defaul_file, :msg => defaul_msg)
    # init args
    file = args[:file]
    msg = args[:msg]

    puts "git add #{file} && git commit -m \"#{msg}\"".bold
    p "---------------------------"

    puts git_add(file, msg)
    puts

    p "--- end   git:add ---------"
    puts
  end

  desc "push to <branch>"
  task :push, [:branch] do |t,args|

    p "---------------------------"
    p "    start git:push         "
    p "---------------------------"
    # init arg
    branch = args[:branch]
    to = "origin #{branch}"

    puts "git push #{to}".bold
    p "---------------------------"

    puts git_push(to)
    puts

    p "--- end   git:push --------"
    puts
  end

  desc "add all, commit, then push to <branch>"
  task :publish, [:branch] do |t,args|

    branch = args[:branch]

    if branch
      p "---------------------------"
      p "    start git:publish      "
      p "---------------------------"

      puts "on branch #{branch}".bold
      p "---------------------------"

      Rake::Task['git:add'].reenable
      Rake::Task['git:add'].invoke

      Rake::Task['git:push'].reenable
      Rake::Task['git:push'].invoke(branch)

      p "--- end   git:publish ----"
      puts
    end
  end

  # jekyll git tasks ------------------------------------------------------------

  desc "add each new or modified post, and commit it with appropiate message"
  task :add_posts do

    p "---------------------------"
    p "    start git:add_posts    "
    p "---------------------------"

    add_posts(new_posts, "+post: ")
    add_posts(modified_posts, "^post: ")

    p "--- end   git:add_posts ---"
    puts
  end

end
