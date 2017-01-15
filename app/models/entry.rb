class Entry < ApplicationRecord
  acts_as_taggable
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true

  def self.search(term)
    term_array = []
    # Duplicate the term, so it can be used in the title and and the content
    term.downcase.split().each do |t|
      term_array.push("%#{t}%")
      term_array.push("%#{t}%")
    end

    # Create 1 query per term and concatenate them into 1 string
    query_text = 'LOWER(title) LIKE ? OR LOWER(content_plain) LIKE ?'
    query = Array.new(term.split().length, query_text).join(' AND ')

    where(query, *term_array)
  end
end
