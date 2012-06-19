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
          diff_parts: split_diff(diff.diff),
          new_file: diff.new_file,
          deleted_file: diff.deleted_file
        }
      end.reverse
    end

    def split_diff(diff)
      header_matcher = /(@@ [-+](?:\d+)(?:,(?:\d+))? [-+](?:\d+)(?:,(?:\d+))? @@)/
      diff.split(header_matcher).drop(1).each_slice(2).map do |part|
        {
          start_line: part[0].match(/\b(\d+),\d+/)[1].to_i,
          number_of_lines: part[0].match(/\b\d+,(\d+)/)[1].to_i,
          lines: part[1]
        }
      end
    end

  end
end
