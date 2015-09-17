require_relative 'phone_number'

class Contact < ActiveRecord::Base

  has_many :phone_numbers

  validates :firstname, presence: true, length: { minimum: 1 }
  validates :lastname, presence: true, length: { minimum: 1 }

  def to_s
    "\nID:\t\t#{id}\nFirst name:\t#{firstname}\nLast name:\t#{lastname}\nEmail:\t\t#{email}\nPhone numbers:\t#{phone_numbers.map(&:to_s).join(', ')}".colorize(:yellow)
  end

end
