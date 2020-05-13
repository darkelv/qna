module SearchHelper
  def search_resources
    SearchService::RESOURCES.keys.unshift('all').map { |key| [key, key] }
  end
end
