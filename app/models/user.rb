class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :facebook]

  has_many :answers
  has_many :questions
  has_many :awards
  has_many :votes
  has_many :authorizations, dependent: :destroy

  def author_of?(model)
    id == model.user_id
  end

  def voted_for?(model)
    votes.where(votable: model).exists?
  end

  def vote_for(model)
    votes.where(votable: model).first
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
