#!/usr/bin/ruby

######################################
#   UPDATE GIT REPOS AUTOMATICALLY   #
######################################
# - Call this script from your shell configuration file, p.ex add the following line:
#       $HOME/.dotfiles/update_gitrepos.rb
# - Use config file (.gitrepouptade.yml) to enumerate the repos to update

require "yaml"

# Simple manager to check if the repo is up to date
class GitRepoManager

    # Checks if a given repo in a given path needs to be updated and ask to user for it.
    # Params:
    # +repo_paht+:: path of the git repository to check
    # +branch+:: branch name to check
    def check_for_updates(repo_path, branch)
        puts "Checking #{repo_path} for updates..."
        actual_location = Dir.pwd
        Dir.chdir repo_path

        local_branch = branch
        remote_branch = 'origin/' << branch
    
        # fetch remote
        `git fetch origin > /dev/null 2>&1`
    
        if not is_up_to_date?(remote_branch, local_branch)
            puts "Do you want to update? How: merge [m], rebase [r], reset hard [R], abort [a/A]"
            res = gets.chomp
            if not res.nil?
                case res
                    when "m" 
                        error = `git merge #{remote_branch}`
                    when "r"
                        error = `git rebase #{remote_branch}`
                    when "R"
                        puts "This will be delete local changes, are you sure to continue? [N,y]"
                        res = gets.chomp.downcase
                        if not res.nil? and ["yes","y"].include? res
                            error = `git reset --hard #{remote_branch}`
                        end
                    when /a|A/
                        puts "Aborting update..."
                end
            end
            puts ">>> " << error unless error.nil?
        else
            puts "...Already up to date"
        end
    
        Dir.chdir actual_location
    end

    private

    # Returns the last commit hash of a given branch
    # Params:
    # +branch+:: branch name
    def get_last_commit_hash(branch)
        output = `git log -1 #{branch}`
        output.split(' ').first
    end

    # Checks if two branches are in the same commit
    # Params:
    # +remote_branch+:: remote branch name
    # +local_branch+:: local branch name
    def is_up_to_date?(remote_branch, local_branch)
        remote_commit = get_last_commit_hash(remote_branch) 
        local_commit = get_last_commit_hash(local_branch)
        puts "\tremote commit: #{remote_commit}\n\tlocal commit: #{local_commit}"
        return remote_commit.eql? local_commit
    end
end

# Simple manager to store the last update check
# TODO store time by repo (use yaml)
class TimeManager

    # Returns <true> if its time to check for updates again
    def will_check_for_updates?
        time_file = "/tmp/gitreposupdated"
        last_update = nil

        if File.exist? time_file
            last_update = read_time(time_file)
        else
            write_time(time_file)
        end

        if last_update.nil? or Time.now.to_i - last_update > 24 * 60 * 60
            write_time(time_file)
            return true
        end
        return false
    end

    private

    # Load the last time when git repos were checked for updates
    # Params:
    # +file+:: file name where load the time
    def read_time(file)
        res = nil
        File.open(file,"r") do |f|
            f.each_line do |line|
                res = line.to_i
            end
        end
        return res
    end

    # Save the last time when fir repos were checked for updates
    # Params:
    # +file+:: file name where store the time
    def write_time(file)
        file = File.new(file,"w")
        file.puts(Time.now.to_i)
        file.close
    end
end

# Simple manager to load the config file
# Atributtes:
# +modules+:: list of modules to check (each one contains path and branch)
class ConfigManager
    attr_accessor :modules

    def initialize
        conf = YAML.load_file(ENV["HOME"]+"/.gitrepoupdate.yml")
        @modules = conf["modules"]
    end
end

# Main execution of the script
def main
    if TimeManager.new.will_check_for_updates?
        gitrepo_manager = GitRepoManager.new
        ConfigManager.new.modules.each do |gitmodule|
            gitrepo_manager.check_for_updates gitmodule["path"], gitmodule["branch"]
        end
    end
end

# execute
main
