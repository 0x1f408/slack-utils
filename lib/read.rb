# Read out all files
# https://api.slack.com/methods/files.list
# Required params: API token
require 'lib/helpers/query_constructor'

@method = 'files.list'
@params = {
    token: '',
    ts_to: '',
    count: '1000',
    types: '',
    channel: ''
}

