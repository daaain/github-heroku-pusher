require 'sinatra'
require 'json'
require 'git'
require 'heroku'

get '/' do
  'Hello, world - I am a deployer.'
end

get '/public_key' do
  ::CURRENT_SSH_KEY
end

get '/status' do
  c = GitPusher.local_state(ENV['GITHUB_REPO'])
  "SHA: #{c.sha} | Date: #{c.date}"
end

get '/nuke-repos' do
  `rm -r repos`
  'Nuked!'
end

get '/force-push' do
  GitPusher.deploy(ENV['GITHUB_REPO'])
  'Success!'
end

post '/post-receive' do
  data = JSON.parse(params[:payload])
  url  = data['repository']['url']
  GitPusher.deploy(url)
  "Success!"
end

require_relative 'lib/init'