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
        Map.new(
          info: info.to_hash,
          diff: diff.diff,
        )
      end.reverse
    end

  end
end
