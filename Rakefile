def null_device
  Gem.win_platform? ? "/nul"  : "/dev/null"
end

def git_status
  `git status 2>#{null_device} | tail -n +2`
end

def git_clean?
  git_status = `git status 2>#{null_device} | tail -n1`
  clean = git_status.match(/ clean/)
  !!clean
end

def new_posts?
  untracked_files = git_status.match(/Untracked[\d\w\s:("<>.)\/-]*\n\n/).to_s
  untracked_posts = untracked_files.match(/(_posts\/[\d\w\/.-]*[\s]*)+/).to_s[0..-3].split("\n\t")
end

def modified_posts?
  modified_files = git_status.match(/modified[\d\w\s\/.:-]*\n\n/).to_s
  modified_posts = modified_files.match(/(modified:   _posts[\d\w\/.:-]*[\s]*)+/).to_s[0..-3].split("\n\t")
  modified_posts.collect { |post|
    post[post.index("_posts")..-1]
  }
end

def get_post_title (post)
  unless (post =~ /_posts/)
    puts "not a post: ",post
  else
    title_start = "_posts/2017-01-01-".length
    title_end = post.reverse.index(".") + 2
    post_title = post[title_start..-title_end]
  end
end

def git_add (file, message)
  # puts message
  system "git add #{file} && git commit -m \"#{message}\""
end

def git_push(branch)
  system "git push origin #{branch}"
end

desc "Deploy to the deploy_branch, and push the sources to source_branch"
task :deploy do
  source_branch = 'sources'
  deploy_branch = 'master'

  unless git_clean?

    if new_posts?
      new_posts?.each do |post|
        msg = "+post: "+ get_post_title(post)
        git_add(post,msg)
      end
    end

    if modified_posts?
      modified_posts?.each do |post|
        msg = "^post: "+ get_post_title(post)
        git_add(post,msg)
      end
    end
  end

  unless git_clean?
    puts "there is uncommited changes, commit or discard them and run deploy again"
  else
    puts "jekyll build ..."
    ENV["JEKYLL_ENV"] = "production"
    build_err = `bundle exec jekyll b 2>&1 1>#{null_device}` # if all is good return an empty string. else return the err

    if build_err.empty?
      puts "build successfaly"
      git_push(source_branch)

      Dir.chdir("_site") do
        unless File.exist?(".nojekyll")
          File.new(".nojekyll","w")
        end
        msg = "Site updated at #{Time.now.utc}"
        git_add("-A",msg)
        git_push(deploy_branch)
      end
    end
  end
end
