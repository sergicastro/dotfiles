#!/usr/bin/ruby

######################################
#   UPDATE GIT REPOS AUTOMATICALLY   #
######################################
# - Call this script from your shell configuration file, p.ex add the following line:
#       $HOME/.dotfiles/update_gitrepos.rb
# - Use config file (.gitrepouptade.yml) to enumerate the repos to update

require "yaml"
require "logger"

@@logger = Logger.new(STDOUT)
@@last_update_file = nil

# Git command helper
class GitCommands

    # Returns <true> if there are some not stashed changes in the actual branch of the actual repo.
    def is_actual_branch_dirty?
        !(`git status --short`.empty?)
    end

    # Returns the actual branch of the actual repo.
    def get_actual_branch
        `git branch | grep \\*`.split(" ")[1]
    end

    # Changes to the given branch the actual repo.
    # Params:
    # +branch+:: the branch where move to.
    def change_to_branch branch
        `git checkout #{branch} > /dev/null 2>&1`
    end

    # Fetches the actual repo with remote called <origin>
    def fetch_repo
        `git fetch origin > /dev/null 2>&1`
    end
end

# Simple manager to check if the repo is up to date
class GitRepoManager
    @git_commands = GitCommands.new

    # Checks if a given repo in a given path needs to be updated and ask to user for it.
    # Params:
    # +repo_path+:: path of the git repository to check
    # +branch+:: branch name to check
    def check_for_updates(repo_path, branch)
        @@logger.debug "Checking #{repo_path} for updates..."
        actual_location = Dir.pwd
        Dir.chdir repo_path

        actual_branch = @git_commands.get_actual_branch
        local_branch = branch
        remote_branch = 'origin/' << branch
    
        if @git_commands.is_actual_branch_dirty?
            @@logger.info "There are not stashed changes in branch #{actual_branch}"
            @@logger.info "...Aborting update"
            return
        end

        # move to branch and fetch remote
        @git_commands.change_to_branch local_branch
        @git_commands.fetch_repo
    
        if not is_up_to_date?(remote_branch, local_branch)
            puts "#{repo_path} needs updates to sync remote:"
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
                        @@logger.info "...Aborting update"
                end
            end
            @@logger.error ">>> " << error unless error.nil?
        else
            @@logger.debug "...Already up to date"
        end
    
        # return to orginal state
        @git_commands.change_to_branch actual_branch
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
        @@logger.debug "\tremote commit: #{remote_commit}\n\tlocal commit: #{local_commit}"
        return remote_commit.eql? local_commit
    end
end

# Simple manager to store the last update check
# TODO store time by repo (use yaml)
class TimeManager

    # Returns <true> if its time to check for updates again
    def will_check_for_updates?
        if @@last_update_file.nil? or @@last_update_file.empty?
            @@last_update_file = "/tmp/gitreposupdated"
        end
        last_update = nil

        if File.exist? @@last_update_file
            last_update = read_time(@@last_update_file)
        end

        if last_update.nil? or Time.now.to_i - last_update > 24 * 60 * 60
            write_time(@@last_update_file)
            return true
        end
        return false
    end

    private

    # Saves the last time when fir repos were checked for updates
    # Params:
    # +file+:: file name where store the time
    def write_time(file)
        file = File.new(file,"w")
        file.puts(Time.now.to_i)
        file.close
    end

    # Loads the last time when git repos were checked for updates
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
end

# Simple manager to load the config file
# Atributtes:
# +modules+:: list of modules to check (each one contains path and branch)
class ConfigManager
    attr_accessor :modules

    def initialize
        conf = YAML.load_file(ENV["HOME"]+"/.gitrepoupdate.yml")
        @modules = conf["modules"]
        
        #last updated file
        @@last_update_file = conf["last-update-file"]
        #logger
        @@logger.formatter = proc do |serverity, time, progname, msg|
            "#{msg}\n"
        end
        @@logger.level = case conf["log-level"]
                      when "info"
                          Logger::INFO
                      when "debug"
                          Logger::DEBUG
                      when "warn"
                          Logger::WARN
                      when "error"
                          Logger::ERROR
                      when "fatal"
                          Logger::FATAL
                      else
                          Logger::INFO
                      end
    end
end

# Main execution of the script
def main
    config = ConfigManager.new
    if TimeManager.new.will_check_for_updates?
        gitrepo_manager = GitRepoManager.new
        config.modules.each do |gitmodule|
            gitrepo_manager.check_for_updates gitmodule["path"], gitmodule["branch"]
        end
    end
end

# execute it
main
