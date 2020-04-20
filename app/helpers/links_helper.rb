module LinksHelper
  def link_gist(gist_string)
    parse_content(gist_string)
  end

  private

  def parse_content(gist_string)
    gist_string
      .split('***')
      .map { |f| f.split('---') }
      .map { |header, content| "<p>#{header}<br>#{content}</p>" }
      .join('').html_safe
  end
end
