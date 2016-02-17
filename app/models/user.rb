class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def vote_for(object, value)
    vote = self.votes.new(votable: object, value: value)
    vote.save unless voted_for?(object)
  end

  def unvote_for(object)
    self.votes.where(votable: object).delete_all
  end

  def voted_for?(object)
    self.votes.where(votable: object).any?
  end
end
