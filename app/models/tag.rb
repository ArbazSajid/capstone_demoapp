class Tag < ActiveRecord::Base
  include Protectable
  has_many :tag_things, inverse_of: :tag, dependent: :destroy
  has_many :things, through: :tag_things
end
