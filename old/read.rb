require 'net/http'
require 'json'
require 'openssl'

@client_id = ''
@client_secret = '' # since slack updated to OAuth.access
@token = ''


# 'Content-Type':'application/json' is invalid for oauth.access requests
@content_type = 'application/x-www-form-urlencoded'

@host = 'https://slack.com/api/'

def get_file_list
  params = {
      token: @token,
      count: 1000
  }

  # Build our request
  uri = URI.parse("#{@host}files.list")
  uri.query = URI.encode_www_form(params)
  response = Net::HTTP.get_response(uri)

  # Look for 'files' in response body
  JSON.parse(response.body)['files']
end

files = get_file_list
@users = Hash.new
@users.default = 0
size = 0
n = 0

# Get username from user ID
def deanonymize(id)
  params = {
      token: @token,
      user: id
  }
  uri = URI.parse("#{@host}users.info")
  uri.query = URI.encode_www_form(params)
  response = Net::HTTP.get_response(uri)

  name = JSON.parse(response.body)['user']['name']
end

if files then files.each do |file|
  if @users.key?(file['user'].to_sym)
    @users[(file['user']).to_sym] += file['size']
  else
    @users[(file['user']).to_sym] = file['size']
  end
  n += 1
  size += file['size']
end
@users.keys.each do |user|
  puts "#{@users[user.to_sym] / (1024)} KB space used by #{deanonymize(user)}."
end
end
# file_ids = files.map { |file| file['id'] } # This doesn't really seem to do anything extra?

puts "#{size/1024/1024} MB space taken by #{n} files."
