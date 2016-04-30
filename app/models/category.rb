class Category < ActiveRecord::Base

  has_many :snippets, dependent: :nullify

  validates :kind, presence: true

end
