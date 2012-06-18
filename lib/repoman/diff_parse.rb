module Repoman
  class DiffParse

    def initialize(repo, file, branch = 'master')
      @repo = Grit::Repo.new(repo)
      @file = file
      @branch = branch
    end

    def log
      @repo.git.log({ :pretty => 'raw' }, '--follow', '--topo-order', '-p', '-U1', @branch, "--", @file)
    end

    def split_commits(log)
      log.split(/\ncommit /).map { |commit| "commit #{commit}" }
    end

    def info_and_diff(commit)
      commit.match(/(^commit .+)(?:\n)(diff .+)/m)[1..2]
      [Grit::Commit.list_from_string(@repo, $1).first, Grit::Diff.list_from_string(@repo, $2).first]
    end

    def parse
      split_commits(log).map do |commit|
        info, diff = info_and_diff(commit)
        {
          info: info.to_hash,
          diff: split_diff(diff.diff),
        }
        require 'pry'; binding.pry
      end.reverse
    end

    def split_diff(diff)
      diff.split(/@@ [-+](\d+)(,(\d+))? [-+](\d+)(,(\d+))? @@/).map.with_index do |part, index|
        if index == 0
          next
        elsif line.match(/\b(\d+),\d+/)
          @diff = {
            start_string: line.match(/\b(\d+),\d+/)[1].to_i,
            number_of_lines: line.match(/\b\d+,(\d+)/)[1].to_i
          }
        elsif line.match(/(\+|-)/)
          @diff['lines'] = part.split(/\n/)
        end
      end
    end

  end
end
