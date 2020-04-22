class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :answers
  has_many :questions
  has_many :awards
  has_many :votes

  def author_of?(model)
    id == model.user_id
  end

  def voted_for?(model)
    votes.where(votable: model).exists?
  end

  def vote_for(model)
    votes.where(votable: model).first
  end
end
