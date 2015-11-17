require 'sinatra'
require 'premailer'
require 'pony'

get '/' do
  @files = Dir.glob('views/mailers/*.{erb}').map {|file| file.split('/').last.gsub('.erb', '')}
  erb :index
end

get '/:name' do |name|
  erb ('mailers/' + name).to_sym, layout: false
end

get '/premailer/:name' do |name|
  premailer = premailer_it name
  premailer.to_inline_css
end


get '/sendmail/:name' do |name|
  premailer = premailer_it name

  Pony.mail({
    to: 'sender@example.com',
    subject: '[TEST] Just a test',
    body: premailer.to_plain_text,
    html_body: premailer.to_inline_css,
    via: :smtp,
    via_options: {
      address: 'smtp.gmail.com',
      port: '587',
      enable_starttls_auto: true,
      user_name: 'yourmail@gmail.com',
      password: '',
      authentication: 'plain'
    }
  })

  erb 'Sended! :D'
end
