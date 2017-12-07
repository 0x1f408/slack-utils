require 'net/http'
require 'json'

@token = ''     # Slack API token
@channels = []  # Channel IDs to specifically target
# future: blacklist certain files from being deleted

def list_files(channel)
  ts_to = (Time.now - 3 * 30 * 24 * 60 * 60).to_i # 90 days ago
  params = {
      token: @token,
      ts_to: ts_to,
      count: 1000,
      types: 'images,videos',
      channel: channel
  }
  uri = URI.parse('https://slack.com/api/files.list')
  uri.query = URI.encode_www_form(params)
  response = Net::HTTP.get_response(uri)
  JSON.parse(response.body)['files']
end

def delete_files(file_ids)
  file_ids.each do |file_id|
    params = {
        token: @token,
        file: file_id
    }
    uri = URI.parse('https://slack.com/api/files.delete')
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    p "#{file_id}: #{JSON.parse(response.body)['ok']}"
  end
end

size = 0
n = 0
@channels.each do |channel|
  puts "Deleting files from #{channel}..."
  @files = list_files(channel)
  @files.each do |file|
    n += 1
    size += file['size']
  end
  file_ids = @files.map { |file| file['id'] }
  delete_files(file_ids)
end
puts "#{size/1024/1024} MB space freed; #{n} files nuked."
