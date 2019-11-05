class Parking < ApplicationRecord
  self.table_name = 'parking'

  validates :plate, presence: true, format: {with: /\A[A-Z]{3}[0-9]{4}\Z/, message: 'must follow the pattern AAA-9999.'}
end
