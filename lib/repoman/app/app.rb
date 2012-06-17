require 'sinatra'
class App
 
  set :static, true
  set :port, 4242

  get '/' do
    erb :index
  end

  not_found do
    haml :not_found
  end

  error do
    haml :error
  end

end
