require 'spec_helper'

module Repoman
  describe DiffParse do
    let(:dummy_repo) { File.path("spec/fixtures/dummy_repo") }
    let(:file) { File.path("b.rb") }

    describe '#initialize' do
      it 'should initialize with a repo and a file' do
        Repoman::DiffParse.should_receive(:new).with(dummy_repo, file)
        Repoman::DiffParse.new(dummy_repo, file)
      end

      it 'should create a new repo object' do
        Grit::Repo.should_receive(:new).with(dummy_repo)
        Repoman::DiffParse.new(dummy_repo, file)
      end
    end

    describe '#split_commits' do
      before do
        @parser = Repoman::DiffParse.new(dummy_repo, file)
        @log = @parser.log
      end

      it 'should split a received log into an array of commits' do
        @parser.split_commits(@log).count.should == 4
      end
    end

    describe '#info_and_diff' do
      before do
        @parser = Repoman::DiffParse.new(dummy_repo, file)
        log = @parser.log
        @commit = @parser.split_commits(@parser.log)[0]
      end

      it 'should create a new commit object' do
        @parser.info_and_diff(@commit)[0].should be_a_kind_of(Grit::Commit) 
      end

      it 'should create a new diff object' do
        @parser.info_and_diff(@commit)[1].should be_a_kind_of(Grit::Diff) 
      end

    end
  end
end
