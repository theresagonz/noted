class Tag < ActiveRecord::Base
  has_many :note_tags
  has_many :notes, through: :note_tags
  has_many :users, through: :notes

  # converts spaces to hyphens and removes non-alpha characters
  def slug
    self.word.strip.gsub(" ", "-").gsub(/[^\w-]/, '')
  end

  # iterates through each tag to find a matching slug
  def self.find_by_slug(slug)
    Tag.all.find {|tag| tag.slug == slug}
  end
end
