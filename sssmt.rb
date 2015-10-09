require 'sinatra'
require 'tempfile'
require 'premailer'

get '/' do
  @files = Dir.glob('views/mailers/*.{erb}').map {|file| file.split('/').last.gsub('.erb', '')}
  erb :index
end

get '/:name' do |name|
  erb ('mailers/' + name).to_sym, layout: false
end

get '/premailer/:name' do |name|
  # Make It Better
  premailer = Premailer.new(request.base_url + '/' + name, warn_level: Premailer::Warnings::SAFE)
  premailer.to_inline_css
end


get '/sendmail/:name' do |name|
  erb name
end
