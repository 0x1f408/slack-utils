# Delete content from channels, if specified
# https://api.slack.com/methods/files.delete
# Required params: API token, file ID
# syntax:
#   slackutils delete [-f <date>] [-n <count>] [-t <types>] [-c <channels>] or
#   slackutils delete filename
require 'lib/helpers/query_constructor'
require 'optparse'
require 'ostruct'

@method = 'files.delete'
@params = {}

@options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-h', '--help', 'Shows this help') { puts opt and exit }
  opt.on('-v', '--verbose', 'Give verbose output') { |v| @options[:verbose] = v }
  opt.on('-b', '--before DATETIME', 'Delete posts older than this') { |o| @options[:dated_before] = o }
  opt.on('-a', '--after DATETIME', 'Delete posts newer than this') { |o| @options[:dated_after] = o }
  opt.on('-n', '--count COUNT', 'Number of posts to delete') { |o| @options[:count] = o }
  opt.on('-t', '--type TYPE', "Type(s) of posts to delete. Valid: \nall,spaces,snippets,images,gdocs,zips,pdfs") { |o| @options[:type] = o }
  opt.on('-c', '--channel CHANNEL', 'Channel(s) to target') { |o| @options[:channel] = o }
  # todo: add something later on to parse if multiple channels are given,
  # todo: and to distinguish between IDs/channel names
end.parse!

qc = QueryConstructor.new(@params, @method)
response = qc.call

private

# Method- and context-specific parsing
def parse(response)

end