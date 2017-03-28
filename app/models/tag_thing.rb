class TagThing < ActiveRecord::Base
  belongs_to :tag
  belongs_to :thing

  validates :tag, :thing, presence: true

  scope :with_name,    ->{ joins(:thing).select("tag_things.*, things.name as thing_name")}
  scope :with_value, ->{ joins(:tag).select("tag_things.*, tags.value as tag_value")}
end
