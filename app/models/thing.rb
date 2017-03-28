class Thing < ActiveRecord::Base
  include Protectable
  validates :name, :presence=>true

  has_many :thing_images, inverse_of: :thing, dependent: :destroy
  has_many :tag_things, inverse_of: :thing, dependent: :destroy

  scope :no_tags, ->(tag) { where.not(:id=>TagThing.select(:thing_id)
                                                          .where(:tag=>tag)) }

  scope :not_linked, ->(image) { where.not(:id=>ThingImage.select(:thing_id)
                                                          .where(:image=>image)) }
end
