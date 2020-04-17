class GistService
  GIST_ID_FORMAT = /\w*$/
  GIST_NO_EXIST = 'No such a gist'

  attr_reader :url
  attr_accessor :response

  def initialize(url)
    @url = url
    @client = Octokit::Client.new(access_token: ENV['GITHUB_GIST_TOKEN'])
  end

  def call
    self.response = @client.gist(gist_id)
    parsed_body
  rescue Octokit::NotFound
    GIST_NO_EXIST
  end

  private

  def parsed_body
    response.files.to_h.values.map { |f| [f[:filename], f[:content]].join('---') }.join('***')
  end

  def gist_id
    GIST_ID_FORMAT.match(url)[0]
  end
end
