class SearchService
  RESOURCES = {
    question: "Question",
    answer: "Answer",
    comment: "Comment",
    user: "User"
  }

  def self.call(search_params)
    resource = search_params[:resource]
    keywords = search_params[:keywords]

    searching_klass = RESOURCES.fetch(resource, "ThinkingSphinx").constantize
    searching_klass.search ThinkingSphinx::Query.escape(keywords)
  end
end
