require 'sinatra'
require 'json'
require 'repoman'

module Repoman
  class App < Sinatra::Application

    configure do
      set :static, true
      set :port, 4567
    end

    get '/' do
      erb :index
    end

    get '/commits.json' do
      content_type :json
      parsed_commits = Repoman::DiffParse.new(File.expand_path('.'), ARGV[0]).parse
      if !parsed_commits.empty? 
        parsed_commits.to_json
      else
      end
    end

    not_found do
      erb :not_found
    end

    error do
      erb :error
    end

  end
end
