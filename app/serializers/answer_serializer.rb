class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :user_id, :question_id, :best, :rating,
             :created_at, :updated_at, :short_body

  belongs_to :user
  has_many :links
  has_many :comments
  has_many :files

  def short_body
    object.body.truncate(7)
  end

  def files
    object.files.map do |file|
      { id: file.id, url: rails_blob_path(file, only_path: true) }
    end
  end
end
