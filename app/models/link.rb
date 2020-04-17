class Link < ApplicationRecord
  GIST_URL_FORMAT = %r{^https://gist.github.com/.+$}

  before_create :update_body, if: ->(link) { link.url =~ GIST_URL_FORMAT }

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url,
            format: { with: URI::DEFAULT_PARSER.make_regexp },
            if: ->(link) { link.url.present? }

  def update_body
    self.body = gist_body
  end

  private

  def gist_body
    GistService.new(url).call
  end
end
