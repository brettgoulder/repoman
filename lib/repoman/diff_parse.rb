module Repoman
  class DiffParse

    def initialize(repo, file, branch = 'master')
      @repo        = Grit::Repo.new(repo)
      @rugged_repo = Rugged::Repository.new(repo)
      @file        = file
      @branch      = branch
    end

    def log
      @repo.git.log({ :pretty => 'raw' }, '--follow', '--topo-order', '-p', '-U1', @branch, "--", @file)
    end

    def parse
      split_commits(log).map do |commit|
        info, diff = info_and_diff(commit)
        {
          info: info.to_hash,
          file: @rugged_repo.file_at(info.to_s, @file).split(/\n/),
          diff_parts: split_diff(diff.diff)
        }
      end.reverse
    end

    def split_commits(log)
      log.split(/\ncommit /).map { |commit| "commit #{commit}" }
    end

    def info_and_diff(commit)
      commit.match(/(^commit .+)(?:\n)(diff .+)/m)[1..2]
      [Grit::Commit.list_from_string(@repo, $1).first, Grit::Diff.list_from_string(@repo, $2).first]
    end

    def split_diff(diff)
      header_matcher = /(@@ [-+](?:\d+)(?:,(?:\d+))? [-+](?:\d+)(?:,(?:\d+))? @@)/
      diff.split(header_matcher).drop(1).each_slice(2).map do |part|
        hunk= {
          start_line: part[0].match(/\b(\d+),\d+/)[1].to_i,
          number_of_lines: part[0].match(/\b\d+,(\d+)/)[1].to_i,
        }
        hunk[:lines] = part[1].split(/\n/).map do |line|
          next if line.length == 0
          {
            type: line_type(line)
          }
        end.compact
        hunk
      end
    end

private

    def line_type(line)
      if line.match(/\+/)
        "add"
      elsif line.match(/\-/)
        "remove"
      else
        "unchanged"
      end
    end
  end
end
